<?php
session_start(); // Start the session

require_once "config.php";

// Define variables and initialize with empty values
$new_password = $confirm_password = "";
$new_password_err = $confirm_password_err = "";

// Processing form data when form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    // Validate new password
    if (empty(trim($_POST["password"]))) {
        $new_password_err = "Please enter the new password.";
    } elseif (strlen(trim($_POST["password"])) < 6) {
        $new_password_err = "Password must have at least 6 characters.";
    } else {
        $new_password = trim($_POST["password"]);
    }

    // Validate confirm password
    if (empty(trim($_POST["confirm_password"]))) {
        $confirm_password_err = "Please confirm the password.";
    } else {
        $confirm_password = trim($_POST["confirm_password"]);
        if (empty($new_password_err) && ($new_password != $confirm_password)) {
            $confirm_password_err = "Password did not match.";
        }
    }

    // Check input errors before updating the database
    if (empty($new_password_err) && empty($confirm_password_err)) {
        // Prepare an update statement
        $sql = "UPDATE signup SET password = ? WHERE email = ?";

        if ($stmt = $mysqli->prepare($sql)) {
            // Set parameters
            $param_password = $new_password;
            $param_email = $_SESSION["reset_email"]; // Use reset_email instead of email

            // Bind variables to the prepared statement as parameters
            $stmt->bind_param("ss", $param_password, $param_email);

            // Attempt to execute the prepared statement
            if ($stmt->execute()) {
                // Password updated successfully. Destroy the session, and redirect to login page
                session_destroy();
                echo "Password is updated successfully";
                //header("location : login.php");
                exit();
            } else {
                echo "Oops! Something went wrong. Please try again later.";
            }

            // Close statement
            $stmt->close();
        } else {
            echo "Error: Unable to prepare statement.";
        }
    }

    // Close connection
    $mysqli->close();
}
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password | IIT Patna</title>
    <link rel="stylesheet" type="text/css" href="https://ofa.iiti.ac.in/facrec_che_2023_july_02/css/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="https://ofa.iiti.ac.in/facrec_che_2023_july_02/css/bootstrap-datepicker.css">
    <link href="https://fonts.googleapis.com/css?family=Sintony" rel="stylesheet"> 
    <link href="https://fonts.googleapis.com/css?family=Fjalla+One" rel="stylesheet"> 
    <link href="https://fonts.googleapis.com/css?family=Oswald" rel="stylesheet"> 
    <link href="https://fonts.googleapis.com/css?family=Hind&display=swap" rel="stylesheet"> 
    <link href="https://fonts.googleapis.com/css?family=Noto+Sans&display=swap" rel="stylesheet"> 
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif&display=swap" rel="stylesheet">
    <style>
        body { 
            background-color: lightgray; 
            padding-top: 0px !important;
        }
        .container-fluid {
            background-color: #f7ffff; 
            margin-bottom: 10px;
        }
        .container {
            margin-bottom: 10px;
        }
        h3 {
            text-align: center;
            color: #414002!important;
            font-weight: bold;
            font-size: 2.3em;
            margin-top: 3px;
            font-family: 'Noto Sans', sans-serif;
        }
        h4 {
            text-align: center;
            color: #e10425;
            font-weight: bold;
            font-size: 2.2em;
            margin-top: 0px;
            font-family: 'Oswald', sans-serif!important;
        }
        .form-control {
            margin-bottom: 10px;
        }
        .btn-submit {
            margin-top: 20px;
            margin-bottom: 20px;
            width: 100%;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="container">
            <div class="row">
                <div class="col-md-8 col-md-offset-2">
                    <h3>भारतीय प्रौद्योगिकी संस्थान पटना</h3>
                    <h3>Indian Institute of Technology Patna</h3>
                </div>
            </div>
        </div>
    </div>
    <h4>Reset Password</h4>
    <div class="container" style="border-radius:10px; margin-top:50px;">
        <div class="col-md-6 col-md-offset-3">
            <div class="row" style="border-width: 2px; border-style: solid; border-radius: 10px; box-shadow: 0px 1px 30px 1px #284d7a; background-color:#F7FFFF;">
                <div class="col-md-12">
                    <br />
                    <form action="" method="post" class="form" role="form">
                        <input type="hidden" name="ci_csrf_token" value="">
                        <div class="inner-addon left-addon">
                            <i class="glyphicon glyphicon-lock"></i>
                            <input type="password" name="password" class="form-control" placeholder="New Password" required>
                        </div>
                        <br />
                        <div class="inner-addon left-addon">
                            <i class="glyphicon glyphicon-lock"></i>
                            <input type="password" name="confirm_password" class="form-control" placeholder="Confirm Password" required>
                        </div>
                        <br />
                        <button type="submit" class="btn btn-primary btn-submit">Reset Password</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div id="footer"></div>
</body>
</html>
