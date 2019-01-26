<?php include('../user/add.php');?>
<!DOCTYPE html>
<html>
<head>
	<?php include('../templates/head1.php');?>
</head>
<body>
	<div class="contain h-100">
		<?php include('../user/base.php');?>
		<div class="main">
			<div class="side">
				<h1 class="ml-4">User Management</h1>
				<hr>
			</div>
			<div class="first_side ml-5 mt-5 mr-3">
				<div style="border:1px dashed black; width: 250px;height: 250px;">
					<img class="img-fluid p-2 h-100 w-100" src="../images/user.png">
				</div>
			<form method="post" enctype="multipart/form-data">
				<input type="hidden" name="size" class="form-control-sm" value="1000000">
				<input class="form-control-sm" type="file" name="image" required>
				<p class="bg-danger mt-3"><?php echo $msg;?></p>
			</div>
			<dir class="second_side">
					<table class="table-responsive mt-5">
						<p><?php include('../error.php');?></p>
						<tbody>
							<tr>
								<td  valign="baseline">Username:</td>
								<td class="pl-5 pb-2"><input type="text" name="username" required></td>
							</tr>
							<tr>
								<td  valign="baseline">Firstname:</td>
								<td class="pl-5 pb-2"><input type="text" name="firstname" required></td>
							</tr>
							<tr>
								<td  valign="baseline">Lastname:</td>
								<td class="pl-5 pb-2"><input type="text" name="lastname" required></td>
							</tr>
							<tr>
								<td  valign="baseline">Contact number:</td>
								<td class="pl-5 pb-2"><input type="number" name="number" required></td>
							</tr>
							<tr>
								<td  valign="baseline">Password:</td>
								<td class="pl-5 pb-2"><input type="password" name="password" required></td>
							</tr>
							<tr>
								<td  valign="baseline">Confirm Password:</td>
								<td class="pl-5 pb-2"><input type="password" name="password1" required></td>
							</tr>
							<tr>
								<td  valign="baseline">Position:</td>
								<td class="pl-5 pb-2"><input class="form-check-input ml-2" type="radio" name="position" value="admin"><label class="ml-4">Admin</label>
									<input class="form-check-input ml-2" type="radio" name="position" value="employee" checked><label class="ml-4">Employee</label></td>
							</tr>
						</tbody>
					</table>
					<div class="text-left mt-4">
						<button type="submit" name="add" class="btn btn-secondary">Submit</button>
						<button class="btn btn-danger" onclick="window.location.href='../user/user.php?username=<?php echo $_GET['username'	];?>'" >Cancel</button>
					</div>
				</form>
			</dir>
		</div>
	</div>
	<?php include('../templates/js_popper.php');?>
	<script>
		$(function () {
  			$('[data-toggle="popover"]').popover()
	})
	</script>
</body>
</html>