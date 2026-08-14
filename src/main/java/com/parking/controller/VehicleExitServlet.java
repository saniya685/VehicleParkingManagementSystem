package com.parking.controller;

import com.parking.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.LocalDateTime;

@WebServlet("/vehicle-exit")
public class VehicleExitServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println();
        System.out.println("========================================");
        System.out.println("          VEHICLE EXIT DEBUG");
        System.out.println("========================================");

        String vehicleNumber =
                request.getParameter("vehicleNumber");

        String paymentMethod =
                request.getParameter("paymentMethod");


        /*
         * CLEAN VEHICLE NUMBER
         *
         * This fixes uppercase/lowercase problems.
         */

        if (vehicleNumber != null) {

            vehicleNumber =
                    vehicleNumber.trim().toUpperCase();

        }


        if (paymentMethod != null) {

            paymentMethod =
                    paymentMethod.trim().toUpperCase();

        }


        System.out.println(
                "Vehicle Number Received: ["
                + vehicleNumber
                + "]"
        );

        System.out.println(
                "Payment Method: ["
                + paymentMethod
                + "]"
        );


        if (vehicleNumber == null
                || vehicleNumber.isEmpty()) {

            request.setAttribute(
                    "error",
                    "Please enter vehicle number."
            );

            request.getRequestDispatcher(
                    "/vehicle-exit.jsp"
            ).forward(request, response);

            return;
        }


        if (paymentMethod == null
                || paymentMethod.isEmpty()) {

            request.setAttribute(
                    "error",
                    "Please select payment method."
            );

            request.getRequestDispatcher(
                    "/vehicle-exit.jsp"
            ).forward(request, response);

            return;
        }


        try (Connection connection =
                     DBConnection.getConnection()) {


            /*
             * ==================================================
             * 1. FIND CURRENTLY PARKED VEHICLE
             * ==================================================
             *
             * LOWER(TRIM()) makes the search
             * case-insensitive and ignores spaces.
             */

            String findVehicleSQL =
                    "SELECT "
                    + "pe.entry_id, "
                    + "pe.vehicle_id, "
                    + "pe.entry_time, "
                    + "pe.status, "
                    + "v.vehicle_number, "
                    + "v.owner_name, "
                    + "v.vehicle_type "
                    + "FROM parking_entries pe "
                    + "JOIN vehicles v "
                    + "ON pe.vehicle_id = v.vehicle_id "
                    + "WHERE LOWER(TRIM(v.vehicle_number)) "
                    + "= LOWER(TRIM(?)) "
                    + "AND pe.exit_time IS NULL "
                    + "ORDER BY pe.entry_id DESC "
                    + "LIMIT 1";


            int entryId;
            int vehicleId;

            Timestamp entryTime;

            String actualVehicleNumber;
            String ownerName;
            String vehicleType;


            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 findVehicleSQL
                         )) {


                statement.setString(
                        1,
                        vehicleNumber
                );


                try (ResultSet resultSet =
                             statement.executeQuery()) {


                    if (!resultSet.next()) {

                        System.out.println(
                                "NO PARKED VEHICLE FOUND"
                        );

                        System.out.println(
                                "Searched Vehicle: "
                                + vehicleNumber
                        );


                        request.setAttribute(
                                "error",
                                "No parked vehicle found for vehicle number: "
                                + vehicleNumber
                        );


                        request.getRequestDispatcher(
                                "/vehicle-exit.jsp"
                        ).forward(
                                request,
                                response
                        );

                        return;
                    }


                    entryId =
                            resultSet.getInt(
                                    "entry_id"
                            );


                    vehicleId =
                            resultSet.getInt(
                                    "vehicle_id"
                            );


                    entryTime =
                            resultSet.getTimestamp(
                                    "entry_time"
                            );


                    actualVehicleNumber =
                            resultSet.getString(
                                    "vehicle_number"
                            );


                    ownerName =
                            resultSet.getString(
                                    "owner_name"
                            );


                    vehicleType =
                            resultSet.getString(
                                    "vehicle_type"
                            );
                }
            }


            System.out.println(
                    "PARKED VEHICLE FOUND"
            );

            System.out.println(
                    "Entry ID: " + entryId
            );

            System.out.println(
                    "Vehicle ID: " + vehicleId
            );

            System.out.println(
                    "Vehicle Number: "
                    + actualVehicleNumber
            );

            System.out.println(
                    "Owner: " + ownerName
            );

            System.out.println(
                    "Vehicle Type: " + vehicleType
            );


            /*
             * ==================================================
             * 2. CALCULATE EXIT TIME
             * ==================================================
             */

            LocalDateTime exitDateTime =
                    LocalDateTime.now();


            Timestamp exitTime =
                    Timestamp.valueOf(
                            exitDateTime
                    );


            /*
             * ==================================================
             * 3. CALCULATE PARKING DURATION
             * ==================================================
             */

            LocalDateTime entryDateTime =
                    entryTime.toLocalDateTime();


            Duration duration =
                    Duration.between(
                            entryDateTime,
                            exitDateTime
                    );


            long totalMinutes =
                    duration.toMinutes();


            /*
             * Minimum billing duration = 1 hour
             *
             * Example:
             * 10 minutes = 1 hour
             * 55 minutes = 1 hour
             * 65 minutes = 2 hours
             */

            long durationHours =
                    (long) Math.ceil(
                            totalMinutes / 60.0
                    );


            if (durationHours < 1) {

                durationHours = 1;

            }


            System.out.println(
                    "Duration Minutes: "
                    + totalMinutes
            );

            System.out.println(
                    "Duration Hours: "
                    + durationHours
            );


            /*
             * ==================================================
             * 4. GET PRICING
             * ==================================================
             */

            String pricingSQL =
                    "SELECT "
                    + "first_hour_rate, "
                    + "additional_hour_rate "
                    + "FROM pricing "
                    + "WHERE UPPER(vehicle_type) "
                    + "= UPPER(?) "
                    + "LIMIT 1";


            BigDecimal firstHourRate =
                    BigDecimal.ZERO;

            BigDecimal additionalHourRate =
                    BigDecimal.ZERO;


            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 pricingSQL
                         )) {


                statement.setString(
                        1,
                        vehicleType
                );


                try (ResultSet resultSet =
                             statement.executeQuery()) {


                    if (resultSet.next()) {

                        firstHourRate =
                                resultSet.getBigDecimal(
                                        "first_hour_rate"
                                );


                        additionalHourRate =
                                resultSet.getBigDecimal(
                                        "additional_hour_rate"
                                );

                    }
                }
            }


            /*
             * ==================================================
             * 5. CALCULATE PARKING FEE
             * ==================================================
             */

            BigDecimal parkingFee;


            if (durationHours <= 1) {

                parkingFee =
                        firstHourRate;

            } else {

                long additionalHours =
                        durationHours - 1;


                parkingFee =
                        firstHourRate.add(
                                additionalHourRate.multiply(
                                        BigDecimal.valueOf(
                                                additionalHours
                                        )
                                )
                        );
            }


            System.out.println(
                    "First Hour Rate: ₹"
                    + firstHourRate
            );

            System.out.println(
                    "Additional Hour Rate: ₹"
                    + additionalHourRate
            );

            System.out.println(
                    "Parking Fee: ₹"
                    + parkingFee
            );


            /*
             * ==================================================
             * 6. UPDATE PARKING ENTRY
             * ==================================================
             */

            String updateEntrySQL =
                    "UPDATE parking_entries "
                    + "SET exit_time = ?, "
                    + "duration_hours = ?, "
                    + "parking_fee = ?, "
                    + "status = 'COMPLETED' "
                    + "WHERE entry_id = ?";


            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 updateEntrySQL
                         )) {


                statement.setTimestamp(
                        1,
                        exitTime
                );


                statement.setBigDecimal(
                        2,
                        BigDecimal.valueOf(
                                durationHours
                        )
                );


                statement.setBigDecimal(
                        3,
                        parkingFee
                );


                statement.setInt(
                        4,
                        entryId
                );


                statement.executeUpdate();
            }


            System.out.println(
                    "PARKING ENTRY UPDATED"
            );


            /*
             * ==================================================
             * 7. MAKE PARKING SLOT AVAILABLE
             * ==================================================
             */

            String updateSlotSQL =
                    "UPDATE parking_slots ps "
                    + "JOIN parking_entries pe "
                    + "ON ps.slot_id = pe.slot_id "
                    + "SET ps.status = 'AVAILABLE' "
                    + "WHERE pe.entry_id = ?";


            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 updateSlotSQL
                         )) {


                statement.setInt(
                        1,
                        entryId
                );


                statement.executeUpdate();
            }


            System.out.println(
                    "PARKING SLOT UPDATED TO AVAILABLE"
            );


            /*
             * ==================================================
             * 8. INSERT PAYMENT
             * ==================================================
             */

            String paymentSQL =
                    "INSERT INTO payments "
                    + "(entry_id, amount, payment_method, "
                    + "payment_status) "
                    + "VALUES (?, ?, ?, 'PAID')";


            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 paymentSQL
                         )) {


                statement.setInt(
                        1,
                        entryId
                );


                statement.setBigDecimal(
                        2,
                        parkingFee
                );


                statement.setString(
                        3,
                        paymentMethod
                );


                statement.executeUpdate();
            }


            System.out.println(
                    "PAYMENT RECORD INSERTED"
            );


            System.out.println();
            System.out.println(
                    "========================================"
            );

            System.out.println(
                    "         VEHICLE EXIT SUCCESSFUL"
            );

            System.out.println(
                    "========================================"
            );

            System.out.println(
                    "Vehicle: "
                    + actualVehicleNumber
            );

            System.out.println(
                    "Owner: "
                    + ownerName
            );

            System.out.println(
                    "Duration: "
                    + durationHours
                    + " hour(s)"
            );

            System.out.println(
                    "Parking Fee: ₹"
                    + parkingFee
            );

            System.out.println(
                    "Payment: "
                    + paymentMethod
            );


            /*
             * ==================================================
             * 9. SEND RESULT TO EXIT PAGE
             * ==================================================
             */

            request.setAttribute(
                    "success",
                    "Vehicle exit completed successfully."
            );

            request.setAttribute(
                    "vehicleNumber",
                    actualVehicleNumber
            );

            request.setAttribute(
                    "ownerName",
                    ownerName
            );

            request.setAttribute(
                    "vehicleType",
                    vehicleType
            );

            request.setAttribute(
                    "durationHours",
                    durationHours
            );

            request.setAttribute(
                    "parkingFee",
                    parkingFee
            );

            request.setAttribute(
                    "paymentMethod",
                    paymentMethod
            );


            request.getRequestDispatcher(
                    "/vehicle-exit.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            System.out.println();
            System.out.println(
                    "========================================"
            );

            System.out.println(
                    "          VEHICLE EXIT ERROR"
            );

            System.out.println(
                    "========================================"
            );

            e.printStackTrace();


            request.setAttribute(
                    "error",
                    "Vehicle exit failed: "
                    + e.getMessage()
            );


            request.getRequestDispatcher(
                    "/vehicle-exit.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}