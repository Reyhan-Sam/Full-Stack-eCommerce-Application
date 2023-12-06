<!DOCTYPE html>
<html>
<head>
    <title>Add Review</title>
    <link href="index.css" rel="stylesheet" type="text/css" >
</head>
<body>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.TimeZone" %>
<%@ include file="jdbc.jsp" %>

<%
String userName = (String) session.getAttribute("authenticatedUser");
int productId = Integer.parseInt(request.getParameter("id"));
int rating = Integer.parseInt(request.getParameter("rating"));
String comment = request.getParameter("comment");
try {
    getConnection();
    String sql = "SELECT customerId FROM customer WHERE firstName = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, userName);
    ResultSet rst = pstmt.executeQuery();
    rst.next();
    int customerId = rst.getInt(1);

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    dateFormat.setTimeZone(TimeZone.getTimeZone("America/Vancouver"));
    Date now = new Date();
    String formattedDate = dateFormat.format(now);
    String sql2 = "INSERT INTO review(reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?)";
    PreparedStatement pstmt2 = con.prepareStatement(sql2);
    pstmt2.setInt(1, rating);
    pstmt2.setString(2, formattedDate);
    pstmt2.setInt(3, customerId);
    pstmt2.setInt(4, productId);
    pstmt2.setString(5, comment);
    pstmt2.executeUpdate();
    closeConnection();
}
catch (Exception e) {
    out.println(e);
}

%>

<h2>Your review has been added successfully!</h2>
<h2><a href="product.jsp?id=<%= productId %>">Go back to product detail</a></h2>

</body>
</html>