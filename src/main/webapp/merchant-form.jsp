<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
<title>Merchant Transaction Form</title>
<style>
body {
	font-family: Arial;
	background-color: #f4f6f8;
}

.container {
	width: 600px;
	margin: 40px auto;
	background: white;
	padding: 25px;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

h2 {
	text-align: center;
	color: #2c3e50;
}

label {
	font-weight: bold;
	display: block;
	margin-top: 12px;
}

.required {
	color: red;
	margin-left: 3px;
}

input, select {
	width: 100%;
	padding: 8px;
	margin-top: 5px;
	border-radius: 4px;
	border: 1px solid #ccc;
}

.btn {
	margin-top: 20px;
	background-color: #007bff;
	color: white;
	border: none;
	padding: 12px;
	width: 100%;
	font-size: 16px;
	border-radius: 5px;
	cursor: pointer;
}

.btn:hover {
	background-color: #0056b3;
}
</style>
</head>
<body>

	<div class="container">
		<h2>Merchant Transaction Form</h2>

		<form action="PaymentProcess" method="post">

			<!-- Merchant Form -->
			<label>Merchant Name <span class="required">*</span></label> <input
				type="text" name="merchantName" required> <label>Merchant
				ID <span class="required">*</span>
			</label> <input type="text" name="merchantId" required>

			<!-- Merchant Transaction ID -->
			<label>Merchant Transaction ID <span class="required">*</span></label>
			<input type="text" name="merchantTxnId" required>

			<!-- Amount -->
			<label>Amount (₹) <span class="required">*</span></label>
			<input type="number" name="amount" placeholder="e.g. 1500.00"
			       step="0.01" min="1" required
			       oninput="this.value = this.value.replace(/[^0-9.]/g, '')">

			<!-- Txn Date & Time -->
			<label>Transaction Date & Time <span class="required">*</span></label>
			<input type="datetime-local" name="txnDateTime" required>

			<!-- Customer Email -->
			<label>Customer Email <span class="required">*</span></label> <input
				type="email" name="customerEmail" required>

			<!-- Customer Mobile No  -->
			<label>Customer Mobile Number <span class="required">*</span>
			</label> <input type="text" name="customerMobile" maxlength="10"
				oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>

			<!-- UDF Fields -->
			<label>UDF 1</label> <input type="text" name="udf1"> <label>UDF
				2</label> <input type="text" name="udf2"> <label>UDF 3</label> <input
				type="text" name="udf3"> <label>UDF 4</label> <input
				type="text" name="udf4"> <label>UDF 5</label> <input
				type="text" name="udf5"> <label>UDF 6</label> <input
				type="text" name="udf6">

			<!-- Merchant Return URL -->
			<label>Merchant Return URL</label> <input type="url" name="returnUrl">

			<!-- Account Type -->
			<label>Account Type</label> <select name="accountType">
				<option value="SAVINGS">Savings</option>
				<option value="CURRENT">Current</option>
			</select>

			<!-- Transaction Type -->
			<label>Transaction Type</label> <select name="txType">
				<option value="SALE">Sale</option>
				<!--------<option value="REFUND">Refund</option> ----------->
				<!----------<option value="AUTH">Authorization</option>-------->
			</select>

			<!-- Reseller ID -->
			<label>Reseller ID</label> <input type="text" name="resellerId">

			<!-- Reseller Mobile No -->
			<label>Reseller Mobile Number</label> <input type="text"
				name="resellerMobile">

			<!-- Merchant Push URL -->
			<label>Merchant Push URL</label> <input type="url" name="pushUrl">

			<!-- Submit Button -->
			<button type="submit" class="btn">Submit Transaction</button>

		</form>
	</div>

</body>
</html>