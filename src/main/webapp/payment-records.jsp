<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.ResultSet" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Payment Records</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            color: #333;
        }

        .container {
            width: 92%;
            max-width: 1100px;
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
            overflow-x: auto;
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

        .paid {
            color: #168316;
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

    <h1>Payment Records</h1>

    <div class="subtitle">
        View all parking payment transactions.
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

                    <th>Payment ID</th>

                    <th>Entry ID</th>

                    <th>Amount</th>

                    <th>Payment Method</th>

                    <th>Payment Status</th>

                    <th>Payment Time</th>

                </tr>

            </thead>


            <tbody>

            <%

                ResultSet payments =
                        (ResultSet)
                        request.getAttribute("payments");

                if (payments != null) {

                    boolean hasRecords = false;

                    while (payments.next()) {

                        hasRecords = true;

            %>

                <tr>

                    <td>
                        <%= payments.getInt("payment_id") %>
                    </td>

                    <td>
                        <%= payments.getInt("entry_id") %>
                    </td>

                    <td>
                        ₹<%= payments.getBigDecimal("amount") %>
                    </td>

                    <td>
                        <%= payments.getString("payment_method") %>
                    </td>

                    <td>

                        <%
                            String status =
                                    payments.getString(
                                            "payment_status"
                                    );

                            if ("PAID".equalsIgnoreCase(status)) {
                        %>

                            <span class="paid">
                                PAID
                            </span>

                        <%
                            } else {
                        %>

                            <%= status %>

                        <%
                            }
                        %>

                    </td>

                    <td>
                        <%= payments.getTimestamp("payment_time") %>
                    </td>

                </tr>

            <%

                    }

                    if (!hasRecords) {

            %>

                <tr>

                    <td
                        colspan="6"
                        class="no-records">

                        No payment records found.

                    </td>

                </tr>

            <%

                    }

                } else {

            %>

                <tr>

                    <td
                        colspan="6"
                        class="no-records">

                        No payment data available.

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

        ← Back to Dashboard

    </a>

</div>

</body>

</html>