<?php
	include("../server/connection.php");
	$msg 		= '';
  	if(isset($_POST['update'])){
		$target   	= "../images/".basename($_FILES['image']['name']);
	  	$image    	= $_FILES['image']['name'];
	  	$id       	= mysqli_real_escape_string($db, $_POST['id']);
	  	$user 		= mysqli_real_escape_string($db, $_POST['username']);	
	  	$firstname  = mysqli_real_escape_string($db, $_POST['firstname']);
	  	$lastname   = mysqli_real_escape_string($db, $_POST['lastname']);
	  	$number   	= mysqli_real_escape_string($db, $_POST['number']);
	  	$position  	= mysqli_real_escape_string($db, $_POST['position']);
	  	$user 		= $_SESSION['username'];

		//insert username dan firstname ke table tempt_variables
		$logs	="CALL procedure_get_name_fname('$user','$firstname')";
		$insert = mysqli_query($db,$logs);
		var_dump('$logs');
		while($db->next_result()) continue;//mengantisipasi tidak sync out
		if (!$insert ) {
        die ('ERROR: Proses ' .  $logs . ': '. mysqli_error($db));
		}

		if (!empty($image)){
		  	$sql  = "UPDATE users SET firstname='$firstname',lastname='$lastname',position='$position',contact_number='$number',image='$image' WHERE id = '$id'";
		  	$check= mysqli_query($db, $sql);
		  	if(move_uploaded_file($_FILES['image']['tmp_name'], $target) && $check == true){
				//proc dh, trigger blm
		  		// $logs	= "INSERT INTO logs (username,purpose) VALUES('$username','User $firstname updated)";
 				// $insert = mysqli_query($db,$logs);
 				echo $sql;
 				header('location: ../user/user.php?updated');
 			}else{
 				header('location: ../user/user.php?error');
 			}
		}else{
		  	$sql  = "UPDATE users SET firstname='$firstname',lastname='$lastname',position='$position',contact_number='$number' WHERE id = '$id'";
		  	mysqli_query($db, $sql);
		  	// $logs 	= "INSERT INTO logs (username,purpose) VALUES('$username','User $firstname updated')";
 			// $insert = mysqli_query($db,$logs);
 			echo $sql;
 			header('location: ../user/user.php?updated');			
 		}
	}