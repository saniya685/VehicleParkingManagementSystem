package com.parking.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/vehicle_parking_db"
            + "?useSSL=false"
            + "&serverTimezone=UTC"
            + "&allowPublicKeyRetrieval=true";

    private static final String USERNAME = "root";

    // IMPORTANT:
    // Put the SAME MySQL root password that you used
    // when your UserLoginTest was working.
    private static final String PASSWORD = System.getenv("DB_PASSWORD");

    public static Connection getConnection() throws Exception {

        // Explicitly load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        return DriverManager.getConnection(
                URL,
                USERNAME,
                PASSWORD
        );
    }
}