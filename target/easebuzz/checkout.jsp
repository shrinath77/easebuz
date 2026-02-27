<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
    // Read amount from session (set by PaymentProcess); default to 0.00 for direct access
    String sessionAmt = (String) session.getAttribute("amount");
    double amtVal = 0.00;
    try { amtVal = Double.parseDouble(sessionAmt); } catch (Exception ignored) {}
    String amount    = String.format("%.2f", amtVal);
    String amt3mo    = String.format("%.2f", amtVal / 3);
    String amt6mo    = String.format("%.2f", amtVal / 6);
    String amt12mo   = String.format("%.2f", amtVal / 12);
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/png"
          href="<%=request.getContextPath()%>/images/splogo.png" sizes="32x32">
    <title>SP Transaction Hub - Trusted Business</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, sans-serif;
}

body {
    background: #f4f6f8;
}

.checkout-wrapper {
    width: 1000px;
    height: 590px;
    margin: 40px auto;
    display: flex;
    border-radius: 14px;
    overflow: hidden;
    box-shadow: 0 10px 35px rgba(0, 0, 0, 0.15);
    background: #fff;
}

/* LEFT PANEL */
.left-panel {
    width: 35%;
    background: linear-gradient(135deg, #1f6f4a, #0d3f2b);
    color: white;
    padding: 30px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.brand {
    display: flex;
    flex-direction: row;
    align-items: center;
    gap: 10px;
}

.brand img.brand-logo {
    width: 60px;
    height: 60px;
    object-fit: contain;
    border-radius: 8px;
    flex-shrink: 0;
}

.brand-text h2 {
    font-size: 22px;
    font-weight: bold;
    line-height: 1.2;
}

.brand-text p {
    font-size: 12px;
    opacity: 0.9;
    margin-top: 3px;
}

.price-box {
    background: rgba(255, 255, 255, 0.15);
    padding: 20px;
    border-radius: 12px;
    margin-top: 20px;
}

.price-box p {
    font-size: 14px;
    opacity: 0.9;
}

.price-box h1 {
    margin-top: 8px;
    font-size: 38px;
}

.user {
    margin-top: 20px;
    background: rgba(255, 255, 255, 0.1);
    padding: 12px;
    border-radius: 8px;
    font-size: 14px;
}

.secured {
    font-size: 12px;
    opacity: 0.85;
}

/* RIGHT PANEL */
.right-panel {
    width: 65%;
    padding: 25px;
    background: #ffffff;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.header h3 {
    font-size: 22px;
}

.timer {
    font-weight: bold;
    color: #d32f2f;
    font-size: 16px;
}

/* PAYMENT LAYOUT */
.payment-container {
    display: flex;
    margin-top: 20px;
    height: 460px;
    border-top: 1px solid #eee;
}

.methods {
    width: 35%;
    border-right: 1px solid #eee;
    background: #fafafa;
}

.method {
    padding: 14px 16px;
    cursor: pointer;
    border-bottom: 1px solid #f1f1f1;
    font-weight: 500;
    font-size: 14px;
    transition: 0.2s;
}

.method:hover {
    background: #f1f5fb;
}

.active {
    background: #e8f0fe;
    font-weight: bold;
    color: #1a73e8;
}

.details {
    width: 65%;
    padding: 20px 25px;
    overflow-y: auto;
}

.details input, .details select {
    width: 100%;
    padding: 11px;
    margin-top: 12px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 14px;
}

.qr-box {
    text-align: center;
}

.qr-box img.qr {
    margin-top: 12px;
    border: 1px solid #eee;
    padding: 8px;
    border-radius: 8px;
}

/* UPI Logos */
.upi-logos {
    display: flex;
    justify-content: center;
    gap: 12px;
    margin-top: 15px;
}

.upi-logos img {
    width: 45px;
    height: 45px;
    object-fit: contain;
    border-radius: 8px;
    background: #fff;
    padding: 5px;
    border: 1px solid #eee;
}

/* Card Logos */
.card-logos {
    display: flex;
    gap: 10px;
    margin-bottom: 15px;
    align-items: center;
}

.card-logos img {
    width: 150px;
    height: 90px;
    object-fit: contain;
}

/* ===================== BNPL STYLES ===================== */
.bnpl-header {
    text-align: center;
    margin-bottom: 12px;
}

.bnpl-header h4 {
    font-size: 15px;
    color: #333;
}

.bnpl-header p {
    font-size: 12px;
    color: #888;
    margin-top: 3px;
}

.bnpl-providers {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    justify-content: center;
    margin-bottom: 10px;
}

.bnpl-provider-btn {
    border: 2px solid #ddd;
    border-radius: 10px;
    padding: 7px 14px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
    background: #fff;
    transition: 0.2s;
    color: #333;
    min-width: 88px;
    text-align: center;
}

.bnpl-provider-btn:hover {
    border-color: #1a73e8;
    color: #1a73e8;
    background: #f0f6ff;
}

.bnpl-provider-btn.selected {
    border-color: #1a73e8;
    background: #e8f0fe;
    color: #1a73e8;
}

.bnpl-emi-box {
    background: #f9f9f9;
    border: 1px solid #eee;
    border-radius: 10px;
    padding: 10px 12px;
    margin-top: 10px;
    font-size: 13px;
    color: #444;
}

.bnpl-emi-box p {
    margin-bottom: 6px;
    font-weight: 600;
    color: #333;
}

.bnpl-emi-options {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
    margin-top: 4px;
}

.emi-option {
    border: 1px solid #ccc;
    border-radius: 8px;
    padding: 6px 10px;
    cursor: pointer;
    font-size: 12px;
    background: #fff;
    transition: 0.2s;
    text-align: center;
    min-width: 72px;
}

.emi-option:hover {
    border-color: #1a73e8;
    color: #1a73e8;
}

.emi-option.selected {
    border-color: #1a73e8;
    background: #e8f0fe;
    color: #1a73e8;
    font-weight: bold;
}
/* ====================================================== */

.pay-btn {
    width: 100%;
    margin-top: 20px;
    padding: 14px;
    background: #3399cc;
    border: none;
    color: white;
    font-size: 17px;
    border-radius: 8px;
    cursor: pointer;
    transition: 0.3s;
}

.pay-btn:hover {
    background: #2a85b3;
}

.pay-btn:disabled {
    background: #aaa;
    cursor: not-allowed;
}

#msg {
    margin-top: 18px;
    font-weight: bold;
    text-align: center;
    font-size: 15px;
}
</style>
</head>

<body>

<div class="checkout-wrapper">

    <!-- LEFT SIDE -->
    <div class="left-panel">
        <div>
            <div class="brand">
                <img class="brand-logo" src="images/splogo.png" alt="SP Logo">
                <div class="brand-text">
                    <h2>SP Transaction Hub</h2>
                    <p>Secure Payments</p>
                </div>
            </div>

            <div class="price-box">
                <p>Price Summary</p>
                <h1>₹<%= amount %></h1>
            </div>

</div>

        <div class="secured">🔒 Secured by SP Transaction Hub</div>
    </div>

    <!-- RIGHT SIDE -->
    <div class="right-panel">
        <div class="header">
            <h3>Payment Options</h3>
            <div class="timer">
                ⏳ Time Left: <span id="countdown">05:00</span>
            </div>
        </div>

        <div class="payment-container">

            <!-- METHODS -->
            <div class="methods">
                <div class="method active" onclick="selectMethod('upi', this)">UPI (QR)</div>
                <div class="method" onclick="selectMethod('card', this)">Cards</div>
                <div class="method" onclick="selectMethod('netbanking', this)">Netbanking</div>
                <div class="method" onclick="selectMethod('wallet', this)">Wallet</div>
                <div class="method" onclick="selectMethod('bnpl', this)">
                    Buy Now Pay Later
                    <div style="font-size: 11px; color: #888; font-weight: normal; margin-top: 2px;">EMI / No-Cost</div>
                </div>
            </div>

            <!-- DETAILS -->
            <div class="details">

                <!-- UPI SECTION -->
                <div id="upiSection">
                    <div class="qr-box">
                        <h4>Scan QR to Pay</h4>
                        <img class="qr"
                            src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=SPTransactionHubPayment" />
                        <p style="margin-top: 10px;">Scan with any UPI App</p>
                        <div class="upi-logos">
                            <img src="images/googlepay.png" alt="GPay">
                            <img src="images/Phonepay.png" alt="PhonePe">
                            <img src="images/Paytm.png" alt="Paytm">
                        </div>
                    </div>
                </div>

                <!-- CARD SECTION -->
                <div id="cardSection" style="display: none;">
                    <div class="card-logos">
                        <img src="images/Visa.png" alt="Visa">
                        <img src="images/Mastercard.png" alt="Mastercard">
                        <img src="images/Rupay.png" alt="RuPay">
                    </div>
                    <input type="text"     id="cardNumber" placeholder="Card Number"      maxlength="19">
                    <input type="text"     id="cardName"   placeholder="Card Holder Name">
                    <input type="text"     id="cardExpiry" placeholder="MM/YY"            maxlength="5">
                    <input type="password" id="cvv"        placeholder="CVV"              maxlength="3">
                </div>

                <!-- NETBANKING SECTION -->
                <div id="netbankingSection" style="display: none;">
                    <select id="bank">
                        <option value="">Select Bank</option>
                        <option value="HDFC">HDFC Bank</option>
                        <option value="SBI">SBI</option>
                        <option value="ICICI">ICICI Bank</option>
                        <option value="AXIS">Axis Bank</option>
                    </select>
                </div>

                <!-- WALLET SECTION -->
                <div id="walletSection" style="display: none;">
                    <select id="wallet">
                        <option value="">Select Wallet</option>
                        <option value="paytm">Paytm Wallet</option>
                        <option value="amazonpay">Amazon Pay</option>
                        <option value="mobikwik">MobiKwik</option>
                        <option value="freecharge">FreeCharge</option>
                    </select>
                    <input type="text" id="walletMobile" placeholder="Registered Mobile Number" maxlength="10">
                </div>

                <!-- BNPL SECTION -->
                <div id="bnplSection" style="display: none;">

                    <div class="bnpl-header">
                        <h4>Buy Now, Pay Later</h4>
                        <p>Select a provider and choose your EMI plan</p>
                    </div>

                    <!-- Provider Buttons -->
                    <div class="bnpl-providers">
                        <div class="bnpl-provider-btn" onclick="selectBNPLProvider('simpl', this)">Simpl</div>
                        <div class="bnpl-provider-btn" onclick="selectBNPLProvider('lazypay', this)">LazyPay</div>
                        <div class="bnpl-provider-btn" onclick="selectBNPLProvider('zestmoney', this)">ZestMoney</div>
                        <div class="bnpl-provider-btn" onclick="selectBNPLProvider('olamoney', this)">Ola Money</div>
                    </div>

                    <!-- Mobile & PAN -->
                    <input type="text" id="bnplMobile" placeholder="Registered Mobile Number" maxlength="10">
                    <input type="text" id="bnplPan"    placeholder="PAN Number (optional)"    maxlength="10"
                           style="text-transform: uppercase;">

                    <!-- EMI Plans -->
                    <div class="bnpl-emi-box">
                        <p>Choose EMI Plan:</p>
                        <div class="bnpl-emi-options">
                            <div class="emi-option" onclick="selectEMI('1', this)">
                                Pay Full<br><small>₹<%= amount %></small>
                            </div>
                            <div class="emi-option" onclick="selectEMI('3', this)">
                                3 Months<br><small>₹<%= amt3mo %>/mo</small>
                            </div>
                            <div class="emi-option" onclick="selectEMI('6', this)">
                                6 Months<br><small>₹<%= amt6mo %>/mo</small>
                            </div>
                            <div class="emi-option" onclick="selectEMI('12', this)">
                                12 Months<br><small>₹<%= amt12mo %>/mo</small>
                            </div>
                        </div>
                    </div>

                </div>
                <!-- END BNPL SECTION -->

                <button class="pay-btn" id="payBtn" onclick="payNow()">Pay ₹<%= amount %></button>
                <div id="msg"></div>
            </div>

        </div>
    </div>
</div>

<script>
const AMOUNT         = "<%= amount %>";   // injected from session by JSP
let selectedMethod   = "upi";
let selectedProvider = "";
let selectedEMI      = "";

console.log("[CHECKOUT] Page Loaded - Default Method: UPI");

// =============================================
// API ENDPOINTS — FILL THESE WHEN READY
// =============================================
const API_ENDPOINTS = {
    upi:        "checkout",
    card:       "checkout",
    netbanking: "checkout",
    wallet:     "checkout",
    bnpl:       "checkout"
};

// =============================================
// AUTH TOKEN (if needed)
// =============================================
const AUTH_TOKEN = ""; // TODO: Add Bearer token or API key if required

// =============================================
// METHOD SWITCHER
// =============================================
function selectMethod(method, element) {
    console.log("[CHECKOUT] Payment Method Selected:", method);
    selectedMethod = method;

    document.querySelectorAll(".method").forEach(el => el.classList.remove("active"));
    element.classList.add("active");

    document.getElementById("upiSection").style.display        = "none";
    document.getElementById("cardSection").style.display       = "none";
    document.getElementById("netbankingSection").style.display = "none";
    document.getElementById("walletSection").style.display     = "none";
    document.getElementById("bnplSection").style.display       = "none";

    if      (method === "upi")        document.getElementById("upiSection").style.display        = "block";
    else if (method === "card")       document.getElementById("cardSection").style.display       = "block";
    else if (method === "netbanking") document.getElementById("netbankingSection").style.display = "block";
    else if (method === "wallet")     document.getElementById("walletSection").style.display     = "block";
    else if (method === "bnpl")       document.getElementById("bnplSection").style.display       = "block";
}

// =============================================
// BNPL — PROVIDER SELECTOR
// =============================================
function selectBNPLProvider(provider, element) {
    console.log("[BNPL] Provider Selected:", provider);
    selectedProvider = provider;
    document.querySelectorAll(".bnpl-provider-btn").forEach(el => el.classList.remove("selected"));
    element.classList.add("selected");
}

// =============================================
// BNPL — EMI PLAN SELECTOR
// =============================================
function selectEMI(months, element) {
    console.log("[BNPL] EMI Plan Selected:", months, "month(s)");
    selectedEMI = months;
    document.querySelectorAll(".emi-option").forEach(el => el.classList.remove("selected"));
    element.classList.add("selected");
}

// =============================================
// COUNTDOWN TIMER
// =============================================
let timeLeft = 300;
function startTimer() {
    console.log("[CHECKOUT] Timer Started: 5 Minutes");
    const countdown = document.getElementById("countdown");

    const timer = setInterval(function () {
        let minutes = Math.floor(timeLeft / 60);
        let seconds = timeLeft % 60;
        seconds = seconds < 10 ? "0" + seconds : seconds;
        countdown.innerText = minutes + ":" + seconds;

        if (timeLeft <= 0) {
            clearInterval(timer);
            console.error("[CHECKOUT] Session Expired");
            document.getElementById("msg").innerHTML =
                "<span style='color:red;'>Session Expired! Please refresh the page.</span>";
            document.getElementById("payBtn").disabled = true;
        }
        timeLeft--;
    }, 1000);
}
startTimer();

// =============================================
// BUILD PAYLOAD PER METHOD
// =============================================
function buildPayload() {
    if (selectedMethod === "upi") {
        return {
            method: "upi",
            amount: AMOUNT
        };
    } else if (selectedMethod === "card") {
        return {
            method:     "card",
            amount:     AMOUNT,
            cardNumber: $("#cardNumber").val(),
            cardName:   $("#cardName").val(),
            cardExpiry: $("#cardExpiry").val(),
            cvv:        $("#cvv").val()
        };
    } else if (selectedMethod === "netbanking") {
        return {
            method: "netbanking",
            amount: AMOUNT,
            bank:   $("#bank").val()
        };
    } else if (selectedMethod === "wallet") {
        return {
            method:       "wallet",
            amount:       AMOUNT,
            walletType:   $("#wallet").val(),
            mobileNumber: $("#walletMobile").val()
        };
    } else if (selectedMethod === "bnpl") {
        return {
            method:       "bnpl",
            amount:       AMOUNT,
            provider:     selectedProvider,
            mobileNumber: $("#bnplMobile").val(),
            pan:          $("#bnplPan").val().toUpperCase(),
            emiMonths:    selectedEMI
        };
    }
}

// =============================================
// FRONT-END VALIDATION
// =============================================
function validate() {
    if (selectedMethod === "card") {
        if (!$("#cardNumber").val() || !$("#cardName").val() ||
            !$("#cvv").val()        || !$("#cardExpiry").val()) {
            $("#msg").html("<span style='color:orange;'>⚠️ Please fill all card details.</span>");
            return false;
        }
    }
    if (selectedMethod === "netbanking" && !$("#bank").val()) {
        $("#msg").html("<span style='color:orange;'>⚠️ Please select a bank.</span>");
        return false;
    }
    if (selectedMethod === "wallet") {
        if (!$("#wallet").val() || !$("#walletMobile").val()) {
            $("#msg").html("<span style='color:orange;'>⚠️ Please select wallet and enter mobile number.</span>");
            return false;
        }
    }
    if (selectedMethod === "bnpl") {
        if (!selectedProvider) {
            $("#msg").html("<span style='color:orange;'>⚠️ Please select a BNPL provider.</span>");
            return false;
        }
        if (!$("#bnplMobile").val() || $("#bnplMobile").val().length !== 10) {
            $("#msg").html("<span style='color:orange;'>⚠️ Please enter a valid 10-digit mobile number.</span>");
            return false;
        }
        if (!selectedEMI) {
            $("#msg").html("<span style='color:orange;'>⚠️ Please select an EMI plan.</span>");
            return false;
        }
    }
    return true;
}

// =============================================
// PAY NOW — AJAX CALL
// =============================================
function payNow() {
    console.log("[PAYMENT] Initiating | Method:", selectedMethod, "| Amount: ₹" + AMOUNT);

    if (!API_ENDPOINTS[selectedMethod]) {
        console.warn("[PAYMENT] API endpoint not set for:", selectedMethod);
        $("#msg").html("<span style='color:orange;'>⚠️ API not configured yet for: <b>" + selectedMethod.toUpperCase() + "</b></span>");
        return;
    }

    if (!validate()) return;

    $("#payBtn").prop("disabled", true).text("Processing...");
    $("#msg").html("<span style='color:#555;'>⏳ Please wait...</span>");

    let headers = { "Content-Type": "application/json" };
    if (AUTH_TOKEN) headers["Authorization"] = "Bearer " + AUTH_TOKEN;

    $.ajax({
        url:         API_ENDPOINTS[selectedMethod],
        type:        "POST",
        contentType: "application/json",
        headers:     headers,
        data:        JSON.stringify(buildPayload()),

        success: function(response) {
            console.log("[PAYMENT] Success Response:", response);
            $("#payBtn").prop("disabled", false).text("Pay ₹" + AMOUNT);
            $("#msg").html("<span style='color:green;'>✅ " + (response.message || "Payment Successful!") + "</span>");
        },

        error: function(xhr, status, error) {
            console.error("[PAYMENT] Failed | Status:", xhr.status, "| Error:", error);
            $("#payBtn").prop("disabled", false).text("Pay ₹" + AMOUNT);
            let errMsg = "Payment Failed. Please try again.";
            if (xhr.responseJSON && xhr.responseJSON.message) errMsg = xhr.responseJSON.message;
            $("#msg").html("<span style='color:red;'>❌ " + errMsg + "</span>");
        }
    });
}
</script>

</body>
</html>