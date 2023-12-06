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
String productName = request.getParameter("productName");
double productPrice = Double.parseDouble(request.getParameter("productPrice"));
String productDesc = request.getParameter("productDesc");
int categoryId = Integer.parseInt(request.getParameter("categoryId"));

getConnection();
String sql = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1, productName);
pstmt.setDouble(2, productPrice);
pstmt.setString(3, productDesc);
pstmt.setInt(4, categoryId);
pstmt.executeUpdate();
closeConnection();
%>

<h2>Product added to the database successfully!</h2>
<h2><a href="admin.jsp">Go back to admin portal</a></h2>

</body>
</html>