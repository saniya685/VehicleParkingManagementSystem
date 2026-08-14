<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Vehicle Exit</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .container {
            width: 500px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.12);
        }

        h1 {
            text-align: center;
            margin-bottom: 30px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
        }

        input,
        select {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 15px;
        }

        button {
            width: 100%;
            padding: 13px;
            background: #333;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #555;
        }

        .success {
            background: #e5f7e5;
            color: #167316;
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
        }

        .error {
            background: #ffe5e5;
            color: #c00000;
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
        }

        .result {
            background: #f4f6f9;
            padding: 15px;
            margin-top: 20px;
            border-radius: 5px;
        }

        .result p {
            margin: 8px 0;
        }

        .back {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #333;
            text-decoration: none;
        }

    </style>

</head>

<body>

<div class="container">

    <h1>Vehicle Exit</h1>


    <%
        String success =
                (String) request.getAttribute("success");

        if (success != null) {
    %>

        <div class="success">
            <%= success %>
        </div>

    <%
        }
    %>


    <%
        String error =
                (String) request.getAttribute("error");

        if (error != null) {
    %>

        <div class="error">
            <%= error %>
        </div>

    <%
        }
    %>


    <form
        method="post"
        action="${pageContext.request.contextPath}/vehicle-exit">


        <!-- VEHICLE NUMBER -->

        <label>
            Vehicle Number
        </label>

        <input
            type="text"
            name="vehicleNumber"
            placeholder="Enter vehicle number"
            required>


        <!-- PAYMENT METHOD -->

        <label>
            Payment Type
        </label>

        <select
            name="paymentMethod"
            required>

            <option value="">
                Select payment type
            </option>

            <option value="CASH">
                Cash
            </option>

            <option value="CARD">
                Card
            </option>

            <option value="UPI">
                UPI
            </option>

        </select>


        <button type="submit">
            Process Vehicle Exit
        </button>

    </form>


    <%
        if (request.getAttribute("parkingFee") != null) {
    %>

        <div class="result">

            <p>
                <strong>Vehicle Number:</strong>
                <%= request.getAttribute("vehicleNumber") %>
            </p>

            <p>
                <strong>Parking Slot:</strong>
                <%= request.getAttribute("slotNumber") %>
            </p>

            <p>
                <strong>Duration:</strong>
                <%= request.getAttribute("durationHours") %>
                hour(s)
            </p>

            <p>
                <strong>Parking Fee:</strong>
                ?<%= request.getAttribute("parkingFee") %>
            </p>

            <p>
                <strong>Payment Type:</strong>
                <%= request.getAttribute("paymentMethod") %>
            </p>

        </div>

    <%
        }
    %>


    <a
        href="${pageContext.request.contextPath}/dashboard"
        class="back">

         Back to Dashboard ?

    </a>

</div>

</body>

</html>