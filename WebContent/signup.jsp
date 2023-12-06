<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>
    <link href="index.css" rel="stylesheet" type="text/css" >
</head>
<body>
<%@ include file="header.jsp" %>
<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<h1 align="center">Sign up</h2>

<form action="addUser.jsp" method="get">
    <label for="firstname">First Name:</label>
    <input type="text" pattern="[A-Za-z]+" name="firstname" oninvalid="setCustomValidity('Fill out this field by entering only letters')" oninput="setCustomValidity('')" required>

    <label for="lastname">Last Name:</label>
    <input type="text" pattern="[A-Za-z]+" name="lastname" oninvalid="setCustomValidity('Fill out this field by entering only letters')" oninput="setCustomValidity('')" required>

    <label for="username">Username:</label>
    <input type="text" name="username" required>

    <label for="email">Email Address:</label>
    <input type="email" name="email" required>

    <label for="password">Password:</label>
    <input type="password" name="password" required>

    <label for="phonenum">Phone Number:</label>
    <input type="tel" pattern="[0-9]{10}" name="phonenum" oninvalid="setCustomValidity('Fill out this field by entering only the 10 digits of your phone number')" oninput="setCustomValidity('')" required>

    <label for="address">Address:</label>
    <input type="text" name="address" required>

    <label for="city">City:</label>
    <input type="text" name="city" required>

    <label for="state">Province:</label>
    <select name="state" required>
        <option value="" disabled selected>Select Province</option>
        <option value="AB">Alberta</option>
        <option value="BC">British Columbia</option>
        <option value="MB">Manitoba</option>
        <option value="NB">New Brunswick</option>
        <option value="NL">Newfoundland and Labrador</option>
        <option value="NS">Nova Scotia</option>
        <option value="ON">Ontario</option>
        <option value="PE">Prince Edward Island</option>
        <option value="QC">Quebec</option>
        <option value="SK">Saskatchewan</option>
        <option value="NT">Northwest Territories</option>
        <option value="NU">Nunavut</option>
        <option value="YT">Yukon</option>
    </select>

    <label for="postalCode">Postal Code:</label>
    <input type="text" pattern="[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d" name="postalCode" oninvalid="setCustomValidity('Enter the correct format')" oninput="setCustomValidity('')" required>

    <label for="country">Country:</label>
    <select name="country" required>
        <option value="" disabled selected>Select Country</option>
        <option value="Canada">Canada</option>
    </select>

    <button type="submit">Submit</button>
</form>

<style>
    form {
        width: 800px;
        margin: 0 auto;
    }
    label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
    }
    input {
        width: 100%;
        padding: 8px;
        margin-bottom: 16px;
        box-sizing: border-box;
        border: 1px solid #ccc;
        border-radius: 4px;
    }
    select {
        width: 100%;
        padding: 8px;
        border: 1px solid #ccc;
        margin-bottom: 16px;
        border-radius: 4px;
        box-sizing: border-box;
        height: 30px;
        }
    button {
        background-color: #3D405B;
        width: 100%;
        height: 40px;
        color: #fff;
        padding: 10px 15px;
        border: none;
        border-radius: 10px;
        cursor: pointer;
    }
</style>

</body>
</html>