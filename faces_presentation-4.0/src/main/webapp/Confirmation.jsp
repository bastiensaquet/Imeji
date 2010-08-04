<?xml version="1.0" encoding="UTF-8"?>
<!--

 CDDL HEADER START

 The contents of this file are subject to the terms of the
 Common Development and Distribution License, Version 1.0 only
 (the "License"). You may not use this file except in compliance
 with the License.

 You can obtain a copy of the license at license/ESCIDOC.LICENSE
 or http://www.escidoc.de/license.
 See the License for the specific language governing permissions
 and limitations under the License.

 When distributing Covered Code, include this CDDL HEADER in each
 file and include the License file at license/ESCIDOC.LICENSE.
 If applicable, add the following below this CDDL HEADER, with the
 fields enclosed by brackets "[]" replaced with your own identifying
 information: Portions Copyright [yyyy] [name of copyright owner]

 CDDL HEADER END


 Copyright 2006-2007 Fachinformationszentrum Karlsruhe Gesellschaft
 für wissenschaftlich-technische Information mbH and Max-Planck-
 Gesellschaft zur Förderung der Wissenschaft e.V.
 All rights reserved. Use is subject to license terms.
-->


<jsp:root version="2.1" xmlns:f="http://java.sun.com/jsf/core" xmlns:h="http://java.sun.com/jsf/html" xmlns:jsp="http://java.sun.com/JSP/Page">

<jsp:output doctype-root-element="html"
        doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

	<jsp:directive.page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" />
	<f:view locale="#{SessionBean.locale}" xmlns:e="http://www.escidoc.de/jsf">
		<f:loadBundle var="lbl" basename="labels"/>
		<f:loadBundle var="msg" basename="messages"/>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>

				<title><h:outputText value="#{ApplicationBean.applicationName}"/></title>

				<jsp:directive.include file="headerPages/ui/StandardImports.jspf" />

			</head>
			<body lang="#{SessionBean.locale}">
				<h:outputText value="#{SessionBean.checkLogin}" styleClass="noDisplay" />
				<h:outputText value="#{AlbumSession.initCurrentAlbum}" styleClass="noDisplay"></h:outputText>
				<h:outputText value="#{HomePage.init}" styleClass="noDisplay" />
				<h:outputText rendered="#{(SessionBean.user == null) and (SessionBean.currentUrl != 'resource') and (SessionBean.currentUrl == 'viewAlbum')}" value="#{HomePage.resolveAlbum}" />
				
				<h:form id="formular">
					<div class="full wrapper">
						<h:inputHidden id="offset"></h:inputHidden>
						
						<!-- import header -->
						
						<jsp:directive.include file="headerPages/Header.jspf" />
							<div id="content" class="full_area0 clear">
								<!-- begin: content section (including elements that visualy belong to the header (breadcrumb, headline, subheader and content menu)) -->
								<div class="clear">
									<div class="headerSection">
							
										<!--<jsp:directive.include file="headerPages/Breadcrumb.jspf" />-->
										<div class="clear breadcrumb">
												<h:outputLink value="#{SessionBean.backToResultList}" rendered="#{SessionBean.action == 'download'}">
													<h:outputText value="#{lbl.back_to_pictures}"></h:outputText>
												</h:outputLink>
												<h:outputLink value="#{SessionBean.backToResultList}" rendered="#{SessionBean.action != 'download'}">
													<h:outputText value="#{lbl.back_to_album}"></h:outputText>
												</h:outputLink>
										</div>				
										<div id="contentSkipLinkAnchor" class="clear headLine">
											<!-- Headline starts here -->
											<h1>
												<h:outputText value="Confirm"/>
											</h1>
											<!-- Headline ends here -->
										</div>
									</div>
									<div class="small_marginLIncl subHeaderSection">
										<div class="contentMenu">
											<!-- content menu starts here -->
											<div class="free_area0 sub"> 
												<!-- content menu upper line starts here -->
												&#160;
												<!-- content menu upper line ends here -->
											</div>
											<h:panelGroup layout="block" styleClass="free_area0 sub action" >
												<!-- content menu lower line starts here -->
													&#160;
												<!-- content menu lower line ends here -->
											</h:panelGroup>
										<!-- content menu ends here -->
										
										</div>

										<h:panelGroup layout="block" styleClass="subHeader">
											<h:outputText value="" id="message_javascript" styleClass="message"/>
										</h:panelGroup>

										<h:panelGroup layout="block" styleClass="subHeader" rendered="#{(SessionBean.urlQuery != 'error' || SessionBean.pageNotFound) and ((SessionBean.message != null) || (SessionBean.information != null))}">
											<!-- Application Events -->
											<jsp:directive.include file="include/Messages.jspf"/>
										</h:panelGroup>
									</div>
							</div>
							
							<jsp:directive.include file="confirmationPages/Confirmation.jspf" />

						</div>
					<!-- end: content section -->
					</div>
					<jsp:directive.include file="footerPages/Footer.jspf" />
				</h:form>
				<script type="text/javascript">
				$("input[id$='offset']").submit(function() {
					$(this).val($(window).scrollTop());
				});
				$(document).ready(function () {
					$(window).scrollTop($("input[id$='offset']").val());
					$(window).scroll(function(){$("input[id$='offset']").val($(window).scrollTop())});
				});
				</script>	
			</body>
		</html>
	</f:view>
</jsp:root>