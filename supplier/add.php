<?php include('../server/connection.php');
	$msg 	= '';
	$error  = array();
	if(isset($_POST['add'])){
		$company 	= mysqli_real_escape_string($db, $_POST['com_name']);
		$firstname 	= mysqli_real_escape_string($db, $_POST['firstname']);
		$lastname 	= mysqli_real_escape_string($db, $_POST['lastname']);
		$address 	= mysqli_real_escape_string($db, $_POST['address']);
		$number 	= mysqli_real_escape_string($db, $_POST['number']);
	  	$image    	= $_FILES['image']['name'];
		$target   	= "../images/".basename($_FILES['image']['name']);
		$user 		= $_SESSION['username'];

		//insert user,company name ke tempt_variable
		$query 	= "CALL procedure_get_name_namec('$user','$company')";
 		$insert = mysqli_query($db,$query);
		while($db->next_result()) continue;//mengantisipasi tidak sync out
		if (!$insert ) {
        die ('ERROR: Proses ' .  $query . ': '. mysqli_error($db));
		}

		$sql  = "INSERT INTO supplier (company_name,firstname,lastname,address,contact_number,image) VALUES ('$company','$firstname','$lastname','$address','$number','$image')";
	  	$result = mysqli_query($db, $sql);
	  	if(move_uploaded_file($_FILES['image']['tmp_name'], $target) && $result == true){
			$msg = "Image successfully uploaded!";
			// sudah dibuat proc, trigger belum dibuat 
			// $query 	= "INSERT INTO logs (username,purpose) VALUES('$user','Supplier $company added')";
 			// $insert = mysqli_query($db,$query);
			header('location: ../supplier/supplier.php?added');
	  	}else{
			$msg = "There was a problem uploading the image!";
		}
	}
