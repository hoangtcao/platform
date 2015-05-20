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
<%@ page import="org.exoplatform.services.organization.impl.UserImpl" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashSet" %>
<%@ page language="java" %>
<%
    PortalContainer portalContainer = PortalContainer.getCurrentInstance(session.getServletContext());
    ResourceBundleService service = portalContainer.getComponentInstanceOfType(ResourceBundleService.class);
    ResourceBundle res = service.getResourceBundle(service.getSharedResourceBundleNames(), request.getLocale()) ;
    String contextPath = portalContainer.getPortalContext().getContextPath();

    SkinService skinService = PortalContainer.getCurrentInstance(session.getServletContext())
            .getComponentInstanceOfType(SkinService.class);
    String loginCssPath = skinService.getSkin("portal/login", "Default").getCSSPath();

    User user = (User)request.getAttribute("portalUser");
    if (user == null) {
        user = new UserImpl();
    }

    List<String> errors = (List<String>)request.getAttribute("register_errors");
    Set<String> errorFields = (Set<String>)request.getAttribute("register_error_fields");
    if (errors == null) {
        errors = new ArrayList<String>();
    }
    if (errorFields == null) {
        errorFields = new HashSet<String>();
    }

    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Oauth register</title>
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
<div class="uiLogin" style="position: absolute; top: 30%">
    <div class="loginContainer">
        <div class="loginContent">
            <div class="signinFail">
                <% if (errors != null && errors.size() > 0) { %>
                    <i class="uiIconError"></i>
                    <ul>
                        <% for(String s : errors) {%>
                            <li><%=s%></li>
                        <% } %>
                    </ul>
                <%}%>
            </div>
            <div class="centerLoginContent">
                <form name="registerForm" action="<%= contextPath + "/login"%>" method="post" style="margin: 0px;">
                    <input class="username" name="username" type="text" value="<%=(user.getUserName() == null ? "" : user.getUserName())%>" placeholder="<%=res.getString("portal.login.Username")%>" onblur="this.placeholder = '<%=res.getString("portal.login.Username.blur")%>'" onfocus="this.placeholder = ''"/>
                    <input class="password" name="password" type="password" placeholder="<%=res.getString("portal.login.Password")%>" onblur="this.placeholder = '<%=res.getString("portal.login.Password")%>'" onfocus="this.placeholder = ''"/>
                    <input class="password" name="password2" type="password" placeholder="Re enter your password" />
                    <input type="text" name="firstName" value="<%=(user.getFirstName() == null ? "" : user.getFirstName())%>" placeholder="First Name"/>
                    <input type="text" name="lastName" value="<%=(user.getLastName() == null ? "" : user.getLastName())%>" placeholder="Last Name"/>
                    <input type="text" name="displayName" value="<%=(user.getDisplayName() == null ? "" : user.getDisplayName())%>" placeholder="Display name"/>
                    <input type="email" name="email" value="<%=(user.getEmail() == null ? "" : user.getEmail())%>" placeholder="Email address" />
                    <input type="hidden" name="oauth_do_register_new" value="1"/>

                    <div id="UIPortalLoginFormAction" class="loginButton">
                        <button type="submit" class="">Subscribe</button>
                        <button type="reset" class="">Reset</button>
                    </div>
                    <div>
                        <a class="button" href="<%= contextPath + "/login?cancel_oauth=1"%>">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div id="platformInfoDiv" data-labelfooter="<%=res.getString("portal.login.Footer")%>" ></div>
</div>

</body>
</html>
