<%@ page import="java.sql.ResultSet" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Manage Parking</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .container {
            width: 90%;
            max-width: 900px;
            margin: 40px auto;
        }

        h1 {
            margin-bottom: 8px;
        }

        .subtitle {
            color: #555;
            margin-bottom: 25px;
        }

        .table-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.10);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #333;
            color: white;
            padding: 14px;
            text-align: left;
        }

        td {
            padding: 14px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background: #f5f5f5;
        }

        .available {
            color: #168316;
            font-weight: bold;
        }

        .occupied {
            color: #c00000;
            font-weight: bold;
        }

        .unknown {
            color: #666;
            font-weight: bold;
        }

        .error {
            background: #ffe5e5;
            color: #c00000;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .no-records {
            text-align: center;
            padding: 30px;
            color: #666;
        }

        .back {
            display: inline-block;
            margin-top: 20px;
            padding: 11px 18px;
            background: #333;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }

        .back:hover {
            background: #555;
        }

    </style>

</head>

<body>

<div class="container">

    <h1>Manage Parking</h1>

    <div class="subtitle">
        View the current status of all parking slots.
    </div>


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


    <div class="table-container">

        <table>

            <thead>

                <tr>

                    <th>Slot ID</th>

                    <th>Slot Number</th>

                    <th>Status</th>

                </tr>

            </thead>


            <tbody>

            <%

                ResultSet slots =
                        (ResultSet)
                        request.getAttribute("slots");

                if (slots != null) {

                    boolean hasSlots = false;

                    while (slots.next()) {

                        hasSlots = true;

                        int slotId =
                                slots.getInt("slot_id");

                        String slotNumber =
                                slots.getString("slot_number");

                        String status =
                                slots.getString("status");

            %>

                <tr>

                    <td>
                        <%= slotId %>
                    </td>

                    <td>
                        <%= slotNumber %>
                    </td>

                    <td>

                        <%

                            if ("AVAILABLE".equalsIgnoreCase(status)) {

                        %>

                            <span class="available">
                                AVAILABLE
                            </span>

                        <%

                            } else if ("OCCUPIED".equalsIgnoreCase(status)) {

                        %>

                            <span class="occupied">
                                OCCUPIED
                            </span>

                        <%

                            } else {

                        %>

                            <span class="unknown">
                                <%= status %>
                            </span>

                        <%

                            }

                        %>

                    </td>

                </tr>

            <%

                    }

                    if (!hasSlots) {

            %>

                <tr>

                    <td
                        colspan="3"
                        class="no-records">

                        No parking slots found.

                    </td>

                </tr>

            <%

                    }

                } else {

            %>

                <tr>

                    <td
                        colspan="3"
                        class="no-records">

                        No parking slot data available.

                    </td>

                </tr>

            <%

                }

            %>

            </tbody>

        </table>

    </div>


    <a
        href="${pageContext.request.contextPath}/dashboard"
        class="back">

         Back to Dashboard ?

    </a>

</div>

</body>

</html>