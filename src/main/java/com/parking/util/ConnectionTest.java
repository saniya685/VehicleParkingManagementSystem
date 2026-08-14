package com.parking.util;

public class ConnectionTest {

    public static void main(String[] args) {

        String password = "admin123";

        String hash = PasswordUtil.hashPassword(password);

        System.out.println("Password: " + password);
        System.out.println("Hash: " + hash);
    }
}