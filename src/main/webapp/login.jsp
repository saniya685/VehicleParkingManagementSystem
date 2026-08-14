<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Vehicle Parking Management System - Login</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 0;

            font-family: Arial, sans-serif;

            background: #f4f6f8;

            display: flex;
            justify-content: center;
            align-items: center;

            min-height: 100vh;
        }

        .login-container {
            width: 400px;

            background: white;

            padding: 35px;

            border-radius: 10px;

            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
        }

        h2 {
            text-align: center;

            margin-top: 0;
            margin-bottom: 10px;
        }

        .subtitle {
            text-align: center;

            color: #666;

            margin-bottom: 25px;
        }

        label {
            display: block;

            margin-top: 15px;
            margin-bottom: 7px;

            font-weight: bold;
        }

        input {
            width: 100%;

            padding: 12px;

            border: 1px solid #ccc;

            border-radius: 5px;

            font-size: 15px;
        }

        input:focus {
            outline: none;

            border-color: #555;
        }

        button {
            width: 100%;

            padding: 12px;

            margin-top: 25px;

            border: none;

            border-radius: 5px;

            background: #333;

            color: white;

            font-size: 16px;

            cursor: pointer;
        }

        button:hover {
            background: #555;
        }

        .error {
            margin-top: 18px;

            padding: 10px;

            text-align: center;

            color: red;

            background: #ffe6e6;

            border-radius: 5px;
        }

    </style>

</head>

<body>

<div class="login-container">

    <h2>
        Vehicle Parking Management System
    </h2>

    <div class="subtitle">
        Admin Login
    </div>

    <form
        action="${pageContext.request.contextPath}/login"
        method="post">

        <label for="username">
            Username
        </label>

        <input
            type="text"
            id="username"
            name="username"
            placeholder="Enter username"
            autocomplete="username"
            required>

        <label for="password">
            Password
        </label>

        <input
            type="password"
            id="password"
            name="password"
            placeholder="Enter password"
            autocomplete="current-password"
            required>

        <button type="submit">
            Login
        </button>

    </form>

    <%
        String error = (String) request.getAttribute("error");

        if (error != null) {
    %>

        <div class="error">
            <%= error %>
        </div>

    <%
        }
    %>

</div>

</body>

</html>