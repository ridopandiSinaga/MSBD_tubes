<div class="header bg-dark">
	<img class="img-fluid w-100 mt-2 ml-1" src="../images/logo.png" >
</div>
<div class="sidebar">
	<button><h3>Dashboard</h3></button>
	<button id="sidebar_button" style='cursor:pointer' onclick="window.location.href='../logs/logs.php?username=<?php echo $_GET['username']; ?>'">List</button>
	<button id="sidebar_button" style='cursor:pointer' type="button" data-toggle="popover" title="Logs Management" data-content="Here you can view activity in the store." data-placement="bottom">Help?</button>
	<div class="fixed-bottom">
		<button class="btn m-2 p-2" id="sidebar_button" onclick="window.location.href='../main.php?username=<?php echo $_GET['username'];?>'"><img src="../images/reply.svg"></button>
	</div>
</div>