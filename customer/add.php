<?php 
	include('../server/connection.php');
	$alert  = array();
	if(isset($_POST['add_customer'])){
		$fname 		= mysqli_real_escape_string($db, $_POST['fname']);
		$lname 		= mysqli_real_escape_string($db, $_POST['lname']);
		$address	= mysqli_real_escape_string($db, $_POST['address']);
		$number		= mysqli_real_escape_string($db, $_POST['number']);
	  	$image   	= $_FILES['image']['name'];
		$target   	= "../images/".basename($_FILES['image']['name']);
		$user 		= $_SESSION['username'];
		//mengambil data user & fname 
		$query 	="CALL 	procedure_get_name_fname('$user','$fname')";
 		$insert = mysqli_query($db,$query);
		while($db->next_result()) continue;//mengantisipasi tidak sync out
		if (!$insert ) {
        die ('ERROR: Proses ' .  $query . ': '. mysqli_error($db));
		}

		$sql  = "INSERT INTO customer (firstname,lastname,address,contact_number,image) VALUES ('$fname','$lname','$address','$number','$image')";
	  	$result = mysqli_query($db, $sql);
		var_dump($result);
 		if(move_uploaded_file($_FILES['image']['tmp_name'], $target) && $result == true){
			//proc sdh, trigger blm
 			// $query 	= "INSERT INTO logs (username,purpose) VALUES('$user','Customer $fname Added')";
			// $query 	="CALL procedure_log_add_costumer('$user','$fname')";
 			// $insert 	= mysqli_query($db,$query);
			header('location: ../customer/customer.php?added');
	  	}else{
			array_push($alert,"There was a problem uploading the image!");
	  	}
	}
