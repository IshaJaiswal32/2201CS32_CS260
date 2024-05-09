<?php
session_start();

require_once "config.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = trim($_POST["email"]);
    $password = trim($_POST["password"]);

    $sql = "SELECT id, email, password FROM signup WHERE email = ?";
    //echo "$sql ";
    if ($stmt = $mysqli->prepare($sql)) {
        $stmt->bind_param("s", $param_email);
        $param_email = $email;
        if ($stmt->execute()) {
            $stmt->store_result();
            if ($stmt->num_rows == 1) {
                $stmt->bind_result($id, $email, $stored_password);
                if ($stmt->fetch()) {
                    if ($password === $stored_password) { // Compare passwords directly
                        // Password is correct, start a new session
                        session_start();
                        // Store data in session variables
                        $_SESSION["loggedin"] = true;
                        $_SESSION["id"] = $id;
                        $_SESSION["email"] = $email;
                        // Redirect user to welcome page
                        echo "Correct login";
                        header("location: Page1.php");
                        exit;
                    } else {
                        // Password is incorrect
                        $password_err = "The password you entered was not valid.";
                        echo "$password_err ";
                    }
                }
            } else {
                // No user found with that email
                $email_err = "No account found with that email.";
                echo "$email_err";
            }
        } else {
            echo "Oops! Something went wrong. Please try again later.";
        }
        $stmt->close();
    }
    // Close database connection
    $mysqli->close();
}
?>

<html>
<head>
	<title>Faculty Login</title>
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



<a href='https://ofa.iiti.ac.in/facrec_che_2023_july_02/layout'></a>

<div class="container" style="border-radius:10px; height:300px; margin-top:20px;">
        <div class="col-md-10 col-md-offset-1">
  
    <div class="row" style="border-width: 2px; border-style: solid; border-radius: 10px; box-shadow: 0px 1px 30px 1px #284d7a; background-color:#F7FFFF;">

        
         <div class="col-md-6"style=" height:403px; border-radius: 10px 0px 0px 10px;"><img src="Indian_Institute_of_Technology,_Patna.svg.png" style="margin-left:22%; margin-top: 10%; width: 300px;">

            <p style="text-align: center;">
                                        </p>
        </div>

        <div class="col-md-6" style="border-radius: 0px 10px 10px 0px; height: 403px;">
         <br />
          <div class="col-md-10 col-md-offset-1">
           <h3 style="text-align: center;"><strong><u>LOGIN HERE</u></strong></h3><br />
           
           <form role="form" method="post">
            <input type="hidden" name="ci_csrf_token" value="" />
              
                 <div class="inner-addon left-addon">
                     <i class="glyphicon glyphicon-envelope"></i>
                     <input type="text" name="email" placeholder="Your email" autofocus="" required/>
                 </div>
                 <br />

                 <div class="inner-addon left-addon">
                     <i class="glyphicon glyphicon-lock"></i>
                     <input type="password" placeholder="Enter your password" name="password" required>
                 </div>
                 <br />
                   
                 <div class="row">
                    <div class="col-md-3">
                      <a href="Page1.php"><button type="submit" name="submit" value="Submit">Login</button>

                    </div>
                    <div class="col-md-9">
                      <a href="resetPassword.php"><button type="button" class="cancelbtn pull-right">Reset Password</button></a>
                    </div>
                  </div>
                
             </form>
             <br />
           <p style="text-align: center; color: green; font-size: 1.3em;"><strong>NOT REGISTERED? </strong> <a href='signup.php' class="btn-sm btn-primary"> SIGN UP</a>
            
           </p>
          
        </div>

       
      </div>
    </div>
</div>
   
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