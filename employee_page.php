<?php 
	include('server/connection.php');
	if(!isset($_SESSION['username'])){
		header('location: index.php');
	}
	$added = isset($_GET['added']);
	$undelete = isset($_GET['undelete']);
	$updated = '';
	$deleted = '';
	$query 	= "SELECT * FROM `customer`";
	$show	= mysqli_query($db,$query);
	if(isset($_SESSION['username'])){
		$user = $_SESSION['username'];
		$sql = "SELECT position FROM users WHERE username='$user'";
		$result	= mysqli_query($db, $sql);
		if (mysqli_num_rows($result) > 0){
			while($row = mysqli_fetch_assoc($result)){
?>
<!DOCTYPE html>
<html>
<head>
	<title>POS.PHP</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="icon" type="image/png" sizes="180x180" href="images/icon.png">
	<link rel="stylesheet" type="text/css" href="bootstrap4/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="bootstrap4/css/style2.css">
	<script src="bootstrap4/jquery/sweetalert.min.js"></script>
</head>
<body>
	<div class="h-100 bg-dark" id="container">
		<div id="header">
			<?php include('alert.php'); ?>
			<div>
				<img class="img-fluid m-2 w-100" src="images/logo1.jpg"/>
			</div>
			<div class="text-white mt-0 ml-5">
				<table class="table-responsive-sm">
					<tbody>
						<tr>
							<td valign="baseline"><small>User Logged on:<small></td>
							<td valign="baseline"><small><p class="pt-3 ml-5"><?php echo $row['position'];}}}?></p><small></td>
						</tr>
						<tr>
							<td valign="baseline"><small class="pb-1">Date:<small></td>
							<td valign="baseline"><small><p class="p-0 ml-5"><span id='time'></p><small></td>
						</tr>
						<tr>
							<td valign="baseline"><input type="hidden" id="uname" value="<?php echo $user; ?>" /><small>Customer Name:<small></td>
							<td valign="baseline"><small><p class="p-0 ml-5">
								<select id='custom_id' style='cursor:pointer'>

								<?php 
									if (mysqli_num_rows($show)>0){
										while ($row = mysqli_fetch_array($show)) {	?>
								<option value="<?php echo $row['customer_id']; ?>"><?php echo $row['firstname'];?></option>
								<?php }}?>
								</p></small></select>
								<button class="btn-sm btn-info border" data-toggle="modal" data-target=".bd-example-modal-md" style="padding-top: 1px; padding-bottom: 2px;"><span class="badge badge-info">+New</span></button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="header_price border p-0">
				<h5>Grand Total</h5>
				<p class="pb-0 mr-2" style="float: right; font-size: 40px;" id="totalValue">₱ 0.00</p>
			</div>
		</div>
		<div id="content" class="mr-2">
			<div id="price_column" class="m-2 table-responsive-sm">
				<form method="POST" action="">
				<table class="table-striped w-100 font-weight-bold" style="cursor: pointer;" id="table2">
					<thead>
						<tr class='text-center'>
							<th>Barcode</th>
							<th>Description</th>
							<th>Price</th>
							<th>Unit</th>
							<th>Qty</th>
							<th>Sub.Total</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody id="tableData">
					</tbody>
				</table>
				</form>
			</div>
			<div id="table_buttons">
				<button id="buttons" type="button" name='enter' class="Enter btn btn-secondary border ml-2">Finish</button>
				<div>
					<ul class="text-white d-flex justify-content-center mt-3">
						<p>Total:&nbsp&nbsp<li id="totalValue1">₱ 0.00</li></p>
					</ul>
				</div>
			</div>
		</div>
		<div id="sidebar">
			<div>
   				<input class="form-control w-100" type="text" placeholder="Product Search" aria-label="Search" id="search" name="search" onkeyup="loadproducts();">
   			</div>
			<div class="mt-0" id="product_area" class="table-responsive-sm" >
				<table class="w-100 table-striped font-weight-bold" style="cursor: pointer;" id="table1">
					<thead>
						<tr claclass='text-center'><b>
							<td>Barcode</td>
							<td>Product Name</td>
							<td>Price</td>
							<td>Unit</td>
							<td>Stocks</td>
						</tr></b>
						<tbody id="products">
							
						</tbody>
					</thead>
				</table>
			</div>
			<div class="w-100 mt-2" id="enter_area">
				<button id="buttons" type="button" class="cancel btn btn-secondary border">Cancel</button>
			</div>
		</div>
		<div id="footer" class="w-100" align="center" style="">
			<button id="buttons" onclick="window.location.href='user/user.php'" class="btn btn-secondary border mr-2 ml-2">User</button>
			<button id="buttons" onclick="window.location.href='products/products.php'" class="btn btn-secondary border mr-2">Product</button>
			<button id="buttons" onclick="window.location.href='supplier/supplier.php'" class="btn btn-secondary border mr-2">Supplier</button>
			<input id="buttons" name="logout" type="button" value="Logout" onclick="out();" class="logout btn btn-danger border mr-2"/> 
		</div>
	</div>
	<?php include('add.php');?>
	<?php include('templates/js_popper.php');?>
	<script type="text/javascript" src="script.js"></script>
	<script src="bootstrap4/js/time.js"></script>
</body>
</html> 