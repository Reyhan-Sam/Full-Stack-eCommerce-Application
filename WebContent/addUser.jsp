<!DOCTYPE html>
<html>
<head>
    <title>Sign Up Finished</title>
    <link href="index.css" rel="stylesheet" type="text/css" >
</head>
<body>

<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
String firstName = request.getParameter("firstname");
String lastName = request.getParameter("lastname");
String username = request.getParameter("username");
String email = request.getParameter("email");
String password = request.getParameter("password");
String phonenum = request.getParameter("phonenum");
String address = request.getParameter("address");
String city = request.getParameter("city");
String state = request.getParameter("state");
String postalCode = request.getParameter("postalCode");
String country = request.getParameter("country");

String formattedPhonenum = phonenum.substring(0, 3) + "-" + phonenum.substring(3, 6) + "-" + phonenum.substring(6);

getConnection();
String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1, firstName);
pstmt.setString(2, lastName);
pstmt.setString(3, email);
pstmt.setString(4, formattedPhonenum);
pstmt.setString(5, address);
pstmt.setString(6, city);
pstmt.setString(7, state);
pstmt.setString(8, postalCode);
pstmt.setString(9, country);
pstmt.setString(10, username);
pstmt.setString(11, password);
pstmt.executeUpdate();
closeConnection();
%>

<h2>Your account has been created successfully!</h2>
<h2><a href="login.jsp">Go to Login Page</a></h2>

</body>
</html>