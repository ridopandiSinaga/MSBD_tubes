<?php include('../server/connection.php');
	if(isset($_GET['id'])){ 
		$id	= $_GET['id'];
        $user = $_SESSION['username'];
		$query = "DELETE FROM products WHERE product_no = $id"; 
    	$result = mysqli_query($db, $query);

		$user1 = "CALL procedure_get_session_username('$user')";
		$result1 = mysqli_query($db,$user1);
			while($db->next_result()) continue;//mengantisipasi tidak sync out
		if (!$result1) {
        die ('ERROR: Proses ' .  $user1 . ': '. mysqli_error($db));
		}

    	if($result==true){
			//ambil username lalu berikan ke @user_name1 utk menjadi inputan dalam parameter proc di trigger
			
			// $logs = "CALL procedure_log_del_product($user,'Product deleted') ";
    		// $insert = mysqli_query($db,$logs);
    		header("location: products.php?deleted");
    	}else{
            echo $id;
			header("location: products.php?undelete");
    	}
    }	