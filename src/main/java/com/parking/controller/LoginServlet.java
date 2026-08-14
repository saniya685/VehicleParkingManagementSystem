package com.parking.controller;

import com.parking.dao.UserDAO;
import com.parking.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username =
                request.getParameter("username");

        String password =
                request.getParameter("password");

        System.out.println();
        System.out.println("=================================");
        System.out.println("LOGIN ATTEMPT");
        System.out.println("Username: [" + username + "]");
        System.out.println("=================================");

        try {

            UserDAO userDAO =
                    new UserDAO();

            User user =
                    userDAO.login(
                            username,
                            password
                    );

            if (user != null) {

                System.out.println(
                        "LOGIN SUCCESSFUL"
                );

                System.out.println(
                        "User ID: "
                        + user.getUserId()
                );

                System.out.println(
                        "Username: "
                        + user.getUsername()
                );

                System.out.println(
                        "Role: "
                        + user.getRole()
                );

                HttpSession session =
                        request.getSession();

                session.setAttribute(
                        "user",
                        user
                );

                // IMPORTANT
                // Call DashboardServlet
                response.sendRedirect(
                        request.getContextPath()
                        + "/dashboard"
                );

            } else {

                System.out.println(
                        "LOGIN FAILED"
                );

                request.setAttribute(
                        "error",
                        "Invalid username or password"
                );

                request.getRequestDispatcher(
                        "/login.jsp"
                ).forward(
                        request,
                        response
                );
            }

        } catch (Exception e) {

            System.out.println(
                    "LOGIN ERROR"
            );

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Login error: "
                    + e.getMessage()
            );

            request.getRequestDispatcher(
                    "/login.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}