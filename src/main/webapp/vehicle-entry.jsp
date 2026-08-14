<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Vehicle Entry</title>

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

    <h1>Vehicle Entry</h1>


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
        action="${pageContext.request.contextPath}/vehicle-entry">


        <!-- VEHICLE NUMBER -->

        <label>
            Vehicle Number
        </label>

        <input
            type="text"
            name="vehicleNumber"
            placeholder="Enter vehicle number"
            required>


        <!-- VEHICLE TYPE -->

        <label>
            Vehicle Type
        </label>

        <select
            name="vehicleType"
            required>

            <option value="">
                Select vehicle type
            </option>

            <option value="BIKE">
                Bike
            </option>

            <option value="CAR">
                Car
            </option>

            <option value="BUS">
                Bus
            </option>

            <option value="TRUCK">
                Truck
            </option>

            <option value="OTHER">
                Other
            </option>

        </select>


        <!-- OWNER NAME -->

        <label>
            Owner Name
        </label>

        <input
            type="text"
            name="ownerName"
            placeholder="Enter owner name"
            required>


        <button type="submit">
            Register Vehicle
        </button>

    </form>


    <a
        href="${pageContext.request.contextPath}/dashboard"
        class="back">

         Back to Dashboard ?

    </a>

</div>

</body>

</html>