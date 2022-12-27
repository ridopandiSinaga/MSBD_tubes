<?php include('../server/connection.php');
	if(isset($_GET['id'])){ 
		$id	= $_GET['id'];
        $user = $_SESSION['username'];
		$query = "DELETE FROM users WHERE id = '$id'"; 
    	$result = mysqli_query($db, $query);
		
		//insert user ke tempt_variables table
		$logs 	= "CALL procedure_get_session_username('$user')";
 		$insert = mysqli_query($db,$logs);
		while($db->next_result()) continue;//mengantisipasi tidak sync out
		if (!$insert ) {
        die ('ERROR: Proses ' .  $logs . ': '. mysqli_error($db));
		}

    	if($result == true){
			//proc dh, triiger belum
    		// $insert 	= "INSERT INTO logs (username,purpose) VALUES('$user','User Deleted')";
 			// mysqli_query($db,$insert);
			header("location: user.php?deleted");
    	}else{
    		header("location: user.php?undelete");
    	}
    }	