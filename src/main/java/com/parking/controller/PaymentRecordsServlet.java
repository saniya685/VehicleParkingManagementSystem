package com.parking.controller;

import com.parking.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/payment-records")
public class PaymentRecordsServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println();
        System.out.println("========================================");
        System.out.println("       PAYMENT RECORDS SERVLET");
        System.out.println("========================================");

        String sql =
                "SELECT "
                + "payment_id, "
                + "entry_id, "
                + "amount, "
                + "payment_method, "
                + "payment_status, "
                + "payment_time "
                + "FROM payments "
                + "ORDER BY payment_id DESC";

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql);

                ResultSet resultSet =
                        statement.executeQuery()
        ) {

            System.out.println(
                    "DATABASE CONNECTION SUCCESSFUL"
            );

            System.out.println(
                    "PAYMENT RECORDS QUERY EXECUTED"
            );

            request.setAttribute(
                    "payments",
                    resultSet
            );

            request.getRequestDispatcher(
                    "/payment-records.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            System.out.println();
            System.out.println("========================================");
            System.out.println("       PAYMENT RECORDS ERROR");
            System.out.println("========================================");

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load payment records: "
                    + e.getMessage()
            );

            request.getRequestDispatcher(
                    "/payment-records.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}