<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.TimeZone" %>
<%@ page import="java.text.NumberFormat" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
<link href="index.css" rel="stylesheet" type="text/css" >
</head>
<body>
<%@ include file="auth.jsp"%>
<%@ include file="header.jsp"%>
<%@ include file="jdbc.jsp"%>

<% 
// Get customer id
String custId = request.getParameter("custId");

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

int orderId = 0;
String name = "";
Boolean validId = false;

// Make connection
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
	String uid = "sa";
	String pw = "304#sa#pw";
			
	try ( Connection con = DriverManager.getConnection(url, uid, pw);
			Statement stmt = con.createStatement();) 
	{	
		// Determine if there are products in the shopping cart
		if (productList.isEmpty()) {
			%>
			<h1>Your shopping cart is empty!</h1>
			<%
		}

		// Determine if valid customer id was entered
		String sql5 = "SELECT customerId FROM customer";
		Statement stmt5 = con.createStatement();
		ResultSet rst5 = stmt5.executeQuery(sql5);
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		while(rst5.next()) {
			if (custId.chars().allMatch(Character::isDigit) && rst5.getInt(1) == Integer.parseInt(custId)) {
				validId = true;
			}
		}
		if (!validId) {
			%>
			<h1>Invalid customer id. Go back to the previous page and try again.</h1>
			<%
		}

		if (!productList.isEmpty() && validId == true) {
			%>
			<h1>Your Order Summary</h1>
			<table border="1">
				<tr>
					<th>Product Id</th>
					<th>Product Name</th>
					<th>Quantity</th>
					<th>Price</th>
					<th>Subtotal</th>
				</tr>
			<%
			double orderTotal = 0;

			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			dateFormat.setTimeZone(TimeZone.getTimeZone("America/Vancouver"));
			Date now = new Date();
			String formattedDate = dateFormat.format(now);

			String sql = "INSERT INTO ordersummary(orderDate, totalAmount, customerId) VALUES (?, ?, ?)";
			PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, formattedDate);
			pstmt.setDouble(2, orderTotal);
			pstmt.setString(3, custId);
			pstmt.executeUpdate();
			
			ResultSet keys = pstmt.getGeneratedKeys();
			keys.next();
			orderId = keys.getInt(1);

			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext())
			{ 
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String productName = (String) product.get(1);
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ((Integer)product.get(3)).intValue();
				double subTotal = pr * qty;
				orderTotal += subTotal;

				// Print out order summary
				%>
				<tr>
					<td><%= productId %></td>
					<td><%= productName %></td>
					<td><%= qty %></td>
					<td><%= currFormat.format(pr) %></td>
					<td><%= currFormat.format(subTotal) %></td>
				</tr>
				<%
				// Insert each item into OrderProduct table using OrderId from previous INSERT
				String sql2 = "INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
				PreparedStatement pstmt2 = con.prepareStatement(sql2);
				pstmt2.setInt(1, orderId);
				pstmt2.setInt(2, Integer.parseInt(productId));
				pstmt2.setInt(3, qty);
				pstmt2.setDouble(4, Double.parseDouble(price));
				pstmt2.executeUpdate();

			}
			%>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td>Order Total: <%= currFormat.format(orderTotal) %></td>
			</tr>
			<%

			// Update total amount for order record
			String sql3 = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
			PreparedStatement pstmt3 = con.prepareStatement(sql3);
			pstmt3.setDouble(1, orderTotal);
			pstmt3.setInt(2, orderId);
			pstmt3.executeUpdate();

			String sql4 = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
			PreparedStatement pstmt4 = con.prepareStatement(sql4);
			pstmt4.setInt(1, Integer.parseInt(custId));
			ResultSet rst4 = pstmt4.executeQuery();

			rst4.next();
			name = rst4.getString(1) + " " + rst4.getString(2);
			rst4.close();
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

<%
if (!productList.isEmpty() && validId == true) {
	%>
	<h1>Order completed. Click below for shipping details.</h1>
	<h2><a href="ship.jsp?orderId=<%= orderId %>">See shipment details</a></h2>
	<h1>Your order reference number is: <%= orderId %> </h1>
	<h1>Shipping to customer: <%= custId %> Name: <%= name %> </h1>
	<%
}

// Clear cart if order placed successfully
if (!productList.isEmpty() && validId == true) {
	productList.clear();
}
%>

</BODY>
</HTML>

