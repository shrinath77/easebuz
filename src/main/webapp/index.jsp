<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>EaseBuzz - Home</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; text-align: center; padding-top: 80px; }
        h1   { color: #2c3e50; }
        p    { color: #555; margin-bottom: 30px; }
        .btn {
            display: inline-block;
            margin: 10px;
            padding: 14px 30px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 16px;
        }
        .btn:hover { background: #0056b3; }
        .btn.green { background: #1f6f4a; }
        .btn.green:hover { background: #0d3f2b; }
    </style>
</head>
<body>
    <h1>EaseBuzz Payment Gateway</h1>
    <p>Secure, fast, and reliable payment processing.</p>
    <a href="merchant-form" class="btn">Start a Transaction</a>
    <a href="checkout"      class="btn green">Go to Checkout</a>
</body>
</html>