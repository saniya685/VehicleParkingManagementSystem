<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Parking Records</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .container {
            width: 95%;
            margin: 30px auto;
        }

        h1 {
            margin-bottom: 10px;
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
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #333;
            color: white;
            padding: 13px;
            text-align: left;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background: #f5f5f5;
        }

        .parked {
            color: #168316;
            font-weight: bold;
        }

        .completed {
            color: #555;
            font-weight: bold;
        }

        .no-records {
            text-align: center;
            padding: 30px;
            color: #666;
        }

        .error {
            background: #ffe5e5;
            color: #c00000;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
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

    <h1>Parking Records</h1>

    <div class="subtitle">
        View vehicle parking history and transaction records.
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

                    <th>Entry ID</th>

                    <th>Vehicle Number</th>

                    <th>Owner Name</th>

                    <th>Vehicle Type</th>

                    <th>Parking Slot</th>

                    <th>Entry Time</th>

                    <th>Exit Time</th>

                    <th>Duration</th>

                    <th>Parking Fee</th>

                    <th>Status</th>

                </tr>

            </thead>


            <tbody>

            <%
                java.sql.ResultSet records =
                        (java.sql.ResultSet)
                        request.getAttribute("records");

                if (records != null) {

                    boolean hasRecords = false;

                    while (records.next()) {

                        hasRecords = true;
            %>

                <tr>

                    <td>
                        <%= records.getInt("entry_id") %>
                    </td>

                    <td>
                        <%= records.getString("vehicle_number") %>
                    </td>

                    <td>
                        <%= records.getString("owner_name") %>
                    </td>

                    <td>
                        <%= records.getString("vehicle_type") %>
                    </td>

                    <td>
                        <%= records.getString("slot_number") %>
                    </td>

                    <td>
                        <%= records.getTimestamp("entry_time") %>
                    </td>

                    <td>

                        <%
                            java.sql.Timestamp exitTime =
                                    records.getTimestamp("exit_time");

                            if (exitTime != null) {
                        %>

                            <%= exitTime %>

                        <%
                            } else {
                        %>

                            -

                        <%
                            }
                        %>

                    </td>

                    <td>

                        <%
                            java.math.BigDecimal duration =
                                    records.getBigDecimal(
                                            "duration_hours"
                                    );

                            if (duration != null) {
                        %>

                            <%= duration %> hour(s)

                        <%
                            } else {
                        %>

                            -

                        <%
                            }
                        %>

                    </td>

                    <td>

                        <%
                            java.math.BigDecimal fee =
                                    records.getBigDecimal(
                                            "parking_fee"
                                    );

                            if (fee != null) {
                        %>

                            ?<%= fee %>

                        <%
                            } else {
                        %>

                            -

                        <%
                            }
                        %>

                    </td>

                    <td>

                        <%
                            String status =
                                    records.getString("status");

                            if ("PARKED".equalsIgnoreCase(status)) {
                        %>

                            <span class="parked">
                                PARKED
                            </span>

                        <%
                            } else {
                        %>

                            <span class="completed">
                                <%= status %>
                            </span>

                        <%
                            }
                        %>

                    </td>

                </tr>

            <%
                    }

                    if (!hasRecords) {
            %>

                <tr>

                    <td
                        colspan="10"
                        class="no-records">

                        No parking records found.

                    </td>

                </tr>

            <%
                    }

                } else {
            %>

                <tr>

                    <td
                        colspan="10"
                        class="no-records">

                        No parking records available.

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