package com.parking.dao;

import com.parking.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class VehicleDAO {

    public boolean vehicleExists(String vehicleNumber) throws Exception {

        String sql =
                "SELECT vehicle_id FROM vehicles " +
                "WHERE vehicle_number = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, vehicleNumber);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        }
    }

    public int addVehicle(
            String vehicleNumber,
            String vehicleType,
            String ownerName) throws Exception {

        String sql =
                "INSERT INTO vehicles " +
                "(vehicle_number, vehicle_type, owner_name) " +
                "VALUES (?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             sql,
                             java.sql.Statement.RETURN_GENERATED_KEYS)) {

            statement.setString(1, vehicleNumber);
            statement.setString(2, vehicleType);
            statement.setString(3, ownerName);

            statement.executeUpdate();

            try (ResultSet keys =
                         statement.getGeneratedKeys()) {

                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }

        return -1;
    }
}