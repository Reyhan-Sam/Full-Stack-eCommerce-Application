<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
<link href="listprod.css" rel="stylesheet" type="text/css" >
</head>
<body>

<%@ include file="header.jsp" %>

<h1 align="center">Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
        <p align="left">
            <select size="1" name="categoryName">
                <option>All</option>

                <option>Home and Decor</option>
                <option>Audio Accessories</option>
                <option>Office Supplies</option>
                <option>Travel Gear</option>
                <option>Miscellaneous</option>
                <option>Gaming Tech</option>
                <option>Smart Home Automation</option>

                <input type="text" name="productName" size="50">
            </select>
            <input type="submit" value="Submit">
            <input type="reset" value="Reset">
        </p>
    </form>

<h2>All Products</h2>

<table border="1">
	<tr>
		<th></th>
		<th>Product Name</th>
		<th>Product Price</th>
		<th>Category</th>
	</tr>

<% // Get product name to search for
String name = request.getParameter("productName");
if (name == null) {
	name = "";
}

// Get category name to search for
String inputCategoryName = request.getParameter("categoryName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
	String uid = "sa";
	String pw = "304#sa#pw";
			
	try ( Connection con = DriverManager.getConnection(url, uid, pw);
			Statement stmt = con.createStatement();) 
	{			
		
		String sql3 = "SELECT categoryId FROM category WHERE categoryName = ?";
		PreparedStatement pstmt3 = con.prepareStatement(sql3);
		pstmt3.setString(1, inputCategoryName);
		ResultSet rst3 = pstmt3.executeQuery();
		int searchCategoryId = -1;
		if (rst3.next()){
			searchCategoryId = rst3.getInt(1);
		}
		
		String sql = "SELECT productName, productPrice, productId, categoryId FROM product WHERE productName LIKE ?";
		if (searchCategoryId != -1) {
			sql += " AND categoryId = ?";
		}
		PreparedStatement preparedStatement = con.prepareStatement(sql);
		preparedStatement.setString(1, "%" + name + "%");
		if (searchCategoryId != -1) {
			preparedStatement.setInt(2, searchCategoryId);
		}
		ResultSet rst = preparedStatement.executeQuery();
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		while (rst.next())
		{	
			String productName = rst.getString(1);
			Double productPrice = rst.getDouble(2);
			String productId = rst.getString(3);
			int categoryId = rst.getInt(4);

			String  sql2 = "SELECT categoryName FROM category WHERE categoryId = ?";
			PreparedStatement pstmt2 = con.prepareStatement(sql2);
			pstmt2.setInt(1, categoryId);
			ResultSet rst2 = pstmt2.executeQuery();
			rst2.next();
			String categoryName = rst2.getString(1);

			%>
			<tr>
				<td><a href="addcart.jsp?id=<%= productId %>&name=<%= productName %>&price=<%= productPrice %>">Add to Cart</a></td>
				<td><a href="product.jsp?id=<%= productId %>"><%= productName %></a></td>
				<td><%= categoryName %></td>
				<td><%= currFormat.format(productPrice) %></td>
			</tr>
			<%
		}

		

	}
	catch (SQLException ex)
	{
		out.println("SQLException: " + ex);
	}
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection

// Print out the ResultSet

// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>
</table>

</body>
</html>