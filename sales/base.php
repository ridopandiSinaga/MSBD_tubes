<div class="header bg-dark">
	<img class="img-fluid w-100 mt-2 ml-1" src="../images/logo.png" >
</div>
<div class="sidebar">
	<button><h3>Dashboard</h3></button>
	<button id="sidebar_button" type="button" data-toggle="popover" title="Cash Management" data-content="Here you can view cash flow of the store." data-placement="bottom">Help?</button>
	<div class="fixed-bottom">
		<button class="btn m-2 p-2" id="sidebar_button" onclick="window.location.href='../main.php?username=<?php echo $_GET['username'];?>'"><img src="../images/reply.svg"></button>
	</div>
</div>