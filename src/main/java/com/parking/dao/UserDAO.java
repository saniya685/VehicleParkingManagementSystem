package com.parking.dao;

import com.parking.model.User;
import com.parking.util.DBConnection;
import com.parking.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public User login(String username, String password) throws Exception {

        String sql =
                "SELECT user_id, username, password, role " +
                "FROM users WHERE username = ?";

        Connection connection =
                DBConnection.getConnection();

        PreparedStatement statement =
                connection.prepareStatement(sql);

        statement.setString(1, username.trim());

        ResultSet resultSet =
                statement.executeQuery();

        if (!resultSet.next()) {

            throw new Exception(
                    "USER NOT FOUND in database for username: ["
                    + username
                    + "]"
            );
        }

        String databaseHash =
                resultSet.getString("password");

        String generatedHash =
                PasswordUtil.hashPassword(password);

        if (!databaseHash.equals(generatedHash)) {

            throw new Exception(
                    "PASSWORD HASH MISMATCH\n"
                    + "Database hash: "
                    + databaseHash
                    + "\nGenerated hash: "
                    + generatedHash
            );
        }

        User user = new User();

        user.setUserId(
                resultSet.getInt("user_id")
        );

        user.setUsername(
                resultSet.getString("username")
        );

        user.setPassword(databaseHash);

        user.setRole(
                resultSet.getString("role")
        );

        resultSet.close();
        statement.close();
        connection.close();

        return user;
    }
}