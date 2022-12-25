<?php include('../server/connection.php');
	if(isset($_GET['id'])){ 
		$id	= $_GET['id'];
        $user = $_SESSION['username'];
		$query = "DELETE FROM products WHERE product_no = $id"; 
    	$result = mysqli_query($db, $query);
    	if($result==true){
			//proc sudah. trigger belum
			$logs = "CALL procedure_log_del_product($user,'Product deleted') ";
    		$insert = mysqli_query($db,$logs);
    		header("location: products.php?deleted");
    	}else{
            echo $id;
			header("location: products.php?undelete");
    	}
    }	