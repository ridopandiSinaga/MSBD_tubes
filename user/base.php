<div class="header bg-dark">
	<img class="img-fluid w-100 mt-2 ml-1" src="../images/logo.png" >
	<div class="w-50">
  		<form class="form-inline form-group-sm mt-4">
  			<input class="form-control w-75 mr-1" type="search" placeholder="Search" aria-label="Search">
   			<button class="btn btn-secondary my-2 my-sm-0 border" type="submit">Search</button>
  		</form>
	</div>
</div>
<div class="sidebar">
	<button><h3>Dashboard</h3></button>
	<button id="sidebar_button" onclick="window.location.href='../user/user.php?username='">List</button>
	<button id="sidebar_button" onclick="window.location.href='../user/add_user.php?username='">Add</button>
	<button id="sidebar_button" type="button" data-toggle="popover" title="User Management" data-content="Here you will create, update, delete and view user profiles." data-placement="bottom">Help?</button>
	<div class="fixed-bottom">
		<button class="btn m-2 p-2" id="sidebar_button" onclick="window.location.href='../main.php?username='"><img src="../images/reply.svg"></button>
	</div>
</div>