/**
 * License: src/main/resources/license/escidoc.license
 */
package de.mpg.imeji.logic;

import java.net.URI;

import org.apache.log4j.Logger;

import com.hp.hpl.jena.query.Dataset;
import com.hp.hpl.jena.query.ReadWrite;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.tdb.TDBFactory;
import com.hp.hpl.jena.tdb.sys.SystemTDB;

import de.mpg.imeji.logic.controller.UserController;
import de.mpg.imeji.logic.util.Counter;
import de.mpg.imeji.logic.vo.Album;
import de.mpg.imeji.logic.vo.CollectionImeji;
import de.mpg.imeji.logic.vo.Grant;
import de.mpg.imeji.logic.vo.Grant.GrantType;
import de.mpg.imeji.logic.vo.Item;
import de.mpg.imeji.logic.vo.MetadataProfile;
import de.mpg.imeji.logic.vo.User;
import de.mpg.imeji.presentation.util.PropertyReader;
import de.mpg.j2j.annotations.j2jModel;
import de.mpg.j2j.exceptions.NotFoundException;

public class ImejiJena
{
    public static String tdbPath = null;
    public static String collectionModel;
    public static String albumModel;
    public static String imageModel;
    public static String userModel;
    public static String profileModel;
    public static String counterModel = "http://imeji.org/counter";
    public static Dataset imejiDataSet;
    public static URI counterID = URI.create("http://imeji.org/counter/0");
    private static Logger logger = Logger.getLogger(ImejiJena.class);
    public static User adminUser;

    public static void init()
    {
        try
        {
            // tdbPath = PropertyReader.getProperty("imeji.tdb.path");
            tdbPath = "C:\\Projects\\Imeji\\tdb\\test";
        }
        catch (Exception e)
        {
            throw new RuntimeException("Error reading property imeji.tdb.path", e);
        }
        init(tdbPath);
    }

    public static void init(String path)
    {
        tdbPath = path;
        logger.info("Initializing Jena dataset (" + tdbPath + ")...");
        imejiDataSet = TDBFactory.createDataset(tdbPath);
        logger.info("... done!");
        logger.info("Initializing Jena models...");
        albumModel = getModelName(Album.class);
        collectionModel = getModelName(CollectionImeji.class);
        imageModel = getModelName(Item.class);
        userModel = getModelName(User.class);
        profileModel = getModelName(MetadataProfile.class);
        initModel(albumModel);
        initModel(collectionModel);
        initModel(imageModel);
        initModel(userModel);
        initModel(profileModel);
        initModel(counterModel);
        // logger.info("... done!");
        logger.info("Initializing Admin user...");
        initadminUser();
        logger.info("... done!");
        logger.info("Initializing counter...");
        initCounter();
        logger.info("... done!");
        // logger.info("Transaction supported: " + imejiDataSet.supportsTransactions());
        // logger.info("Jena file access : " + SystemTDB.fileMode().name());
        // logger.info("Jena is 64 bit system : " + SystemTDB.is64bitSystem);
    }

    private static void initModel(String name)
    {
        try
        {
            imejiDataSet = TDBFactory.createDataset(tdbPath);
            // Careful: This is a read locks. A write lock would lead to corrupted graph
            imejiDataSet.begin(ReadWrite.READ);
            if (imejiDataSet.containsNamedModel(name))
            {
                imejiDataSet.getNamedModel(name);
            }
            else
            {
                Model m = ModelFactory.createDefaultModel();
                imejiDataSet.addNamedModel(name, m);
            }
            imejiDataSet.commit();
        }
        finally
        {
            imejiDataSet.end();
        }
    }

    private static void initadminUser()
    {
        try
        {
            if (PropertyReader.getProperty("imeji.sysadmin.email") != null)
            {
                adminUser = new User();
                adminUser.setEmail(PropertyReader.getProperty("imeji.sysadmin.email"));
                adminUser.setName("Imeji Sysadmin");
                adminUser.setNick("sysadmin");
                adminUser.setEncryptedPassword(UserController.convertToMD5(PropertyReader
                        .getProperty("imeji.sysadmin.password")));
                adminUser.getGrants().add(new Grant(GrantType.SYSADMIN, URI.create("http://imeji.org/")));
            }
        }
        catch (Exception e)
        {
            adminUser = new User();
            adminUser.setEmail("admin@imeji.org");
            adminUser.setName("Imeji Sysadmin");
            adminUser.setNick("sysadmin");
            try
            {
                adminUser.setEncryptedPassword(UserController.convertToMD5("password"));
            }
            catch (Exception e1)
            {
                // TODO Auto-generated catch block
                e1.printStackTrace();
            }
            adminUser.getGrants().add(new Grant(GrantType.SYSADMIN, URI.create("http://imeji.org/")));
            // throw new RuntimeException("Error initializing admin user, check your properties", e);
        }
    }

    public static String getModelName(Class<?> voClass)
    {
        j2jModel j2jModel = voClass.getAnnotation(j2jModel.class);
        return "http://imeji.org/" + j2jModel.value();
    }

    public static void initCounter()
    {
        int counterFirstValue = 0;
        try
        {
            counterFirstValue = Integer.parseInt(PropertyReader.getProperty("imeji.counter.first.value"));
        }
        catch (Exception e)
        {
            logger.warn("Property imeji.counter.first.value not found!!! Add property to your property file. (IGNORE BY UNIT TESTS)");
        }
        Counter c = new Counter();
        try
        {
            ImejiRDF2Bean rdf2Bean = new ImejiRDF2Bean(counterModel);
            c = (Counter)rdf2Bean.load(c.getId().toString(), adminUser, c);
            if (c.getCounter() < counterFirstValue)
            {
                createNewCouter(c, counterFirstValue);
            }
            logger.info("IMPORTANT: Counter found with value : " + c.getCounter());
        }
        catch (NotFoundException e)
        {
            logger.warn("IMPORTANT: Counter not found, creating a new one...");
            createNewCouter(c, counterFirstValue);
        }
        catch (Exception e)
        {
            throw new RuntimeException(e);
        }
    }

    private static void createNewCouter(Counter c, int counterFirstValue)
    {
        c.setCounter(counterFirstValue);
        ImejiBean2RDF bean2rdf = new ImejiBean2RDF(counterModel);
        try
        {
            bean2rdf.create(bean2rdf.toList(c), adminUser);
            logger.warn("IMPORTANT: New Counter created with value " + c.getCounter());
        }
        catch (Exception e)
        {
            throw new RuntimeException(e);
        }
    }

    public static void printModel(String name)
    {
        try
        {
            imejiDataSet.begin(ReadWrite.READ);
            imejiDataSet.getNamedModel(name).write(System.out, "RDF/XML-ABBREV");
            imejiDataSet.commit();
        }
        finally
        {
            imejiDataSet.end();
        }
    }
}
