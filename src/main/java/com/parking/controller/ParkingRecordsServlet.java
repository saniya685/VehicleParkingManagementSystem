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

@WebServlet("/parking-records")
public class ParkingRecordsServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println();
        System.out.println("========================================");
        System.out.println("       PARKING RECORDS SERVLET");
        System.out.println("========================================");

        String sql =
                "SELECT "
                + "pe.entry_id, "
                + "v.vehicle_number, "
                + "v.owner_name, "
                + "v.vehicle_type, "
                + "ps.slot_number, "
                + "pe.entry_time, "
                + "pe.exit_time, "
                + "pe.duration_hours, "
                + "pe.parking_fee, "
                + "pe.status "
                + "FROM parking_entries pe "
                + "JOIN vehicles v "
                + "ON pe.vehicle_id = v.vehicle_id "
                + "LEFT JOIN parking_slots ps "
                + "ON pe.slot_id = ps.slot_id "
                + "ORDER BY pe.entry_id DESC";

        try {

            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery();


            System.out.println(
                    "DATABASE CONNECTION SUCCESSFUL"
            );

            System.out.println(
                    "PARKING RECORDS QUERY EXECUTED"
            );

            System.out.println(
                    "Opening parking-records.jsp"
            );


            /*
             * Keep the ResultSet available while the JSP
             * displays the records.
             */
            request.setAttribute(
                    "records",
                    resultSet
            );


            request.getRequestDispatcher(
                    "/parking-records.jsp"
            ).forward(
                    request,
                    response
            );


            /*
             * Close database resources after JSP
             * processing is completed.
             */
            resultSet.close();
            statement.close();
            connection.close();


            System.out.println(
                    "PARKING RECORDS PAGE LOADED SUCCESSFULLY"
            );

            System.out.println(
                    "========================================"
            );

        } catch (Exception e) {

            System.out.println();
            System.out.println("========================================");
            System.out.println("PARKING RECORDS ERROR");
            System.out.println("========================================");

            e.printStackTrace();


            request.setAttribute(
                    "error",
                    "Unable to load parking records: "
                    + e.getMessage()
            );


            request.getRequestDispatcher(
                    "/parking-records.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}