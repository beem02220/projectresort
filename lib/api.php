<?php
//mysqli_report(MYSQLI_REPORT_ALL); // Traps all mysqli error 
//error_reporting(E_ALL);
//ini_set('display_errors', 1);

$server= "mariadb";
$username ="oneable";
$password="oneable@4321";
$dbname ="keyboxes";
$conn = new mysqli($server, $username, $password, $dbname);
header('content-type: application/json');
//$data=json_decode(file_get_contents('php://input'),true);

$fn=$_GET['action'];
//


//data read part are here
function getrooms($conn){
  $sql = "SELECT * FROM rooms";
  $result = $conn->query($sql);
  if (mysqli_num_rows($result) > 0) {
       $rows=array();
       while ($r = mysqli_fetch_assoc($result)) {
          $rows["result"][] = $r;
       }
       echo json_encode($rows);
  }  else{
      echo '{"result": "no data found"}';
    }
}

//ลงทะเบียนผู้เข้าพัก
function register($conn){
   try {
      if($_POST) {
         $name=$_POST["name"];
         $idcard=$_POST["idcard"];
         $mobile=$_POST["mobile"];
         $room_id=$_POST["room_id"];
         $sql= "INSERT INTO register(name,idcard,mobile,created_at) VALUES ('$name' , '$idcard','$mobile', NOW())";
         if ($conn->query($sql)) {
            
            $rnd = mt_rand(100000, 999999);
            $sql= "UPDATE rooms SET secret='$rnd', register_id='$conn->insert_id', updated_at=NOW() where id='$room_id'   ";
            mysqli_query($conn, $sql);
            
            //get rooms
            $query = "SELECT * FROM rooms where id='$room_id'";
            $result = mysqli_query($conn, $query);
            $row   = mysqli_fetch_assoc($result);
            echo json_encode( $row);
         } 
      }
      //print_r($_POST);
      

   }catch (Exception $e){
      throw new Exception($e, 1);
      //http_response_code(500);
      //echo json_encode(array("success"=>false,"message"=>$e->getMessage()));
   } 
 
}

//คืนกุญแจ
function signout($conn){
   
   $room_id=$_POST["room_id"];
   $register_id=$_POST["register_id"];
   $sql= "UPDATE rooms SET secret=null,register_id=null,  updated_at=NOW() where id='$room_id' and register_id= ".$register_id;
   //echo  $sql;
   $conn->query($sql);
   echo json_encode(array("success"=> true));
}

function verify($conn){
   $secret=$_POST["secret"];
   $sql = "SELECT * FROM rooms where secret='$secret'";
   $result = $conn->query($sql);
   if (mysqli_num_rows($result) > 0) {
        $rows=array();
        while ($r = mysqli_fetch_assoc($result)) {
           $rows["room"] = $r["room_no"];
        }
        echo json_encode($rows);
   }  else{
       echo '{"room": ""}';
     }
 }
?>
