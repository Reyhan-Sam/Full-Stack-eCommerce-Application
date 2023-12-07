<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
<link href="login.css" rel="stylesheet" type="text/css" >
</head>
<body>


<h2 style="text-align: center;">Please Login to System</h3>

<% if (session.getAttribute("loginMessage") != null) { %>
	<div style="text-align: center;">
		<p><%= session.getAttribute("loginMessage").toString() %></p>
	</div>
<% } %>

<br>
<form name="MyForm" method=post action="validateLoginAdmin.jsp">
<tr>
	<td><div><font face="Arial, Helvetica, sans-serif" size="3"><strong>Username:</strong></font></div></td>
	<td><input type="text" name="username"  size=12 maxlength=12></td>
</tr>
<tr>
	<td><div><font face="Arial, Helvetica, sans-serif" size="3"><strong>Password:</strong></font></div></td>
	<td><input type="password" name="password" size=12 maxlength="12"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Log In">
</form>

</div>

</body>
</html>