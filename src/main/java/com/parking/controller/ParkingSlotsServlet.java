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

@WebServlet("/manage-parking")
public class ParkingSlotsServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println();
        System.out.println("========================================");
        System.out.println("       MANAGE PARKING SERVLET");
        System.out.println("========================================");

        String sql =
                "SELECT "
                + "slot_id, "
                + "slot_number, "
                + "status "
                + "FROM parking_slots "
                + "ORDER BY slot_id";

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
                    "PARKING SLOTS QUERY EXECUTED"
            );

            request.setAttribute(
                    "slots",
                    resultSet
            );

            request.getRequestDispatcher(
                    "/manage-parking.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            System.out.println();
            System.out.println("========================================");
            System.out.println("MANAGE PARKING ERROR");
            System.out.println("========================================");

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load parking slots: "
                    + e.getMessage()
            );

            request.getRequestDispatcher(
                    "/manage-parking.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}