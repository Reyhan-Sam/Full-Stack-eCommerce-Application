<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order List</title>
</head>
<link href="index.css" rel="stylesheet" type="text/css" >
<body>

<%@ include file="header.jsp" %>

<h1>Order List</h1>

<table border="1">
	<tr>
		<th>Order ID</th>
		<th>Order Date</th>
		<th>Customer ID</th>
		<th>Customer Name</th>
		<th>Total Amount</th>
	</tr>


<%
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
		
		ResultSet rst = stmt.executeQuery("SELECT orderId, orderDate, customer.customerId, firstName, lastName, totalAmount FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId");
		String sql = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?";
		PreparedStatement pstmt = con.prepareStatement(sql);
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		while (rst.next())
		{	
			%>
			<tr>
				<td><%= rst.getString(1) %></td>
				<td><%= rst.getString(2) %></td>
				<td><%= rst.getString(3) %></td>
				<td><%= rst.getString(4) + " " + rst.getString(5) %></td>
				<td><%= currFormat.format(rst.getDouble(6)) %></td>
			</tr>
			<%
			pstmt.setString(1, rst.getString(1));
			ResultSet rst2 = pstmt.executeQuery();
			%>
			<tr>
				<td>
				<table border="1">
					<tr>
						<th>Product Id</th>
						<th>Quantity</th>
						<th>Price</th>
					</tr>
			<%
			while (rst2.next()) {
				%>
				<tr>
					<td><%= rst2.getString(1) %></td>
					<td><%= rst2.getString(2) %></td>
					<td><%= rst2.getString(3) %></td>
				</tr>
				<%
			}
			rst2.close();
			%>
			</td>
			</table>
			<%
		}
		/*
			String sql4 = "DELETE FROM orderproduct WHERE orderId = 2007";
			Statement stmt2 = con.createStatement();
			stmt2.executeUpdate(sql4);
			String sql5 = "DELETE FROM ordersummary WHERE orderId = 2007";
			Statement stmt3 = con.createStatement();
			stmt3.executeUpdate(sql5);
		*/
		/*
			String sql4 = "UPDATE product SET productDesc = 'Introducing the latest Echo Dot with clock – our best-sounding yet. Enjoy clear vocals, deeper bass, and vibrant sound. The LED display shows time, alarms, weather, and song titles. Stream music from Amazon, Apple Music, Spotify, or Bluetooth. Alexa handles tasks, sets timers, and more.' WHERE productId = 28";
			Statement stmt2 = con.createStatement();
			stmt2.executeUpdate(sql4);
		*/
		
			String sql6 = "UPDATE customer SET userid = 'admin' WHERE customerId=1";
			Statement stmt6 = con.createStatement();
			stmt6.executeUpdate(sql6);
		
		/*
		String sql6 = "UPDATE product SET productName = 'Kasa Smart security camera' WHERE productId = 29";
		Statement stmt6 = con.createStatement();
		stmt6.executeUpdate(sql6);
		*/
		

		
		
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


</body>
</html>

