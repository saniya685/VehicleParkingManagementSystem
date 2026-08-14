<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Vehicle Parking Management System</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            color: #333;
        }

        /* NAVBAR */

        .navbar {
            background: #222;
            color: white;
            padding: 18px 35px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar h2 {
            margin: 0;
            font-size: 22px;
        }

        .logout {
            background: #dc3545;
            color: white;
            padding: 9px 16px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
        }

        .logout:hover {
            background: #b02a37;
        }

        /* MAIN */

        .container {
            width: 92%;
            max-width: 1200px;
            margin: 35px auto;
        }

        .welcome {
            margin-bottom: 25px;
        }

        .welcome h1 {
            margin: 0 0 8px 0;
            font-size: 30px;
        }

        .welcome p {
            margin: 0;
            color: #666;
        }

        /* ERROR */

        .error {
            background: #ffe5e5;
            color: #c00000;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 25px;
            border: 1px solid #ffb3b3;
        }

        /* STATISTICS */

        .cards {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            margin-bottom: 35px;
        }

        .card {
            background: white;
            padding: 25px 15px;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.10);
            text-align: center;
        }

        .card h3 {
            margin: 0 0 15px 0;
            font-size: 16px;
            color: #555;
        }

        .number {
            font-size: 30px;
            font-weight: bold;
            color: #222;
        }

        /* MANAGEMENT */

        .section-title {
            margin-bottom: 18px;
            font-size: 22px;
        }

        .menu {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .menu-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.10);
        }

        .menu-card h3 {
            margin-top: 0;
            margin-bottom: 10px;
        }

        .menu-card p {
            color: #666;
            font-size: 14px;
            min-height: 40px;
        }

        .btn {
            display: inline-block;
            padding: 10px 17px;
            background: #333;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 8px;
        }

        .btn:hover {
            background: #555;
        }

        /* RESPONSIVE */

        @media (max-width: 1100px) {

            .cards {
                grid-template-columns: repeat(3, 1fr);
            }

        }

        @media (max-width: 800px) {

            .cards {
                grid-template-columns: repeat(2, 1fr);
            }

            .menu {
                grid-template-columns: repeat(2, 1fr);
            }

        }

        @media (max-width: 550px) {

            .cards {
                grid-template-columns: 1fr;
            }

            .menu {
                grid-template-columns: 1fr;
            }

            .navbar {
                padding: 15px 20px;
            }

            .container {
                width: 94%;
            }

        }

    </style>

</head>


<body>


<!-- ================= NAVBAR ================= -->

<div class="navbar">

    <h2>
        Vehicle Parking Management System
    </h2>

    <a
        href="${pageContext.request.contextPath}/login.jsp"
        class="logout">

        Logout

    </a>

</div>


<!-- ================= MAIN ================= -->

<div class="container">


    <!-- WELCOME -->

    <div class="welcome">

        <h1>
            Dashboard
        </h1>

        <p>
            Monitor parking slots and vehicle activity.
        </p>

    </div>


    <!-- ERROR MESSAGE -->

    <%

        String error =
                (String) request.getAttribute("error");

        if (error != null) {

    %>

        <div class="error">

            <strong>Error:</strong>

            <%= error %>

        </div>

    <%

        }

    %>


    <!-- ================= STATISTICS ================= -->

    <div class="cards">


        <!-- TOTAL SLOTS -->

        <div class="card">

            <h3>
                Total Slots
            </h3>

            <div class="number">

                <%

                    Object totalSlots =
                            request.getAttribute("totalSlots");

                    if (totalSlots != null) {

                        out.print(totalSlots);

                    } else {

                        out.print("0");

                    }

                %>

            </div>

        </div>


        <!-- AVAILABLE SLOTS -->

        <div class="card">

            <h3>
                Available Slots
            </h3>

            <div class="number">

                <%

                    Object availableSlots =
                            request.getAttribute("availableSlots");

                    if (availableSlots != null) {

                        out.print(availableSlots);

                    } else {

                        out.print("0");

                    }

                %>

            </div>

        </div>


        <!-- OCCUPIED SLOTS -->

        <div class="card">

            <h3>
                Occupied Slots
            </h3>

            <div class="number">

                <%

                    Object occupiedSlots =
                            request.getAttribute("occupiedSlots");

                    if (occupiedSlots != null) {

                        out.print(occupiedSlots);

                    } else {

                        out.print("0");

                    }

                %>

            </div>

        </div>


        <!-- TODAY'S VEHICLES -->

        <div class="card">

            <h3>
                Today's Vehicles
            </h3>

            <div class="number">

                <%

                    Object todaysVehicles =
                            request.getAttribute("todaysVehicles");

                    if (todaysVehicles != null) {

                        out.print(todaysVehicles);

                    } else {

                        out.print("0");

                    }

                %>

            </div>

        </div>


        <!-- TODAY'S REVENUE -->

        <div class="card">

            <h3>
                Today's Revenue
            </h3>

            <div class="number">

                &#8377;

                <%

                    Object todaysRevenue =
                            request.getAttribute("todaysRevenue");

                    if (todaysRevenue != null) {

                        out.print(
                            String.format(
                                "%.2f",
                                ((Number) todaysRevenue).doubleValue()
                            )
                        );

                    } else {

                        out.print("0.00");

                    }

                %>

            </div>

        </div>


    </div>


    <!-- ================= MANAGEMENT ================= -->

    <h2 class="section-title">
        Parking Management
    </h2>


    <div class="menu">


        <!-- VEHICLE ENTRY -->

        <div class="menu-card">

            <h3>
                Vehicle Entry
            </h3>

            <p>
                Register a vehicle and allocate an available parking slot.
            </p>

            <a
                href="${pageContext.request.contextPath}/vehicle-entry.jsp"
                class="btn">

                Register Vehicle

            </a>

        </div>


        <!-- VEHICLE EXIT -->

        <div class="menu-card">

            <h3>
                Vehicle Exit
            </h3>

            <p>
                Process vehicle exit, calculate parking charges and record payment.
            </p>

            <a
                href="${pageContext.request.contextPath}/vehicle-exit.jsp"
                class="btn">

                Vehicle Exit

            </a>

        </div>


        <!-- PARKING RECORDS -->

        <div class="menu-card">

            <h3>
                Parking Records
            </h3>

            <p>
                View vehicle entry, exit, duration, fee and parking status.
            </p>

            <a
                href="${pageContext.request.contextPath}/parking-records"
                class="btn">

                View Records

            </a>

        </div>


        <!-- MANAGE PARKING -->

        <div class="menu-card">

            <h3>
                Manage Parking
            </h3>

            <p>
                View all parking slots and their current availability status.
            </p>

            <a
                href="${pageContext.request.contextPath}/manage-parking"
                class="btn">

                Manage Slots

            </a>

        </div>


        <!-- PAYMENT RECORDS -->

        <div class="menu-card">

            <h3>
                Payment Records
            </h3>

            <p>
                View all parking payment transactions and payment details.
            </p>

            <a
                href="${pageContext.request.contextPath}/payment-records"
                class="btn">

                Payment Records

            </a>

        </div>


    </div>


</div>


</body>

</html>