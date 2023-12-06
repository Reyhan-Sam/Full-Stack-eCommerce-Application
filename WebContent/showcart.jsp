<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
<link href="index.css" rel="stylesheet" type="text/css" >
</head>
<body>
<%@ include file="header.jsp" %>

<script>
	function update(productId, newqty) {
		window.location="showcart.jsp?update="+productId+"&newqty="+newqty;
	}
</script>
<FORM name="form1">
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String deleteProductId = request.getParameter("delete");
if (deleteProductId != null && !deleteProductId.isEmpty()) {
	productList.remove(deleteProductId);
	session.setAttribute("productList", productList);
}

String updateProductId = request.getParameter("update");
String newQty = request.getParameter("newqty");
if (updateProductId != null && newQty != null && !updateProductId.isEmpty() && !newQty.isEmpty()) {
    ArrayList<Object> productToUpdate = productList.get(updateProductId);
	try {
		int newQuantity = Integer.parseInt(newQty);
		if (Integer.parseInt(newQty) >= 1 && productToUpdate != null && productToUpdate.size() >= 4) {
			productToUpdate.set(3, newQuantity);
			session.setAttribute("productList", productList);
		} else if (Integer.parseInt(newQty) <= 0) {
			out.println("<h2>Invalid: quantity cannot be negative or zero!</h2>");
		}
		else {
			out.println("<h2>Invalid: quantity must be an integer!<h2>");
		}
	}
	catch (NumberFormatException e) {
		out.println("<h2>Invalid: quantity must be an integer!<h2>");
	}   
}

if (productList == null)
{	out.println("<H1>Your shopping cart is empty!</H1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	out.println("<h1>Your Shopping Cart</h1>");
	out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th><th></th></tr>");

	double total =0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		
		out.print("<tr><td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");

		%>
		<td align="center"><input type="text" name="newqty<%= product.get(0) %>" size="3" value="<%= product.get(3) %>"></td>
		<%
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}		

		out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td>");
		%>
		<td><a href="showcart.jsp?delete=<%= product.get(0) %>">Remove Item From Cart</a></td>
		<td><input type="button" onClick="update(<%= Integer.parseInt(product.get(0).toString()) %>,document.form1.newqty<%= product.get(0) %>.value)" value="Update Quantity"></td>
		</tr>
		<%
		out.println("</tr>");
		total = total +pr*qty;
	}
	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
			+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
	out.println("</table>");

	out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
}
%>
<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</FORM>
</body>
</html> 

