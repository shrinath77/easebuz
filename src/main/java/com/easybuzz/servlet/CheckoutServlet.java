package com.easybuzz.servlet;

import com.easybuzz.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    /**
     * GET /checkout — forward to the checkout page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    /**
     * POST /checkout — handle AJAX payment requests from checkout.jsp
     * Expects a JSON body: { "method": "card|upi|netbanking|wallet|bnpl", "amount": "1500.00", ... }
     * Returns: { "status": "success|error", "message": "..." }
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Read JSON request body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            String body = sb.toString();
            System.out.println("[CheckoutServlet] Payment request received: " + body);

            // Extract the "method" field from JSON using simple string parsing
            String method = "UNKNOWN";
            if (body.contains("\"method\"")) {
                int start = body.indexOf("\"method\"") + 10; // after "method":
                // skip whitespace and opening quote
                while (start < body.length() && (body.charAt(start) == ' ' || body.charAt(start) == ':' || body.charAt(start) == '"')) {
                    start++;
                }
                int end = body.indexOf("\"", start);
                if (end > start) {
                    method = body.substring(start, end).toUpperCase();
                }
            }

            // Read amount from the JSON body (sent by buildPayload in checkout.jsp)
            String amount = "0.00";
            if (body.contains("\"amount\"")) {
                int aStart = body.indexOf("\"amount\"") + 10;
                while (aStart < body.length() && (body.charAt(aStart) == ' ' || body.charAt(aStart) == ':' || body.charAt(aStart) == '"')) {
                    aStart++;
                }
                int aEnd = body.indexOf("\"", aStart);
                if (aEnd > aStart) amount = body.substring(aStart, aEnd);
            }

            System.out.println("[CheckoutServlet] Payment Method: " + method + " | Amount: \u20B9" + amount);

            // Get merchantTxnId from session to identify which record to update
            HttpSession session = request.getSession(false);
            String merchantTxnId = (session != null) ? (String) session.getAttribute("merchantTxnId") : null;

            // TODO: Integrate with real payment gateway here
            // For now, simulate a successful payment response
            String txnId = "TXN" + System.currentTimeMillis();

            // UPDATE payment_status to SUCCESS in DB
            updatePaymentStatus(merchantTxnId, "SUCCESS");

            String jsonResponse = "{"
                    + "\"status\":\"success\","
                    + "\"message\":\"Payment of \\u20B9" + amount + " received via " + method + ". Transaction ID: " + txnId + "\""
                    + "}";

            response.getWriter().write(jsonResponse);

        } catch (Exception e) {
            e.printStackTrace();

            // Try to mark the transaction as FAILED in DB
            HttpSession session = request.getSession(false);
            String merchantTxnId = (session != null) ? (String) session.getAttribute("merchantTxnId") : null;
            updatePaymentStatus(merchantTxnId, "FAILED");

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{"
                    + "\"status\":\"error\","
                    + "\"message\":\"Payment processing failed. Please try again.\""
                    + "}");
        }
    }

    /**
     * Updates payment_status in the payment table for a given merchantTxnId.
     */
    private void updatePaymentStatus(String merchantTxnId, String status) {
        if (merchantTxnId == null || merchantTxnId.isEmpty()) {
            System.err.println("[CheckoutServlet] Cannot update status — merchantTxnId is null");
            return;
        }
        try {
            Connection conn = DBConnection.getConnection();
            if (conn != null) {
                String sql = "UPDATE transactions SET payment_status = ? WHERE merchant_txn_id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, status);
                ps.setString(2, merchantTxnId);
                int rows = ps.executeUpdate();
                System.out.println("[CheckoutServlet] payment_status set to " + status + " for txn: " + merchantTxnId + " (" + rows + " row updated)");
                ps.close();
                conn.close();
            }
        } catch (Exception ex) {
            System.err.println("[CheckoutServlet] Failed to update payment_status: " + ex.getMessage());
        }
    }
}
