<?php
echo "<h1>Hello from Docker with Apache2!</h1>";
echo "<p>PHP Version: " . phpversion() . "</p>";

// Test MySQL connection
$host = '127.0.0.1'; // Must be 127.0.0.1 instead of localhost
$user = 'root';
$pass = 'root';
$db = 'mysql';

try {
    $conn = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "<p style='color:green;'>✅ MySQL connection successful!</p>";
} catch(PDOException $e) {
    echo "<p style='color:red;'>❌ MySQL connection failed: " . $e->getMessage() . "</p>";
}

phpinfo();
?>
