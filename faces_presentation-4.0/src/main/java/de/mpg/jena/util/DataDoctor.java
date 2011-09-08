package de.mpg.jena.util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import de.mpg.jena.ImejiJena;
import de.mpg.jena.controller.CollectionController;
import de.mpg.jena.controller.GrantController;
import de.mpg.jena.controller.ImageController;
import de.mpg.jena.controller.ImejiController;
import de.mpg.jena.controller.ProfileController;
import de.mpg.jena.controller.UserController;
import de.mpg.jena.vo.CollectionImeji;
import de.mpg.jena.vo.Grant;
import de.mpg.jena.vo.Image;
import de.mpg.jena.vo.MetadataProfile;
import de.mpg.jena.vo.Properties.Status;
import de.mpg.jena.vo.User;

public class DataDoctor 
{
	private List<String> report =null;
	private User user = null;
	
	public DataDoctor(User user) 
	{
		this.user = user;
	}
	
	public List<String> runDoctor(boolean proceed) throws Exception
    {
		report = new ArrayList<String>();
    	
    	runContainerDoctor(proceed);
    	runGrantsDoctor(proceed);
    	runImagesDoctor(proceed);
    	
    	cleanGraphs();
    	
    	return report;
    }
	
	public void cleanGraphs()
	{
		ImageController c = new ImageController(user);
		
		c.cleanGraph(ImejiJena.albumModel);
		c.cleanGraph(ImejiJena.collectionModel);
		c.cleanGraph(ImejiJena.collectionModel);
		c.cleanGraph(ImejiJena.profileModel);
		c.cleanGraph(ImejiJena.userModel);
		
	}
	
	public void eleminateNonStriclyIncreasing()
	{
		
	}
    
    /**
     * Checks album and collections
     * @return
     * @throws Exception 
     */
    public void runContainerDoctor(boolean proceed) throws Exception
    {
    	UserController uc = new UserController(user);
    	uc.cleanGraph();
    	// Compare Status of profile and collection: should be same
    	CollectionController cc = new CollectionController(user);
    	Collection<CollectionImeji> cols = cc.retrieveAll();
    	
    	for (CollectionImeji c : cols)
    	{    		
    		
    		User user = uc.retrieve(c.getProperties().getCreatedBy());
    		ProfileController pc1 = new ProfileController(user);
    		MetadataProfile p = pc1.retrieve(c.getProfile());
    		if (!c.getProperties().getStatus().equals(p.getProperties().getStatus()))
    		{
    			if (proceed)
    			{
    				if (Status.RELEASED.equals(c.getProperties().getStatus()))	{
    					pc1.release(p);
    				}
    				else if ((Status.WITHDRAWN.equals(c.getProperties().getStatus()))){
    					pc1.withdraw(p, user);
    				}
    			}
    			else 
    			{
    				report.add("non valid status of profile: " + c.getProfile() + " (" + p.getProperties().getStatus() 
    						+ ") with collection " + c.getId() + " (" + c.getProperties().getStatus() + ")") ;
    			}
    		}
    	}
    	
    	// remove profiles without collection
    	ProfileController pc = new ProfileController(user);
    	List<MetadataProfile> profiles = pc.retrieveAll();
    	
    	for(MetadataProfile mdp : profiles)
    	{
    		boolean found = false;
    		for (CollectionImeji c : cols)
    		{
    			if(c.getProfile().equals(mdp.getId()))
    			{
    				found = true;
    			}
    		}
    		if (!found)
    		{
    			if (proceed)
    			{
    				pc.delete(mdp, user);
    			}
    			else
    			{
    				report.add("Unsused profile: " + mdp.getId());
    			}
    		}
    	}
    }
    
    
    /**
     * 
     * Search/Delete Grants which are on non existing objects
     * 
     * @param proceed
     * @return
     * @throws Exception 
     */
    public void runGrantsDoctor(boolean proceed) throws Exception
    {
    	// REMOVE NON EXISTING GRANTS
    	UserController uc = new UserController(user);
    	Collection<User> users = uc.retrieveAll();
    	
    	ProfileController pc = new ProfileController(user);
    	List<MetadataProfile> profiles = pc.retrieveAll();
    	
    	CollectionController cc = new CollectionController(user);
    	Collection<CollectionImeji> cols = cc.retrieveAll();
    	
    	for(User u : users)
    	{
    		List<Grant> deadGrants = new ArrayList<Grant>();
    		for (Grant g : u.getGrants())
    		{
    			boolean found = false;
    			
    			for(MetadataProfile mdp : profiles)
    			{
    				if (mdp.getId().equals(g.getGrantFor()))
    				{
    					found = true;
    				}
    			}
    			
    			for(CollectionImeji c : cols)
    			{
    				if (c.getId().equals(g.getGrantFor()))
    				{
    					found = true;
    				}
    			}
    			
    			if(!found && g.getGrantFor()!= null && !g.getGrantFor().toString().contains("album"))
    			{
    				deadGrants.add(g);
    			}
    		}
    		
    		for (Grant g : deadGrants) 
    		{
    			GrantController gc = new GrantController(user);
    			if (proceed)
    			{
    				gc.removeGrant(u, g);
    			}
    			else
    			{
    				report.add("Grant " + g.getGrantType() + " for " + g.getGrantFor() + " is dead");
    			}
			}
    	}
    }
    
    public void runsSharingDoctor(boolean proceed)
    {
    	UserController uc = new UserController(user);
    	Collection<User> users = uc.retrieveAll();
    	
    	ProfileController pc = new ProfileController(user);
    	List<MetadataProfile> profiles = pc.retrieveAll();
    	
    	CollectionController cc = new CollectionController(user);
    	Collection<CollectionImeji> cols = cc.retrieveAll();
    	
//    	for (User u : users)
//    	{
//    		for (Grant g : u.getGrants())
//    		{
//    			for (CollectionImeji c : cols)
//    			{
//    				if (g.getGrantFor().toString().equals(c.getId().toString()))
//    				{
//    					isCollection = true;
//    				}
//    			}
//    			for (MetadataProfile p : profiles)
//    			{
//    				if (g.getGrantFor().toString().equals(c.getId().toString()))
//    				{
//    					isCollection = true;
//    				}
//    			}
//    		}
//    	}
    }
    
    public void runImagesDoctor(boolean proceed) throws Exception
    {
    	ImageController ic = new ImageController(user);
    	
    	CollectionController cc = new CollectionController(user);
    	Collection<CollectionImeji> cols = cc.retrieveAll();
    	
    	for (Image im : ic.retrieveAll())
    	{
    		boolean colFound = false;
    		
    		for (CollectionImeji c : cols)
    		{
    			if (im.getCollection().toString().equals(c.getId().toString()))
    			{
    				colFound = true;
    			}
    		}
    		
    		if (!colFound) 
    		{
				if (proceed) 
				{
					ic.delete(im, user);
				}
				else
				{
					report.add("Image " + im.getId() + " belongs to no collection");
				}
			}
    	}
    }
}
