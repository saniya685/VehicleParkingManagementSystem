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

@WebServlet("/vehicle-entry")
public class VehicleEntryServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/vehicle-entry.jsp"
        ).forward(request, response);
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String vehicleNumber =
                request.getParameter("vehicleNumber");

        String vehicleType =
                request.getParameter("vehicleType");

        String ownerName =
                request.getParameter("ownerName");


        System.out.println();
        System.out.println("=================================");
        System.out.println("VEHICLE ENTRY REQUEST");
        System.out.println("Vehicle Number: [" + vehicleNumber + "]");
        System.out.println("Vehicle Type: [" + vehicleType + "]");
        System.out.println("Owner Name: [" + ownerName + "]");
        System.out.println("=================================");


        if (vehicleNumber == null
                || vehicleNumber.trim().isEmpty()
                || vehicleType == null
                || vehicleType.trim().isEmpty()
                || ownerName == null
                || ownerName.trim().isEmpty()) {

            request.setAttribute(
                    "error",
                    "Please fill all fields."
            );

            request.getRequestDispatcher(
                    "/vehicle-entry.jsp"
            ).forward(request, response);

            return;
        }


        vehicleNumber =
                vehicleNumber.trim().toUpperCase();

        vehicleType =
                vehicleType.trim().toUpperCase();

        ownerName =
                ownerName.trim();


        try (Connection connection =
                     DBConnection.getConnection()) {

            connection.setAutoCommit(false);


            // =====================================
            // CHECK WHETHER VEHICLE IS ALREADY PARKED
            // =====================================

            String checkVehicleSql =
                    "SELECT pe.entry_id "
                    + "FROM parking_entries pe "
                    + "JOIN vehicles v "
                    + "ON pe.vehicle_id = v.vehicle_id "
                    + "WHERE UPPER(v.vehicle_number) = ? "
                    + "AND UPPER(pe.status) = 'PARKED'";

            try (PreparedStatement ps =
                         connection.prepareStatement(
                                 checkVehicleSql)) {

                ps.setString(1, vehicleNumber);

                try (ResultSet rs =
                             ps.executeQuery()) {

                    if (rs.next()) {

                        connection.rollback();

                        request.setAttribute(
                                "error",
                                "This vehicle is already parked."
                        );

                        request.getRequestDispatcher(
                                "/vehicle-entry.jsp"
                        ).forward(request, response);

                        return;
                    }
                }
            }


            // =====================================
            // FIND AVAILABLE SLOT
            // =====================================

            int slotId = 0;
            String slotNumber = null;

            String slotSql =
                    "SELECT slot_id, slot_number "
                    + "FROM parking_slots "
                    + "WHERE UPPER(TRIM(status)) = 'AVAILABLE' "
                    + "ORDER BY slot_id "
                    + "LIMIT 1";

            try (PreparedStatement ps =
                         connection.prepareStatement(slotSql);
                 ResultSet rs =
                         ps.executeQuery()) {

                if (rs.next()) {

                    slotId =
                            rs.getInt("slot_id");

                    slotNumber =
                            rs.getString("slot_number");

                } else {

                    connection.rollback();

                    request.setAttribute(
                            "error",
                            "No available parking slot."
                    );

                    request.getRequestDispatcher(
                            "/vehicle-entry.jsp"
                    ).forward(request, response);

                    return;
                }
            }


            // =====================================
            // CHECK VEHICLE EXISTS
            // =====================================

            int vehicleId = 0;

            String vehicleCheckSql =
                    "SELECT vehicle_id "
                    + "FROM vehicles "
                    + "WHERE UPPER(vehicle_number) = ?";

            try (PreparedStatement ps =
                         connection.prepareStatement(
                                 vehicleCheckSql)) {

                ps.setString(1, vehicleNumber);

                try (ResultSet rs =
                             ps.executeQuery()) {

                    if (rs.next()) {

                        vehicleId =
                                rs.getInt("vehicle_id");
                    }
                }
            }


            // =====================================
            // INSERT VEHICLE IF NEW
            // =====================================

            if (vehicleId == 0) {

                String insertVehicleSql =
                        "INSERT INTO vehicles "
                        + "(vehicle_number, vehicle_type, owner_name) "
                        + "VALUES (?, ?, ?)";

                try (PreparedStatement ps =
                             connection.prepareStatement(
                                     insertVehicleSql,
                                     PreparedStatement.RETURN_GENERATED_KEYS)) {

                    ps.setString(1, vehicleNumber);
                    ps.setString(2, vehicleType);
                    ps.setString(3, ownerName);

                    ps.executeUpdate();

                    try (ResultSet keys =
                                 ps.getGeneratedKeys()) {

                        if (keys.next()) {

                            vehicleId =
                                    keys.getInt(1);
                        }
                    }
                }

            } else {

                // Update owner/type for existing vehicle

                String updateVehicleSql =
                        "UPDATE vehicles "
                        + "SET vehicle_type = ?, owner_name = ? "
                        + "WHERE vehicle_id = ?";

                try (PreparedStatement ps =
                             connection.prepareStatement(
                                     updateVehicleSql)) {

                    ps.setString(1, vehicleType);
                    ps.setString(2, ownerName);
                    ps.setInt(3, vehicleId);

                    ps.executeUpdate();
                }
            }


            // =====================================
            // INSERT PARKING ENTRY
            // =====================================

            String entrySql =
                    "INSERT INTO parking_entries "
                    + "(vehicle_id, slot_id, entry_time, status) "
                    + "VALUES (?, ?, CURRENT_TIMESTAMP, 'PARKED')";

            try (PreparedStatement ps =
                         connection.prepareStatement(entrySql)) {

                ps.setInt(1, vehicleId);
                ps.setInt(2, slotId);

                ps.executeUpdate();
            }


            // =====================================
            // UPDATE SLOT
            // =====================================

            String updateSlotSql =
                    "UPDATE parking_slots "
                    + "SET status = 'OCCUPIED' "
                    + "WHERE slot_id = ?";

            try (PreparedStatement ps =
                         connection.prepareStatement(
                                 updateSlotSql)) {

                ps.setInt(1, slotId);

                ps.executeUpdate();
            }


            connection.commit();


            System.out.println(
                    "VEHICLE ENTRY SUCCESSFUL"
            );

            System.out.println(
                    "Vehicle: " + vehicleNumber
            );

            System.out.println(
                    "Allocated Slot: " + slotNumber
            );


            request.setAttribute(
                    "success",
                    "Vehicle registered successfully. "
                    + "Allocated Slot: "
                    + slotNumber
            );

            request.getRequestDispatcher(
                    "/vehicle-entry.jsp"
            ).forward(request, response);


        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Vehicle entry failed: "
                    + e.getMessage()
            );

            request.getRequestDispatcher(
                    "/vehicle-entry.jsp"
            ).forward(request, response);
        }
    }
}