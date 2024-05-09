<?php
require_once "config.php";

$email = $email_err = "";

// Processing form data when form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    // Validate email
    if (isset($_POST["email"])) {
        $email = trim($_POST["email"]);
    } else {
        // Handle the case where email field is not submitted
        $email = ""; // or any default value you prefer
    }

    // Check if email exists in the database
    if (empty($email_err)) {
        $sql = "SELECT id FROM signup WHERE email = ?";
        if ($stmt = $mysqli->prepare($sql)) {
            $stmt->bind_param("s", $param_email);
            $param_email = $email;
            if ($stmt->execute()) {
                $stmt->store_result();
                if ($stmt->num_rows == 1) {
                    // Email exists, send verification email
                    $verification_link = "http://localhost/DBMS%20Project/forgotPassword.php";
                    $verification_message = "Please click the following link to go to change password page: <a href='$verification_link'>Verify Email</a>";
                    
                    // You can use a library like PHPMailer to send the email
                    // Example using PHPMailer:
                    
                    require_once "vendor/autoload.php"; // Include PHPMailer autoload file

                    $mail = new PHPMailer\PHPMailer\PHPMailer();
                    $mail->isSMTP();
                    $mail->Host = 'smtp.gmail.com';
                    $mail->SMTPAuth = true;
                    $mail->Username = 'ishaj9432@gmail.com';
                    $mail->Password = 'buyk zfmf rtsa ahah';
                    $mail->Port = 587;
                    $mail->setFrom('ishaj9432@gmail.com', 'Isha Jaiswal');
                    $mail->addAddress($email);
                    $mail->isHTML(true);
                    $mail->Subject = 'Email Verification';
                    $mail->Body = $verification_message;
                    
                    if ($mail->send()) {
                        session_start();
                        $_SESSION["reset_email"] = $email;
                        echo "Email is sent";
                        //header("location: forgotpassword.php");
                        exit();
                    } else {
                        echo "Oops! Something went wrong. Please try again later.";
                    }
                    
                    
                    // For this example, I'm just echoing the verification message
                    //echo $verification_message;
                    //echo "Email is sent";
                    //exit();
                } else {
                    // Email doesn't exist
                    $email_err = "Email not registered.";
                }
            } else {
                echo "Oops! Something went wrong. Please try again later.";
            }
            $stmt->close();
        }
    }

    // Close connection
    $mysqli->close();
}
?>



<html>
<head>
	<title>Faculty Application | IIT Patna</title>
	<link rel="stylesheet" type="text/css" href="https://ofa.iiti.ac.in/facrec_che_2023_july_02/images/favicon.ico" type="image/x-icon">
	<link rel="icon" href="https://ofa.iiti.ac.in/facrec_che_2023_july_02/images/favicon.ico" type="image/x-icon">
	<link rel="stylesheet" type="text/css" href="https://ofa.iiti.ac.in/facrec_che_2023_july_02/css/bootstrap.css">
	<link rel="stylesheet" type="text/css" href="https://ofa.iiti.ac.in/facrec_che_2023_july_02/css/bootstrap-datepicker.css">
	<script type="text/javascript" src="https://ofa.iiti.ac.in/facrec_che_2023_july_02/js/jquery.js"></script>
	<script type="text/javascript" src="https://ofa.iiti.ac.in/facrec_che_2023_july_02/js/bootstrap.js"></script>
	<script type="text/javascript" src="https://ofa.iiti.ac.in/facrec_che_2023_july_02/js/bootstrap-datepicker.js"></script>

	<link href="https://fonts.googleapis.com/css?family=Sintony" rel="stylesheet"> 
	<link href="https://fonts.googleapis.com/css?family=Fjalla+One" rel="stylesheet"> 
	<link href="https://fonts.googleapis.com/css?family=Oswald" rel="stylesheet"> 
	<link href="https://fonts.googleapis.com/css?family=Hind&display=swap" rel="stylesheet"> 
	<link href="https://fonts.googleapis.com/css?family=Noto+Sans&display=swap" rel="stylesheet"> 
	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link href="https://fonts.googleapis.com/css2?family=Noto+Serif&display=swap" rel="stylesheet">


	
</head>
<style type="text/css">
	body { background-color: lightgray; padding-top:0px!important;}

</style>
<body>
<div class="container-fluid" style="background-color: #f7ffff; margin-bottom: 10px;">
	<div class="container">
        <div class="row" style="margin-bottom:10px; ">
        	<div class="col-md-8 col-md-offset-2">

        		<!--  <img src="https://ofa.iiti.ac.in/facrec_che_2023_july_02/images/IITIndorelogo.png" alt="logo1" class="img-responsive" style="padding-top: 5px; height: 120px; float: left;"> -->

        		<h3 style="text-align:center;color:#414002!important;font-weight: bold;font-size: 2.3em; margin-top: 3px; font-family: 'Noto Sans', sans-serif;">भारतीय प्रौद्योगिकी संस्थान पटना</h3>
    			<h3 style="text-align:center;color: #414002!important;font-weight: bold;font-family: 'Oswald', sans-serif!important;font-size: 2.2em; margin-top: 0px;">Indian Institute of Technology Patna</h3>
    			

        	</div>
        	

    	   
        </div>
		    <!-- <h3 style="text-align:center; color: #414002; font-weight: bold;  font-family: 'Fjalla One', sans-serif!important; font-size: 2em;">Application for Academic Appointment</h3> -->
    </div>
   </div> 
			<h3 style="color: #e10425; margin-bottom: 20px; font-weight: bold; text-align: center;font-family: 'Noto Serif', serif;" class="blink_me">Application for Faculty Position</h3>

<link rel="stylesheet" type="text/css" href="https://ofa.iiti.ac.in/facrec_che_2023_july_02/css/pages.css">

<div class="container" style="border-radius:10px; height:500px; margin-top:50px;">
        <div class="col-md-10 col-md-offset-1">
  
    <div class="row" style="border-width: 2px; border-style: solid; border-radius: 10px; box-shadow: 0px 1px 30px 1px #284d7a; background-color:#F7FFFF;">

        
         <div class="col-md-6"style=" height:403px; border-radius: 10px 0px 0px 10px;"><img src="Indian_Institute_of_Technology,_Patna.svg.png" style="margin-left:22%; margin-top: 10%; width: 300px;">
        </div>

        <div class="col-md-6" style="border-radius: 0px 10px 10px 0px; height: 403px;">
         <br />
          <div class="col-md-10 col-md-offset-1">
          <h3 style="text-align: center; color:red;"><strong>FORGOT PASSWORD</strong></h3><br />
           
          <form action="" method="post" class="form" role="form">
            <input type="hidden" name="ci_csrf_token" value="" />

            <div class="inner-addon left-addon">
               <i class="glyphicon glyphicon-envelope"></i>
               <input type="text" name="email" placeholder="Please Enter Your Registered Email" require type="email" />
           </div>
           
            <br />

            <div class="row">
               <div class="col-md-3">
                 <button type="submit" name="submit" value="Submit" class="cancelbtn">Submit</button>
               </div>
               <div class="col-md-9">
                 <a href="login.php"><button type="button" class="loginbtn pull-right">Login Area</button></a>
               </div>
             </div>


            
            </form>

                      
        </div>

      
      </div>
    </div>
</div>
    <br />
    
</div>


<div id="footer"></div>
</body>
</html>

<script type="text/javascript">
	
	function blinker() {
	    $('.blink_me').fadeOut(500);
	    $('.blink_me').fadeIn(500);
	}

	setInterval(blinker, 1000);
</script>