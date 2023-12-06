<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Ray's Grocery - Product Information</title>
<link href="product.css" rel="stylesheet" type="text/css" >
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product information
String id = request.getParameter("id");

try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
	String uid = "sa";
	String pw = "304#sa#pw";
			
	try ( Connection con = DriverManager.getConnection(url, uid, pw);
			Statement stmt = con.createStatement();) 
	{			
		String sql = "SELECT productId, productName, productPrice, productImageURL, productImage, productDesc FROM product WHERE productId = ?";
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, Integer.parseInt(id));
		ResultSet rst = pstmt.executeQuery();
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		while (rst.next()){
            %>
            <h2><%= rst.getString(2) %></h2>
            <img src="<%= rst.getString(4) %>" alt="Product Image">
            
            <table>
            <tr><th>Id</th><td><%= rst.getInt(1) %></td></tr>
            <tr><th>Price</th><td><%= currFormat.format(rst.getDouble(3)) %></td></tr>
			<tr><th>Description</th><td><%= rst.getString(6) %></td></tr>
            <h3><a href="addcart.jsp?id=<%= rst.getInt(1) %>&name=<%= rst.getString(2) %>&price=<%= rst.getDouble(3) %>">Add to Cart</a></h3>
            <h3><a href="listprod.jsp">Continue Shopping</a>
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
%>

</table>

<h2 style="text-align: center;">Leave a Review</h2>
<form action="addreview.jsp" method="get">
	<input type="hidden" name="id" value="<%= id %>">

	<input type="radio" name="rating" value="1">
	<label for="option1">1</label>

	<input type="radio" name="rating" value="2">
	<label for="option2">2</label>

	<input type="radio" name="rating" value="3">
	<label for="option3">3</label>

	<input type="radio" name="rating" value="4">
	<label for="option4">4</label>
	
	<input type="radio" name="rating" value="5">
	<label for="option5">5</label>

	<br>
	<label for="comment">Share your thoughts:</label>
    <input type="text" name="comment">

	<br>
	<input type="submit" value="Submit">
</form>

<h2>Customer Reviews</h2>
<ul style="list-style-type: none; padding: 0;">
	<%
	
	try {
		getConnection();
		String sql2 = "SELECT reviewRating, reviewDate, customerId, reviewComment FROM review WHERE productId = ?";
		PreparedStatement pstmt2 = con.prepareStatement(sql2);
		pstmt2.setInt(1, Integer.parseInt(id));
		ResultSet rst2 = pstmt2.executeQuery();
		while (rst2.next()) {
			int customerId = rst2.getInt(3);
			String sql3 = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
			PreparedStatement pstmt3 = con.prepareStatement(sql3);
			pstmt3.setInt(1, customerId);
			ResultSet rst3 = pstmt3.executeQuery();
			rst3.next();
			String customerName = rst3.getString(1) + " " + rst3.getString(2);
			%>
			<li style="border-bottom: 1px solid #ccc; padding: 10px;">
				<strong>Rating:</strong> <%= rst2.getInt(1) + "/5" %><br>
				<strong>Date:</strong> <%= rst2.getString(2).substring(0,10) %><br>
				<strong>Customer:</strong> <%= customerName %><br>
				<strong>Comment:</strong> <%= rst2.getString(4) %>
			</li>
			<%
		}
		closeConnection();
	}
	catch (Exception e) {
		out.println(e);
	}
	
	%>
</ul>
	

<style>
    form {
        max-width: 400px;
    }
    label {
        display: inline-block;
        margin-bottom: 8px;
		margin-right: 5px;
    }
	input[type="radio"] {
        margin-bottom: 8px;
        margin-right: 3px;
    }
    input[type="text"] {
        width: 100%;
        padding: 8px;
        margin-bottom: 16px;
        box-sizing: border-box;
    }
    input[type="submit"] {
		width: 100%;
        background-color: #3D405B;
        color: white;
        padding: 10px 15px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
</style>
</body>
</html>

