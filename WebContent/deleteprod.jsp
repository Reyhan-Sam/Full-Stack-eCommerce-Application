<!DOCTYPE html>
<html>
<head>
    <title>Add Product</title>
    <link href="index.css" rel="stylesheet" type="text/css" >
</head>
<body>

<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
int productId = Integer.parseInt(request.getParameter("productId"));
getConnection();
String sql = "DELETE FROM product WHERE productId = ?";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setInt(1, productId);
pstmt.executeUpdate();
closeConnection();
%>

<h2>Product <%= productId %> deleted from the database successfully!</h2>
<h2><a href="admin.jsp">Go back to the admin portal</a></h2>

</body>
</html>