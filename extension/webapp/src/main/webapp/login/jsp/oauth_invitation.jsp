<%--

    Copyright (C) 2009 eXo Platform SAS.
    
    This is free software; you can redistribute it and/or modify it
    under the terms of the GNU Lesser General Public License as
    published by the Free Software Foundation; either version 2.1 of
    the License, or (at your option) any later version.
    
    This software is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    Lesser General Public License for more details.
    
    You should have received a copy of the GNU Lesser General Public
    License along with this software; if not, write to the Free
    Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
    02110-1301 USA, or see the FSF site: http://www.fsf.org.

--%>

<%@ page import="org.exoplatform.container.PortalContainer"%>
<%@ page import="org.exoplatform.services.resources.ResourceBundleService"%>
<%@ page import="org.exoplatform.portal.resource.SkinService"%>
<%@ page import="java.util.ResourceBundle"%>
<%@ page import="org.exoplatform.services.organization.User"%>
<%@ page language="java" %>
<%
    PortalContainer portalContainer = PortalContainer.getCurrentInstance(session.getServletContext());
    ResourceBundleService service = portalContainer.getComponentInstanceOfType(ResourceBundleService.class);
    ResourceBundle res = service.getResourceBundle(service.getSharedResourceBundleNames(), request.getLocale()) ;
    String contextPath = portalContainer.getPortalContext().getContextPath();

    SkinService skinService = PortalContainer.getCurrentInstance(session.getServletContext())
            .getComponentInstanceOfType(SkinService.class);
    String loginCssPath = skinService.getSkin("portal/login", "Default").getCSSPath();

    User detectedUser = (User)request.getAttribute("detectedUser");

    String error = (String)request.getAttribute("invitationConfirmError");

    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Oauth invitation</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="shortcut icon" type="image/x-icon"  href="<%=contextPath%>/favicon.ico" />
    <link href="<%=loginCssPath%>" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="/platform-extension/javascript/jquery-1.7.1.js"></script>
    <script type="text/javascript" src="/platform-extension/javascript/switch-button.js"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            var startlabelfooter = jQuery("#platformInfoDiv").data("labelfooter");
            var htmlContent = startlabelfooter +" eXo Platform ";
            var divContent = jQuery("#platformInfoDiv");
            var requestJsonPlatformInfo = jQuery.ajax({ type: "GET", url: "/portal/rest/platform/info", async: false, dataType: 'json' });
            if(requestJsonPlatformInfo.readyState == 4 && requestJsonPlatformInfo.status == 200){
                //readyState 4: request finished and response is ready
                //status 200: "OK"
                var myresponseText = requestJsonPlatformInfo.responseText;
                var jsonPlatformInfo = jQuery.parseJSON(myresponseText);
                htmlContent += "v"
                htmlContent += jsonPlatformInfo.platformVersion;
                htmlContent += " - build "
                htmlContent += jsonPlatformInfo.platformBuildNumber;
            }else{
                htmlContent += "4.0"
            }
            divContent.text(htmlContent);
        });
    </script>
</head>
<body>
<div class="loginBGLight"><span></span></div>
<div class="uiLogin">
    <div class="loginContainer">
        <div class="loginContent">
            <div class="titleLogin">
                <div class="signinFail">
                    <%= res.getString("UIOAuthInvitationForm.title") %>
                </div>
                <div>
                    <%=res.getString("UIOAuthInvitationForm.message.detectedUser")%>
                    <strong><%= detectedUser.getUserName() %> / <%= detectedUser.getEmail() %></strong>
                </div>
                <div>
                    <%=res.getString("UIOAuthInvitationForm.message.inviteMessage")%>
                </div>
                <div class="signinFail">
                    <%if (error != null) { %>
                        <i class="uiIconError"></i><%=error%>
                    <%}%>
                </div>
            </div>
            <div class="centerLoginContent">
                <form name="registerForm" action="<%= contextPath + "/login"%>" method="post" style="margin: 0px;">
                    <input class="password <%=(error != null ? "error" : "")%>" type="password" name="password" placeholder="<%=res.getString("portal.login.Password")%>" onblur="this.placeholder = '<%=res.getString("portal.login.Password")%>'" onfocus="this.placeholder = ''"/>
                    <input type="hidden" name="confirm_existing_account" value="1"/>
                    <div id="UIPortalLoginFormAction" class="loginButton">
                        <button type="submit" class="button" tabindex="4">Confirm</button>
                    </div>
                    <div>
                        <a class="button" href="<%= contextPath + "/login?create_new_account=1"%>">Create new account</a>
                        <a class="btn btn-primary" href="<%= contextPath + "/login?cancel_oauth=1"%>">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div id="platformInfoDiv" data-labelfooter="<%=res.getString("portal.login.Footer")%>" ></div>
</div>

</body>
</html>
