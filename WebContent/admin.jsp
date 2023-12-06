<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<link href="index.css" rel="stylesheet" type="text/css" >

</head>
<body>

<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.text.NumberFormat" %>

<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<script>
	function update(warehouseId, productId, newqty) {
        window.location="admin.jsp?warehouseId="+warehouseId+"&productId="+productId+"&newqty="+newqty;
	}
</script>

<%
try {
    getConnection();
    String updateWarehouseId = request.getParameter("warehouseId");
    String updateProductId = request.getParameter("productId");
    String newQty = request.getParameter("newqty");
    if (updateWarehouseId != null && updateProductId != null && newQty != null) {
        String sql6 = "UPDATE productinventory SET quantity = ? WHERE warehouseId = ? AND productId = ?";
        PreparedStatement pstmt6 = con.prepareStatement(sql6);
        pstmt6.setInt(1, Integer.parseInt(newQty));
        pstmt6.setInt(2, Integer.parseInt(updateWarehouseId));
        pstmt6.setInt(3, Integer.parseInt(updateProductId));
        pstmt6.executeUpdate();
    }
    closeConnection();
}

catch (Exception e) {
    out.print(e);
}
%>

<h2>All Customers</h2>

<table border="1">
    <tr><th>Customer Id</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Phone Num</th><th>Address</th><th>City</th><th>State</th><th>Postal Code</th><th>Country</th><th>User Id</th></tr>

<%
getConnection();

String sql3 = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid FROM customer";
Statement stmt3 = con.createStatement();
ResultSet rst3 = stmt3.executeQuery(sql3);
while(rst3.next()) {
    %>
    <tr><td><%= rst3.getInt(1) %></td><td><%= rst3.getString(2) %></td><td><%= rst3.getString(3) %></td><td><%= rst3.getString(4) %></td><td><%= rst3.getString(5) %></td><td><%= rst3.getString(6) %></td><td><%= rst3.getString(7) %></td><td><%= rst3.getString(8) %></td><td><%= rst3.getString(9) %></td><td><%= rst3.getString(10) %></td><td><%= rst3.getString(11) %></td></tr>
    <%
}
%>

</table>

<h2>Total Sales Report By Day</h2>

<table border="1">
    <tr><th>Order Date</th><th>Total Order Amount</th></tr>

<%

// TODO: Write SQL query that prints out total order amount by day
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
	String uid = "sa";
	String pw = "304#sa#pw";
			
	try ( Connection con = DriverManager.getConnection(url, uid, pw);
			Statement stmt = con.createStatement();) 
	{			
		
		String sql = "SELECT orderDate FROM ordersummary";
        ResultSet rst = stmt.executeQuery(sql);
        String orderDate = null;
        String formattedAmount = null;
        String formattedDate = null;
        HashSet<String> hashset = new HashSet<>();
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        while (rst.next()){
            orderDate = rst.getString(1);
            if (hashset.contains(orderDate.substring(0,10))) {
                continue;
            }
            else {
                hashset.add(orderDate.substring(0,10));
            }
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
            int year = 0;
            int month = 0;
            int day = 0;
            try{
                Date date = dateFormat.parse(orderDate);
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(date);
                year = calendar.get(Calendar.YEAR);
                month = calendar.get(Calendar.MONTH) + 1;
                day = calendar.get(Calendar.DAY_OF_MONTH);
            } 
            catch (ParseException e) {
                e.printStackTrace();
            }
            String sql2 = "SELECT totalAmount FROM ordersummary WHERE (DATEPART(yy, orderDate) = ? AND DATEPART(mm, orderDate) = ? AND DATEPART(dd, orderDate) = ?)";
            PreparedStatement pstmt = con.prepareStatement(sql2);
            pstmt.setInt(1, year);
            pstmt.setInt(2, month);
            pstmt.setInt(3, day);
			ResultSet rst2 = pstmt.executeQuery();
            double totalAmount = 0;
            while(rst2.next()) {
                totalAmount += rst2.getDouble(1);
            }
            formattedAmount = String.format("%.2f", totalAmount);
            formattedDate = ""+year+"-"+month+"-"+day;
            %>
            <tr><td><%= orderDate.substring(0,10)  %></td><td><%= currFormat.format(Double.parseDouble(formattedAmount)) %></td></tr>
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
<hr>
<h2>Insert a New Product</h2>

<form action="addprod.jsp" method="post">
    <label for="productName">Product Name:</label>
    <input type="text" name="productName" required><br>

    <label for="productPrice">Product Price:</label>
    <input type="number" name="productPrice" required><br>

    <label for="productDesc">Product Description:</label>
    <textarea name="productDesc" rows="4" cols="50"></textarea><br>

    <label for="categoryId">Category ID:</label>
    <input type="number" name="categoryId" required><br>

    <input type="submit" value="Submit">
</form>

<hr>
<h2>Delete an Existing Product</h2>

<form action="deleteprod.jsp" method="delete">
    <label for="productId">Product Id:</label>
    <input type="text" name="productId" required><br>

    <input type="submit" value="Submit">
</form>

<hr>
<h2>View Product Inventory For Each Warehouse</h2>


<FORM name="form1">
<% 
getConnection();

try {
    String sql4 = "SELECT warehouseId FROM warehouse";
    Statement stmt4 = con.createStatement();
    ResultSet rst4 = stmt4.executeQuery(sql4);
    while (rst4.next()) {
        int warehouseId = rst4.getInt(1);
        %>
        <h3>Warehouse Id: <%= warehouseId %></h3>
        <table border="1">
            <tr><th>Product Id</th><th>Product Name</th><th>Product Inventory</th></tr>
        <%
        String sql5 = "SELECT product.productId, productName, quantity FROM product JOIN productinventory ON product.productId = productinventory.productId WHERE warehouseId = ?";
        PreparedStatement pstmt5 = con.prepareStatement(sql5);
        pstmt5.setInt(1, warehouseId);
        ResultSet rst5 = pstmt5.executeQuery();
        while (rst5.next()) {
            %>
            <tr><td><%= rst5.getInt(1) %></td><td><%= rst5.getString(2) %></td><td><input type="text" name="newqty<%= rst5.getInt(1) %>" value="<%= rst5.getInt(3) %>"></td><td><input type="button" onClick="update(<%= warehouseId %>, <%= rst5.getInt(1) %>, document.form1.newqty<%= rst5.getInt(1) %>.value)" value="Update Quantity"></td></tr>
            <%
        }
    }
}
catch (Exception e) {
    out.println(e);
}

closeConnection();

%>
</FORM>

</table>

<style>
    form {
        max-width: 400px;
    }
    label {
        display: block;
        margin-bottom: 8px;
    }
    input, textarea {
        width: 100%;
        padding: 8px;
        margin-bottom: 16px;
        box-sizing: border-box;
    }
    input[type="submit"] {
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

