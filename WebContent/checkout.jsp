<!DOCTYPE html>
<html>
<head>
<title>Ray's Grocery CheckOut Line</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ include file="header.jsp"%>
<%@ include file="jdbc.jsp"%>

<%
String custId = "";
try {
	getConnection();
	String sql6 = "SELECT customerId FROM customer WHERE userid = ?";
	PreparedStatement pstmt6 = con.prepareStatement(sql6);
	pstmt6.setString(1, userName);
	ResultSet rst6 = pstmt6.executeQuery();
	rst6.next();
	custId = rst6.getString(1);
	closeConnection();
    response.sendRedirect("order.jsp?custId="+custId);	
}
catch (Exception e) {
	out.println(e);
}
%>

<!-- <h1>Enter your customer id to complete the transaction:</h1>

<form method="get" action="order.jsp">
<input type="text" name="customerId" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset">
</form> -->

</body>
</html>

