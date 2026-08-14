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

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println();
        System.out.println("========================================");
        System.out.println("          DASHBOARD SERVLET");
        System.out.println("========================================");

        int totalSlots = 0;
        int availableSlots = 0;
        int occupiedSlots = 0;
        int todaysVehicles = 0;

        double todaysRevenue = 0.0;

        String totalSlotsSQL =
                "SELECT COUNT(*) FROM parking_slots";

        String availableSlotsSQL =
                "SELECT COUNT(*) "
                + "FROM parking_slots "
                + "WHERE UPPER(status) = 'AVAILABLE'";

        String occupiedSlotsSQL =
                "SELECT COUNT(*) "
                + "FROM parking_slots "
                + "WHERE UPPER(status) = 'OCCUPIED'";

        String todaysVehiclesSQL =
                "SELECT COUNT(*) "
                + "FROM parking_entries "
                + "WHERE DATE(entry_time) = CURDATE()";

        String todaysRevenueSQL =
                "SELECT COALESCE(SUM(amount), 0) "
                + "FROM payments "
                + "WHERE UPPER(payment_status) = 'PAID' "
                + "AND DATE(payment_time) = CURDATE()";

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement totalStatement =
                        connection.prepareStatement(totalSlotsSQL);

                PreparedStatement availableStatement =
                        connection.prepareStatement(availableSlotsSQL);

                PreparedStatement occupiedStatement =
                        connection.prepareStatement(occupiedSlotsSQL);

                PreparedStatement todayStatement =
                        connection.prepareStatement(todaysVehiclesSQL);

                PreparedStatement revenueStatement =
                        connection.prepareStatement(todaysRevenueSQL)
        ) {

            System.out.println(
                    "DATABASE CONNECTION SUCCESSFUL"
            );

            // TOTAL SLOTS

            try (ResultSet rs =
                    totalStatement.executeQuery()) {

                if (rs.next()) {
                    totalSlots = rs.getInt(1);
                }
            }


            // AVAILABLE SLOTS

            try (ResultSet rs =
                    availableStatement.executeQuery()) {

                if (rs.next()) {
                    availableSlots = rs.getInt(1);
                }
            }


            // OCCUPIED SLOTS

            try (ResultSet rs =
                    occupiedStatement.executeQuery()) {

                if (rs.next()) {
                    occupiedSlots = rs.getInt(1);
                }
            }


            // TODAY'S VEHICLES

            try (ResultSet rs =
                    todayStatement.executeQuery()) {

                if (rs.next()) {
                    todaysVehicles = rs.getInt(1);
                }
            }


            // TODAY'S REVENUE

            try (ResultSet rs =
                    revenueStatement.executeQuery()) {

                if (rs.next()) {
                    todaysRevenue = rs.getDouble(1);
                }
            }


            System.out.println(
                    "TOTAL SLOTS      : " + totalSlots
            );

            System.out.println(
                    "AVAILABLE SLOTS  : " + availableSlots
            );

            System.out.println(
                    "OCCUPIED SLOTS   : " + occupiedSlots
            );

            System.out.println(
                    "TODAY'S VEHICLES : " + todaysVehicles
            );

            System.out.println(
                    "TODAY'S REVENUE  : ₹" + todaysRevenue
            );


            // SEND DATA TO DASHBOARD

            request.setAttribute(
                    "totalSlots",
                    totalSlots
            );

            request.setAttribute(
                    "availableSlots",
                    availableSlots
            );

            request.setAttribute(
                    "occupiedSlots",
                    occupiedSlots
            );

            request.setAttribute(
                    "todaysVehicles",
                    todaysVehicles
            );

            request.setAttribute(
                    "todaysRevenue",
                    todaysRevenue
            );


            System.out.println(
                    "DASHBOARD DATA LOADED SUCCESSFULLY"
            );

            request.getRequestDispatcher(
                    "/dashboard.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            System.out.println();
            System.out.println("========================================");
            System.out.println("        DASHBOARD ERROR");
            System.out.println("========================================");

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load dashboard: "
                    + e.getMessage()
            );

            request.getRequestDispatcher(
                    "/dashboard.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}