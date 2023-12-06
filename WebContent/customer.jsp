<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<link href="index.css" rel="stylesheet" type="text/css" >
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<h2>Your Info</h2>

<script>
	function updatePassword(id, newpass) {
		window.location="customer.jsp?id="+id+"&newpass="+newpass;
	}
	function updateAddress(id, newaddress) {
		window.location="customer.jsp?id="+id+"&newaddress="+newaddress;
	}
</script>

<%
String updateCustomerId = request.getParameter("id");
String newPass = request.getParameter("newpass");
String newAddress = request.getParameter("newaddress");
try {
	getConnection();
	if (updateCustomerId != null && newPass != null) {
		String sql5 = "UPDATE customer SET password = ? WHERE customerId = ?";
		PreparedStatement pstmt5 = con.prepareStatement(sql5);
		pstmt5.setString(1, newPass);
		pstmt5.setString(2, updateCustomerId);
		pstmt5.executeUpdate();
	}
	else if (updateCustomerId != null && newAddress != null) {
		String sql6 = "UPDATE customer SET address = ? WHERE customerId = ?";
		PreparedStatement pstmt6 = con.prepareStatement(sql6);
		pstmt6.setString(1, newAddress);
		pstmt6.setString(2, updateCustomerId);
		pstmt6.executeUpdate();
	}
	closeConnection();
}
catch (Exception e) {
	out.println(e);
}


getConnection();
String sql = "SELECT * FROM customer WHERE userid = ?";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1,userName);
ResultSet rst = pstmt.executeQuery();
while (rst.next()) {
	int id = rst.getInt(1);
	String firstName = rst.getString(2);
	String lastName = rst.getString(3);
	String email = rst.getString(4);
	String phone = rst.getString(5);
	String address = rst.getString(6);
	String city = rst.getString(7);
	String state = rst.getString(8);
	String postalCode = rst.getString(9);
	String country = rst.getString(10);
	String userid = rst.getString(11);
	String password = rst.getString(12);

	%>
	<form name="form1">
		<table border="1">
			<tr><th>Id</th><td><%= id %></td></tr>
			<tr><th>First Name</th><td><%= firstName %></td></tr>
			<tr><th>Last Name</th><td><%= lastName %></td></tr>
			<tr><th>Email</th><td><%= email %></td></tr>
			<tr><th>Phone</th><td><%= phone %></td></tr>
			<tr>
				<th>Address</th>
				<td><input type="text" name="newaddress" value="<%= address %>"></td>
				<td><input type="button" onClick="updateAddress(<%= id %>,document.form1.newaddress.value)" value="Update Address"></td>
			</tr>
			<tr><th>City</th><td><%= city %></td></tr>
			<tr><th>State</th><td><%= state %></td></tr>
			<tr><th>Postal Code</th><td><%= postalCode %></td></tr>
			<tr><th>Country</th><td><%= country %></td></tr>
			<tr><th>User id</th><td><%= userid %></td></tr>
			<tr>
				<th>Password</th>
				<td><input type="text" name="newpass" value="<%= password %>"></td>
				<td><input type="button" onClick="updatePassword(<%= id %>,document.form1.newpass.value)" value="Update Password"></td>
			</tr>
	</form>

	<%
}

closeConnection();

%>

</table>

<h2>Your orders</h2>

<table border="1">
	<tr>
		<th>Order ID</th>
		<th>Order Date</th>
		<th>Total Amount</th>
	</tr>

<%
try {
	getConnection();
	String sql2 = "SELECT customerId FROM customer WHERE userid = ?";
	PreparedStatement pstmt2 = con.prepareStatement(sql2);
	pstmt2.setString(1, userName);
	ResultSet rst2 = pstmt2.executeQuery();
	rst2.next();
	int customerId = rst2.getInt(1);

	String sql3 = "SELECT orderId, orderDate, totalAmount FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId WHERE customer.customerId = ?";
	PreparedStatement pstmt3 = con.prepareStatement(sql3);
	pstmt3.setInt(1, customerId);
	ResultSet rst3 = pstmt3.executeQuery();
	String sql4 = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?";
	PreparedStatement pstmt4 = con.prepareStatement(sql4);
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	while (rst3.next()) {
		%>
			<tr>
				<td><%= rst3.getString(1) %></td>
				<td><%= rst3.getString(2) %></td>
				<td><%= currFormat.format(rst3.getDouble(3)) %></td>
			</tr>
		<%
		int orderId = rst3.getInt(1);
		pstmt4.setInt(1, orderId);
		ResultSet rst4 = pstmt4.executeQuery();
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
		while (rst4.next()){
			%>
				<tr>
					<td><%= rst4.getString(1) %></td>
					<td><%= rst4.getString(2) %></td>
					<td><%= rst4.getString(3) %></td>
				</tr>
			<%
		}
		%>
		</td>
		</table>
		<%
		
	}
	closeConnection();
}


catch (Exception e) {
	out.println(e);
}
%>

</table>

</body>
</html>

