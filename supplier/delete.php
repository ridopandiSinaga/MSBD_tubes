<?php include('../server/connection.php');
	if(isset($_GET['id'])){ 
		$id	= $_GET['id'];
		$user = $_SESSION['username'];
		$query = "DELETE FROM supplier WHERE supplier_id='$id'"; 
    	$delete = mysqli_query($db, $query);

		//insert username into temp_varibles tables
		$logs 	= "CALL procedure_get_session_username('$user')";
 		$insert = mysqli_query($db,$logs);
		while($db->next_result()) continue;//mengantisipasi tidak sync out
		if (!$insert ) {
        die ('ERROR: Proses ' .  $logs . ': '. mysqli_error($db));
		}
		
    	if($delete == true){
			//sudah dibuat proc, belum triiger
    		// $logs 	= "INSERT INTO logs (username,purpose) VALUES('$user','Supplier Deleted')";
 			// $insert = mysqli_query($db,$logs);
			header("location: supplier.php?deleted");
    	}else{
    		header("location: supplier.php?undelete");
    	}
    }	