<?php include("../server/connection.php");
	  include('../user/update.php');

	$query  = "SELECT username FROM users WHERE position = 'admin'";
	$res 	= mysqli_query($db, $query);
	$row1 	= mysqli_fetch_assoc($res);
  	if (isset($_GET['id'])){
		$id   =   $_GET['id'];
		$sql  =   "SELECT * FROM users WHERE id = '$id'";
		$result   = mysqli_query($db, $sql);
		$row  =   mysqli_fetch_array($result);

?>
<!DOCTYPE html>
<html>
<head>
	<?php include('../templates/head1.php');?>
</head>
<body>
	<div class="contain h-100">
		<div class="header bg-dark">
			<img class="img-fluid w-100 mt-2 ml-1" src="../images/logo.png" >
		</div>
<div class="sidebar">
	<button><h3>Dashboard</h3></button>
	<button id="sidebar_button" onclick="window.location.href='../user/user.php?username=<?php echo $row1['username'];?>'">List</button>
	<button id="sidebar_button" onclick="window.location.href='../user/user.php?username=<?php echo $row1['username'];?>'">Add</button>
	<button id="sidebar_button" type="button" data-toggle="popover" title="User Management" data-content="Here you will create, update, delete and view user profiles." data-placement="bottom">Help?</button>
	<div class="fixed-bottom">
		<button class="btn m-2 p-2" id="sidebar_button" onclick="window.location.href='../main.php?username=<?php echo $row1['username'];?>'"><img src="../images/reply.svg"></button>
	</div>
</div>
		<div class="main">
			<div class="side">
				<h1 class="ml-4">User Management</h1>
				<hr>
			</div>
			<div class="first_side ml-5 mt-5 mr-3">
				<div style="border:1px dashed black; width: 250px;height: 250px;">
					<?php echo "<img class='img-fluid p-2 h-100 w-100' src='../images/".$row['image']."'>";?>
				</div>
			<form method="post" enctype="multipart/form-data">
				<input type="hidden" name="size" value="1000000">
			</div>
			<div class="second_side">
					<p class="bg-danger w-50"><?php echo $msg;?></p>
					<table class="mt-5">
						<tbody>
							<tr>
								<td  valign="baseline">Username:</td>
								<td class="pl-5 pb-2"><input type="text" name="username" value="<?php echo $row['username'];?>" required></td>
							</tr>
							<tr>
								<td  valign="baseline">Firstname:</td>
								<td class="pl-5 pb-2"><input type="text" name="firstname" value="<?php echo $row['firstname'];?>" required></td>
							</tr>
							<tr>
								<td  valign="baseline">Lastname:</td>
								<td class="pl-5 pb-2"><input type="text" name="lastname" value="<?php echo $row['lastname'];?>" required></td>
							</tr>
							<tr>
								<td  valign="baseline">Contact number:</td>
								<td class="pl-5 pb-2"><input type="number" name="number" value="<?php echo $row['contact_number'];?>" required></td>
							</tr>
							<tr>
								<td  valign="baseline">Position:</td>
								<td class="pl-5 pb-2">
									<select name="position">
										<option value="<?php echo $row['position'];?>"><?php echo $row['position'];?></option>
										<option value="Admin">Admin</option>
										<option value="Employee">Employee</option>
									</select>
								</td>
							</tr>
							<tr>
								<td>Change Photo:</td>
								<td><input class="form-control-sm pl-5" type="file" name="image"></td>
							</tr>
						</tbody>
					</table>
					<div class="text-left mt-3">
						<input type="hidden" name="id" value="<?php echo $row['id'];?>">
						<button type="submit" name="update" class="btn btn-secondary">Update</button>
						<button type="button" class="btn btn-danger" onclick="window.location.href='../user/user.php?username=<?php echo $row1['username'];?>'" >Cancel</button>
					<?php } ?>
					</div>
				</form>
			</dir>
		</div>
	</div>
	<script src="../bootstrap4/jquery/jquery.min.js"></script>
	<script src="../bootstrap4/js/bootstrap.bundle.min.js"></script>
	<script>
		$(function () {
  			$('[data-toggle="popover"]').popover()
	})
	</script>
</body>
</html>