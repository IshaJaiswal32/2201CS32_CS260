<?php
$host = 'localhost:3308'; // Your MySQL host
$db_username = 'root'; // Your MySQL username
$db_password = ''; // Your MySQL password
$database = 'facultylogin'; // Your MySQL database name

// Create connection
$mysqli = new mysqli($host, $db_username, $db_password, $database);

// Check connection
if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}
?>
