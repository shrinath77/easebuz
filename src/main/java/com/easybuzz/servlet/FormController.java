package com.easybuzz.servlet;

import com.easybuzz.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/merchant-form")
public class FormController extends HttpServlet {

    // Load JSP form
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/merchant-form.jsp")
                .forward(request, response);
    }

    // Handle form submission + DB connection
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String merchantName = request.getParameter("merchantName");
        String merchantId = request.getParameter("merchantId");
        String merchantTxnId = request.getParameter("merchantTxnId");
        String customerEmail = request.getParameter("customerEmail");
        String customerMobile = request.getParameter("customerMobile");

        System.out.println("Form Submitted: " + merchantName);

        try {
            Connection conn = DBConnection.getConnection();

            if (conn != null) {
                System.out.println(" Database Connected Successfully");

                String sql = "INSERT INTO payment (merchant_name, merchant_id, merchant_txn_id, customer_email, customer_mobile) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);

                ps.setString(1, merchantName);
                ps.setString(2, merchantId);
                ps.setString(3, merchantTxnId);
                ps.setString(4, customerEmail);
                ps.setString(5, customerMobile);

                int rows = ps.executeUpdate();

                if (rows > 0) {
                    response.getWriter().println("Transaction Saved Successfully!");
                } else {
                    response.getWriter().println("Failed to Save Transaction!");
                }

                ps.close();
                conn.close();
            } else {
                response.getWriter().println("Database Connection Failed!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}