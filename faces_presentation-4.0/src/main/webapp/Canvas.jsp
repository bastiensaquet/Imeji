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


 Copyright 2006-2009 Fachinformationszentrum Karlsruhe Gesellschaft
 für wissenschaftlich-technische Information mbH and Max-Planck-
 Gesellschaft zur Förderung der Wissenschaft e.V.
 All rights reserved. Use is subject to license terms.
-->
<jsp:root version="2.1" xmlns:f="http://java.sun.com/jsf/core" xmlns:h="http://java.sun.com/jsf/html" xmlns:tr="http://myfaces.apache.org/trinidad" xmlns:jsp="http://java.sun.com/JSP/Page">
	<jsp:directive.page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"/>
	<jsp:output doctype-root-element="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
	<f:view locale="#{SessionBean.locale}">
		<f:loadBundle var="lbl" basename="labels"/>
		<f:loadBundle var="msg" basename="messages"/>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>
					<h:outputText id="txtApplicationName" value="#{ApplicationBean.applicationName}"/>
				</title>
				<link type="image/x-icon" href="#{Navigation.applicationUrl}resources/icon/escidoc.ico" rel="shortcut icon"/>
				<meta http-equiv="pragma" content="no-cache"/>
				<meta http-equiv="cache-control" content="no-cache"/>
				<meta http-equiv="expires" content="0"/>

		<!--[if IE]><script type="text/javascript" src="#{Navigation.applicationUrl}resources/eSciDoc_JavaScript/canvas/excanvas.js">;</script><![endif]-->
				<script src="#{Navigation.applicationUrl}resources/eSciDoc_JavaScript/jquery/jquery.min.js" type="text/javascript" charset="utf-8">;</script>
				<script src="#{Navigation.applicationUrl}resources/eSciDoc_JavaScript/yahoo/utilities.js" type="text/javascript" charset="utf-8">;</script>
				<script src="#{Navigation.applicationUrl}resources/eSciDoc_JavaScript/canvas/canvasElement.js" type="text/javascript" charset="utf-8">;</script>
				<script src="#{Navigation.applicationUrl}resources/eSciDoc_JavaScript/canvas/canvasImg.js" type="text/javascript" charset="utf-8">;</script>
				<script src="#{Navigation.applicationUrl}resources/eSciDoc_JavaScript/canvas/eSciDocCanvas.js" type="text/javascript" charset="utf-8">;</script>

				<script type="text/javascript" charset="utf-8">
					var CanvasDemo = function() {
						var YD = YAHOO.util.Dom;
						var YE = YAHOO.util.Event;
						var img = [];
						var canvas1;
						return {
							init: function() {
											
							},
							addImage: function(image) {
								if(1 > img.length) {
									canvas1 = new Canvas.Element();
									canvas1.init('canvasArea',  { width: 895, height: 600 });

									img[img.length] = new Canvas.Img('canvasBackground', {});
									canvas1.setCanvasBackground(img[0]);
								}
								img[img.length] = new Canvas.Img(image, {});
								canvas1.addImage(img[img.length-1]);
								this.initEvents();
							},
							initEvents: function() {
								YE.on('togglenone','click', this.toggleNone, this, true);
								YE.on('toggleborders','click', this.toggleBorders, this, true);
								YE.on('togglepolaroid','click', this.togglePolaroid, this, true);
								YE.on('pngbutton','click', function() { this.convertTo('png') }, this, true);
								YE.on('jpegbutton','click', function() { this.convertTo('jpeg') }, this, true);
							},
							switchBg: function() {
								canvas1.fillBackground = (canvas1.fillBackground) ? false : true;							
								canvas1.renderAll();
							},
							toggleNone: function() {
								for (var i = 0, l = canvas1._aImages.length; 1 > i; i += 1) {
									canvas1._aImages[i].setBorderVisibility(false);
								}
								canvas1.renderAll();
							},
							toggleBorders: function() {
								for (var i = 0, l = canvas1._aImages.length; 1 > i; i += 1) {
									canvas1._aImages[i].setBorderVisibility(true);
								}
								canvas1.renderAll();
							},
							togglePolaroid: function() {
								for (var i = 0, l = canvas1._aImages.length; 1 > i; i += 1) {
									canvas1._aImages[i].setPolaroidVisibility(true);
								}
								canvas1.renderAll();
							},
							convertTo: function(format) {
								var imgData = canvas1.canvasTo(format);
								window.open(imgData, "_blank");
							},
							whatever: function(e, o) {
								// console.log(e);
								// console.log(o);
							}
						}
					}();
				</script>

				<style type="text/css">
				   #canvasArea, #canvasArea-canvas-background, #canvasArea-canvas-container {
						position: absolute;
					}
				 </style>


				<link rel="stylesheet" type="text/css" href="#{Navigation.applicationUrl}resources/eSciDoc_CSS/main.css" />
				<link rel="stylesheet" type="text/css" title="high contrast" id="highContrastTheme" href="#{Navigation.applicationUrl}resources/eSciDoc_CSS/themes/skin_highContrast/styles/theme.css" />
			</head>
			<body>
				<h:graphicImage id="canvasBackground" style="position: absolute; top: -1000px; left: -1000px;" value="#{Navigation.applicationUrl}resources/eSciDoc_CSS/themes/skin_highContrast/images/canvasBG.jpg"/>
				<tr:form id="form1">
					<h:panelGroup rendered="#{SessionBean.checkLogin}"/>
					<div class="wrapper">
						<div class="full_area0 header clear">
							<!-- begin: short header section (including meta menu and main menu)-->
					
								<div id="metaMenuSkipLinkAnchor" class="full_area0 metaMenu">
								<!-- meta Menu starts here -->
								
									<!-- logo alternate area starts here || Please use this area only in short headers without logo -->
									<div class="free_area0 small_marginLExcl logoAlternate">
										<h:outputLink value="#{Navigation.applicationUrl}">
											<span>eSciDoc.</span>
				
											<span>FACES</span>
										</h:outputLink>
									</div>
									<!-- logo alternate area ends here -->

								<!-- meta Menu ends here -->
								</div>
					
							<!-- end: short header section -->
						</div>
						<div id="content" class="full_area0 clear">
						<!-- begin: content section (including elements that visualy belong to the header (breadcrumb, headline, subheader and content menu)) -->
			
							<div class="headerSection">	
								<div class="clear breadcrumb">
									<!-- Breadcrumb starts here -->
									<ol>
										<li>&#160;</li>
									</ol>
									<!-- Breadcrumb ends here -->
								</div>
						
								<div id="contentSkipLinkAnchor" class="clear headLine">
			
									<!-- Headline starts here -->
									<h1>Faces Image Dingsda</h1>
									<!-- Headline ends here -->
								</div>
							</div>
							
							<div class="small_marginLIncl subHeaderSection">
								<div class="contentMenu">
								<!-- content menu starts here -->
		
									<div class="free_area0 sub">
									<!-- content menu upper line starts here -->
										<!-- Drop Down Menu - Select an Album -->
										<h:panelGroup rendered="#{SessionBean.allowed}" styleClass="free_area0">Album:&#160;</h:panelGroup>
										<h:selectOneMenu id="my_album_list" onchange="location.href=this.value" value="#{Canvas.selected}" rendered="#{SessionBean.allowed}" styleClass="free_select">
											<f:selectItems value="#{Canvas.albums}" />
										</h:selectOneMenu>
										&#160;
									<!-- content menu upper line ends here -->
									</div>
		
									<h:panelGroup layout="block" styleClass="free_area0 sub action" rendered="#{!(!((Canvas.selected == Canvas.albums[0].value) || (Canvas.selected == 'null')))}">
									<!-- content menu lower line starts here -->
										&#160;
									<!-- content menu lower line ends here -->
									</h:panelGroup>
									<h:panelGroup layout="block" styleClass="free_area0 sub action" rendered="false">
									<!-- content menu lower line starts here -->
										<span class="free_area0">View:&#160;</span>
										<span class="medium_radioBtn"><input type="radio" name="borders" value="" id="togglenone" checked="checked"/><label for="togglenone">None</label></span>
										<span class="medium_radioBtn"><input type="radio" name="borders" value="" id="toggleborders" /><label for="toggleborders">Border</label></span>
										<span class="medium_radioBtn"><input type="radio" name="borders" value="" id="togglepolaroid" /><label for="togglepolaroid">Polaroid</label></span>
									<!-- content menu lower line ends here -->
									</h:panelGroup>
									<h:panelGroup layout="block" styleClass="free_area0 sub action" rendered="#{!((Canvas.selected == Canvas.albums[0].value) || (Canvas.selected == 'null'))}">
									<!-- content menu lower line starts here -->
										<a href="Canvas.jsp" id="resetbutton" >Reset</a>
										<h:panelGroup styleClass="seperator"></h:panelGroup>
										<a id="jpegbutton">Export to JPG</a>
										<h:panelGroup styleClass="seperator"></h:panelGroup>
										<a id="pngbutton">Export to PNG (heavy)</a>
									<!-- content menu lower line ends here -->
									</h:panelGroup>

								<!-- content menu ends here -->
								</div>
								
								<div class="subHeader">
									<!-- Subheadline starts here -->
										<h:outputText rendered="#{!SessionBean.allowed}" value="Please Log in first."/>
										<h:outputText rendered="#{!((!SessionBean.allowed) || (Canvas.selected != Canvas.albums[0].value))}" value="Please select an album."/>
										&#160;
									<!-- Subheadline ends here -->
								</div>
							</div>

							<h:panelGroup styleClass="full_area0 fullItem">
								<div class="full_area0 itemBlock noTopBorder">
									<h3 class="xLarge_area0_p8 endline blockHeader">
										&#160;
									</h3>
									<div class="free_area0 itemBlockContent endline">
										<div class="free_area0 endline itemLine noTopBorder">
											<span class="free_area0_p2 xTiny_marginLExcl endline">
												The FACES Image Dingsda bla blubb....
											</span>
										</div>
									</div>
														
								</div>
								<h:panelGroup layout="block" styleClass="full_area0 itemBlock imageCarousel" style="overflow-x: auto; white-space: nowrap; padding: 0.28em;" rendered="#{!((Canvas.selected == Canvas.albums[0].value) || (Canvas.selected == 'null'))}">
										<tr:iterator var="item" value="#{Canvas.items}" id="list" rows="0">
											<h:graphicImage styleClass="xTiny_marginLIncl" height="127px" value="#{item.thumbnailUrl}"/>
										</tr:iterator>
								</h:panelGroup>

								<h:panelGroup layout="block" styleClass="full_area0 itemBlock" style="height: 600px;" rendered="#{!(!((Canvas.selected == Canvas.albums[0].value) || (Canvas.selected == 'null')))}">
									<canvas id="canvasArea">&#160;</canvas>
								</h:panelGroup>
								<h:panelGroup layout="block" styleClass="full_area0 itemBlock" style="height: 600px;" rendered="#{!((Canvas.selected == Canvas.albums[0].value) || (Canvas.selected == 'null'))}">
									<canvas id="canvasArea">&#160;</canvas>
								</h:panelGroup>

							</h:panelGroup>

						<!-- end: content section -->
						</div>	
					</div>
					<div class="footer">
						<div class="full_area0">
						<!-- begin: footer section-->
							&#160;
						<!-- end: footer section -->
						</div>
					</div>
				</tr:form>
			</body>
			<script type="text/javascript">
			$('.imageCarousel').find('img').click(function(){
					CanvasDemo.addImage(this);
			});
			</script>
		</html>
	</f:view>
</jsp:root>