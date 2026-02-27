package com.easybuzz.servlet;

import com.easybuzz.util.AESGCMUtil;
import com.easybuzz.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/PaymentProcess")
public class PaymentProcess extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            System.out.println(" PaymentProcess HIT");

            // Get form values
            String merchantName = request.getParameter("merchantName");
            String merchantId = request.getParameter("merchantId");
            String merchantTxnId = request.getParameter("merchantTxnId");
            String customerEmail = request.getParameter("customerEmail");
            String customerMobile = request.getParameter("customerMobile");

            // Amount — validate and normalise to 2 decimal places
            String amountRaw = request.getParameter("amount");
            String amount;
            try {
                double amtVal = Double.parseDouble(amountRaw);
                amount = String.format("%.2f", amtVal);
            } catch (Exception e) {
                amount = "0.00";
            }

            System.out.println("Merchant Name: " + merchantName);
            System.out.println("Merchant ID: " + merchantId);
            System.out.println("Amount: ₹" + amount);

            //  DATABASE INSERT
            Connection conn = DBConnection.getConnection();

            if (conn != null) {
                System.out.println(" DB Connected");

                String sql = "INSERT INTO payment (merchant_name, merchant_id, merchant_txn_id, customer_email, customer_mobile, amount, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);

                ps.setString(1, merchantName);
                ps.setString(2, merchantId);
                ps.setString(3, merchantTxnId);
                ps.setString(4, customerEmail);
                ps.setString(5, customerMobile);
                ps.setDouble(6, Double.parseDouble(amount));
                ps.setString(7, "PENDING");

                int rows = ps.executeUpdate();
                System.out.println(" Rows inserted: " + rows);

                ps.close();
                conn.close();
            } else {
                System.out.println(" DB Connection is NULL");
            }

            // Encrypt transaction data and store in session for checkout page
            String jsonData = "{"
                    + "\"merchantId\":\"" + merchantId + "\","
                    + "\"merchantTxnId\":\"" + merchantTxnId + "\","
                    + "\"customerEmail\":\"" + customerEmail + "\","
                    + "\"customerMobile\":\"" + customerMobile + "\""
                    + "}";

            String encryptedData = AESGCMUtil.encrypt(jsonData);

            // Store merchant details in session so checkout.jsp can access them
            HttpSession session = request.getSession();
            session.setAttribute("merchantId",       merchantId);
            session.setAttribute("merchantTxnId",    merchantTxnId);
            session.setAttribute("customerEmail",    customerEmail);
            session.setAttribute("customerMobile",   customerMobile);
            session.setAttribute("amount",           amount);
            session.setAttribute("encryptedPayload", encryptedData);

            System.out.println("[PaymentProcess] Transaction saved. Redirecting to checkout...");

            // Redirect to checkout page
            response.sendRedirect(request.getContextPath() + "/checkout");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/merchant-form?error=true");
        }
    }
}