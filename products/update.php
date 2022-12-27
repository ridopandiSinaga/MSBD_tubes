<?php
//untuk proses update products
	include("../server/connection.php");
	$msg 		= '';
  	if(isset($_POST['update'])){
		$target   	= "../images/".basename($_FILES['images']['name']);
	  	$image    	= $_FILES['images']['name'];
	  	$id       	= $_POST['id'];
	  	$pro_name 	= mysqli_real_escape_string($db, $_POST['product_name']);	
	  	$price 	 	= mysqli_real_escape_string($db, $_POST['price']);
	  	$qty 		= mysqli_real_escape_string($db, $_POST['qty']);
	  	$unit   	= mysqli_real_escape_string($db, $_POST['unit']);
	  	$min_stocks = mysqli_real_escape_string($db, $_POST['min_stocks']);
	  	$remarks 	= mysqli_real_escape_string($db, $_POST['remarks']);
		$location 	= mysqli_real_escape_string($db, $_POST['location']);
	  	$username	= $_SESSION['username'];
		
		//ambil username dan product 
		$query 	="CALL procedure_get_name_namep('$username','$pro_name')";
		$result = mysqli_query($db,$query);
			while($db->next_result()) continue;//mengantisipasi tidak sync out
		if (!$result) {
        die ('ERROR: Proses ' .  $query . ': '. mysqli_error($db));
		}		

		if (!empty($image)){
		  	$sql  = "UPDATE products SET product_name='$pro_name',sell_price=$price,quantity=$qty,unit='$unit',min_stocks=$min_stocks,remarks='$remarks', location='$location', images='$image' WHERE product_no = '$id'";
		  	mysqli_query($db, $sql);
		  	if(move_uploaded_file($_FILES['images']['tmp_name'], $target)){
		  		// $sql = "CALL procedure_get_name_namep('$username','$pro_name')";
				// mysqli_query($db,$sql);
				// $query1 = " DROP TABLE IF EXISTS `variables`";
				// $query1 = "CREATE TEMPORARY TABLE `variables`(
				// 		username VARCHAR( 20 ) ,
				// 		productname VARCHAR( 30 )
				// 		)Engine = MyISAM";
			    // $query1 = "INSERT INTO `variables`(username,productname) VALUES ( @name1, @pname1)";
				// mysqli_query($db,$query1);

				// $sql 	= "INSERT INTO logs (username,purpose) VALUES('SELECT','Product $pro_name updated')";
 				// $insert = mysqli_query($db,$sql);

 				header('location: ../products/products.php?updated');
 			}
		}else{
		  	$sql1  = "UPDATE products SET product_name='$pro_name',sell_price=$price,quantity=$qty,unit='$unit',min_stocks=$min_stocks,remarks='$remarks', location='$location' WHERE product_no = '$id'";
		  	$result = mysqli_query($db, $sql1);
			var_dump($result);
 			if($result == true){
 				// $query 	= "INSERT INTO logs (username,purpose) VALUES('$username','Product $pro_name updated')";
 				// mysqli_query($db,$query);
				// $query 	="CALL procedure_get_name_namep('$username','$pro_name')";
				// mysqli_query($db,$query);
				
				// $query1 = " DROP TABLE IF EXISTS `variables`";
				// $query1 = "CREATE  TABLE `variables`(
				// 		username VARCHAR( 20 ) ,
				// 		productname VARCHAR( 30 )
				// 		)Engine = MyISAM";
			    // $query1 = "INSERT INTO `variables`(username,productname) VALUES ( @name1, @pname1)";
				// mysqli_query($db,$query1);

 				echo $sql;
 	 			header('location: ../products/products.php?updated');
 			}
 		}
 	}