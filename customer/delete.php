<?php include('../server/connection.php');
	if(isset($_GET['id'])){ 
		$id	= $_GET['id'];
        $use = $_SESSION['username'];
		

		$logs 	= "CALL procedure_get_session_username('$use')";
		$insert = mysqli_query($db,$logs);
		while($db->next_result()) continue;//mengantisipasi tidak sync out
		if (!$insert ) {
        die ('ERROR: Proses ' .  $logs . ': '. mysqli_error($db));
		}

		$query = "DELETE FROM customer WHERE customer_id = '$id'"; 
		if(mysqli_query($db, $query)==true){
			//sdh proc, trigg belum
    		// $logs 	= "INSERT INTO logs (username,purpose) VALUES('$user','Customer deleted')";
 			// $insert = mysqli_query($db,$logs);
			header("location: customer.php?deleted");
    	}else{
    		header("location: customer.php?undelete");
    	}
    }	