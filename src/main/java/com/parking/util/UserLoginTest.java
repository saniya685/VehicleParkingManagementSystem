package com.parking.util;

import com.parking.dao.UserDAO;
import com.parking.model.User;

public class UserLoginTest {

    public static void main(String[] args) {

        try {

            UserDAO userDAO = new UserDAO();

            User user =
                    userDAO.login("admin", "admin123");

            if (user != null) {

                System.out.println("LOGIN TEST SUCCESSFUL!");
                System.out.println("User ID: " + user.getUserId());
                System.out.println("Username: " + user.getUsername());
                System.out.println("Role: " + user.getRole());

            } else {

                System.out.println("LOGIN TEST FAILED!");

            }

        } catch (Exception e) {

            System.out.println("LOGIN TEST ERROR!");

            e.printStackTrace();
        }
    }
}