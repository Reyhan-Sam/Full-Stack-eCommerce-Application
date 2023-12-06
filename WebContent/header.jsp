<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<nav>
    <ul>
        <li><a href="index.jsp">Home</a></li>
        <li><a href="listprod.jsp">Products</a></li>
        <li><a href="showcart.jsp">Shopping Cart</a></li>
		<% if (userName != null) { %>
            <li><a href="customer.jsp"><%= userName %></a></li>
        <% } else { %>
            <li><a href="login.jsp">Login</a></li>
        <% } %>
    </ul>
</nav>

<style>
	nav {
		font-family: Arial, sans-serif;
		background-color: #3D405B;
		overflow: hidden;
		margin: 0;
		padding: 0;
	}
	nav ul {
		list-style-type: none;
		margin: 0;
		padding: 0;
		overflow: hidden;
	}
	nav li {
		float: left;
	}
	nav li a {
		display: block;
		color: white;
		text-align: center;
		padding: 14px 16px;
		text-decoration: none;
		font-weight: bold;
	}
	nav li a:hover {
		background-color: #ddd;
		color: black;
	}
	nav li:last-child {
		float: right;
	}
</style>