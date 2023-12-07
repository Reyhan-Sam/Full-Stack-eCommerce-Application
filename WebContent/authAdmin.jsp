<%
	boolean authenticated = session.getAttribute("authenticatedUser") == null ? false : true;
	boolean adminAuthenticated = false;
	try {
		getConnection();
		String sql = "SELECT userid FROM customer WHERE customerId = 1";
		Statement stmt = con.createStatement();
		ResultSet rst = stmt.executeQuery(sql);
		rst.next();
		String adminUserid = rst.getString(1);
		if (authenticated && adminUserid.equals(session.getAttribute("authenticatedUser"))){
			adminAuthenticated = true;
		}
		closeConnection();
	}
	catch (Exception e) {
		out.println(e);
	}

	if (!authenticated || !adminAuthenticated)
	{
		String loginMessage = "You have not been authorized to access the URL "+request.getRequestURL().toString();
        session.setAttribute("loginMessage",loginMessage);        
		response.sendRedirect("loginAdmin.jsp");
	}
%>