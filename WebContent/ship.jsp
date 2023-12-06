<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.TimeZone" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>YOUR NAME Grocery Shipment Processing</title>
<link href="index.css" rel="stylesheet" type="text/css" >
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	// Get order id
	String orderId = request.getParameter("orderId");
          
	// Check if valid order id in database
	getConnection();
	boolean isValidOrder = false;
	String sql = "SELECT orderId FROM ordersummary WHERE orderId = ?";
	PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(orderId));
    ResultSet rst = pstmt.executeQuery();
    if (rst.next()) {
        isValidOrder = true;
    }

	// Start a transaction (turn-off auto-commit)
	con.setAutoCommit(false);
	
	// Retrieve all items in order with given id
	String sql2 = "SELECT productId, quantity FROM orderproduct WHERE orderId = ?";
	PreparedStatement pstmt2 = con.prepareStatement(sql2);
	pstmt2.setInt(1, Integer.parseInt(orderId));
    ResultSet rst2 = pstmt2.executeQuery();

	// Create a new shipment record
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SS");
	dateFormat.setTimeZone(TimeZone.getTimeZone("America/Vancouver"));
	Date now = new Date();
	String formattedDate = dateFormat.format(now);

	String sql3 = "INSERT INTO shipment (shipmentDate, warehouseId) VALUES (?, 1)";
	PreparedStatement pstmt3 = con.prepareStatement(sql3, Statement.RETURN_GENERATED_KEYS);
	pstmt3.setString(1, formattedDate);

	// For each item verify sufficient quantity available in warehouse 1
	String sql4 = "SELECT quantity FROM productinventory WHERE warehouseId = 1 AND productId = ?";
	PreparedStatement pstmt4 = con.prepareStatement(sql4);
	String sql5 = "UPDATE productinventory SET quantity = quantity - ? WHERE warehouseId = 1 AND productId = ?";
	PreparedStatement pstmt5 = con.prepareStatement(sql5);
	int productId = 0;
	while(rst2.next()) {
		productId = rst2.getInt(1);
		int orderedQuantity = rst2.getInt(2);
		pstmt4.setInt(1, productId);
		ResultSet rst4 = pstmt4.executeQuery();
		rst4.next();
		int inventoryQuantity = rst4.getInt(1);
		int updatedInventoryQuantity = inventoryQuantity - orderedQuantity;
		if (inventoryQuantity >= orderedQuantity) {
			// Update inventory
            pstmt5.setInt(1, orderedQuantity);
            pstmt5.setInt(2, productId);
            pstmt5.executeUpdate();
		}
		else {
			// If any item does not have sufficient inventory, cancel the transaction and rollback
			isValidOrder = false;
            con.rollback();
            break;
		}
		%>
		<h3>Ordered product: <%= productId %> Qty: <%= orderedQuantity %> Previous inventory: <%= inventoryQuantity %> New inventory: <%= updatedInventoryQuantity %></h3>
		<%
	}

	if (isValidOrder) {
		con.commit();
		%>
		<h2>Shipment Successfully Processed</h2>
		<%
	}
	else {
		%>
		<h2>Shipment not done. Insufficient inventory for product id: <%= productId %></h2>
		<%
	}

	// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
	
	// TODO: Auto-commit should be turned back on
    con.setAutoCommit(true);
%>                       				

<h2><a href="index.jsp">Return to home page</a></h2>

</body>
</html>
