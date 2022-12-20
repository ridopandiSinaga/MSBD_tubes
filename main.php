<?php 
	include('server/connection.php');
	if(!isset($_SESSION['username'])){
		header('location: index.php');
	}
	$added = isset($_GET['added']);
	$error = isset($_GET['error']);
	$undelete = isset($_GET['undelete']);
	$updated = '';
	$deleted = '';
	$failure = isset($_GET['failure']);
	$query 	= "SELECT * FROM `customer`";
	$show	= mysqli_query($db,$query);

	include 'set.php';
    
  	$sql = "CALL find_recent_sale_added('7')";//panggil prosedur untuk recend sale, dibatasi 7 row
  	$higest_selling_product = "CALL find_higest_saleing_product('7')";//panggil prosedur untuk product keluar terbanyak, rows diabatsi 7
    $product_in = "SELECT count_product_in()";//fungsi menghitung banyak product  masuk
    $product_out = "SELECT count_product_out()";//fungsi menghitung banyak product keluar
    $stock = "SELECT count_stock()";//fungsi menghitung banyak product/stock

    $result = mysqli_query($db, $sql);
    while($db->next_result()) continue;//supaya tidak out sync
    $result1 = mysqli_query($db, $higest_selling_product);
    while($db->next_result()) continue;//supaya tidak out sync
    $result_product_in = mysqli_query($db, $product_in);
    while($db->next_result()) continue;//supaya tidak out sync
    $result_product_out = mysqli_query($db, $product_out);
    while($db->next_result()) continue;//supaya tidak out sync
    $result_stock = mysqli_query($db, $stock);
    // while($db->next_result()) continue;//supaya tidak out sync
  
  	if (!$result) {
    die ('ERROR: Data gagal dimasukkan pada ' .  $sql . ': '. mysqli_error($db));
    }
    if (!$result1) {
      die ('ERROR: Data gagal dimasukkan pada ' .  $sql1 . ': '. mysqli_error($db));
    }
    if (!$result1) {
      die ('ERROR: Data gagal dimasukkan pada ' .  $sql1 . ': '. mysqli_error($db));
    }
?>


<!DOCTYPE html>
<html lang="fr" dir="ltr">
  <head>
    <meta charset="UTF-8" />
    <title>report</title>
    <link rel="stylesheet" href="style.css" />
    <!-- Boxicons CDN Link -->
    <link
      href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css"
      rel="stylesheet"
    />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  </head>
  <body>
    <!-- side bar -->
    <div class="sidebar">
      <div class="logo-details">
        <i class="bx bxl-c-plus-plus"></i>
        <span class="logo_name">TOKOKU</span>
      </div>
      <ul class="nav-links">
        <li>
          <a href="" class="active">
            <i class="bx bx-grid-alt"></i>
            <span class="links_name">Dashboard</span>
          </a>
        </li>
        <li>
          <a href="products/products.php">
            <i class="bx bx-box"></i>
            <span class="links_name">Product</span>
          </a>
        </li>
        <li>
            <a href="supplier/supplier.php">
              <i class="bx bx-user"></i>
              <span class="links_name">Supplier</span>
            </a>
        </li>
        <li>
          <a href="sales/sales.php">
            <i class="bx bx-coin-stack"></i>
            <span class="links_name">Sales</span>
          </a>
        </li>
        <li>
          <a href="delivery/delivery.php">
            <i class="bx bx-message" ></i>
            <span class="links_name">Order</span>
          </a>
        </li>
          <li>
            <a href="user/user.php">
              <i class="bx bx-user"></i>
              <span class="links_name">User</span>
            </a>
        </li>
        <li>
            <a href="customer/customer.php">
              <i class="bx bx-user"></i>
              <span class="links_name">Costumer</span>
            </a>
        </li>
        <li>
          <a href="logs/logs.php">
            <i class="bx bx-book-alt"></i>
            <span class="links_name">Logs</span>
          </a>
        </li>
        <li>
          <a href="cashflow/cashflow.php">
            <i class="bx bx-pie-chart-alt-2"></i>
            <span class="links_name">Analyses</span>
          </a>
        </li>
        
        <li>
          <a href="#">
            <i class="bx bx-cog"></i>
            <span class="links_name">Configuration</span>
          </a>
        </li>
        <li class="log_out">
            <i class="bx bx-log-out"></i>
            <button id="buttons" name="logout" type="button" onclick="out();" class="logout btn btn-danger border mr-2"><i class="fas fa-sign-out-alt"></i> Logout</button> 
          </a>
        </li>
      </ul>
    </div>
    <!-- end sidebar -->
    <!-- header -->
    <section class="home-section">
      <nav>
        <div class="sidebar-button">
          <i class="bx bx-menu sidebarBtn"></i>
          <span class="dashboard">Dashboard</span>
        </div>
        <div class="search-box">
          <input type="text" placeholder="Recherche..." />
          <i class="bx bx-search"></i>
        </div>
        <div class="profile-details">
          <!--<img src="images/profile.jpg" alt="">-->
          <span class="admin_name">Komche</span>
          <i class="bx bx-chevron-down"></i>
        </div>
      </nav>
      <!-- end header -->

      <div class="home-content">
        <div class="overview-boxes">
          <!--  -->
          <div class="box">
            <div class="right-side">
              <div class="box-topic">Out</div>
              <?php while($row1 = mysqli_fetch_array($result_product_out)){ ?>
              <div class="number"><?php   echo $row1['0']; ?></div>
              <?php } ?>
              <div class="indicator">
                <i class="bx bx-up-arrow-alt"></i>
                <span class="text">Product Out</span>
              </div>
            </div>
            <i class="bx bx-cart-alt cart"></i>
          </div>
          <!--  -->
          <!--  -->
          <div class="box">
            <div class="right-side">
              <div class="box-topic">In</div>
              <?php while($row1 = mysqli_fetch_array($result_product_in)){?>
              <div class="number"> <?php   echo $row1['0']; ?></div>
              <?php } ?>
              <div class="indicator">
                <i class="bx bx-up-arrow-alt"></i>
                <span class="text">Product In</span>
              </div>
            </div>
            <i class="bx bxs-cart-add cart two"></i>
          </div>
          <!--  -->
          <!--  -->
          <div class="box">
            <div class="right-side">
              <div class="box-topic">Stock</div>
               <?php while($row1 = mysqli_fetch_array($result_stock)){?>
              <div class="number"><?php   echo $row1['0']; ?></div>
              <?php } ?>
              <div class="indicator">
                <i class="bx bx-up-arrow-alt"></i>
                <span class="text">Product Exist</span>
              </div>
            </div>
            <i class="bx bx-cart cart three"></i>
          </div>
          <!--  -->
          <!--  -->
          <div class="box">
            <div class="right-side">
              <div class="box-topic">Revenu</div>
              <div class="number">11,086</div>
              <div class="indicator">
                <i class="bx bx-down-arrow-alt down"></i>
                <span class="text">Aujourd'hui</span>
              </div>
            </div>
            <i class="bx bxs-cart-download cart four"></i>
          </div>
          <!--  -->
        </div>
        <div class="sales-boxes">
          <div class="recent-sales box">
            <div class="title">Recent Product Added</div>
            <div class="sales-details">
              <ul class="details">
            
                  <table class="table table-striped table-bordered" id="" style="margin-top: 50px;">
                  <thead>
                    <tr>
                      <th scope="col" class="column-text">Date</th>
                      <th scope="col" class="column-text">Product Name</th>
                      <th scope="col" class="column-text">Amount</th>
                      <th scope="col" class="column-text">Price/Item</th>
                
                    </tr>
                  </thead>
                    <tbody class="table-hover">
                        <?php 
                          while($row = mysqli_fetch_assoc($result)){
                        ?>
                        <tr class="table-active">
                          <td><?php echo $row['date'];?></td>
                          <td><?php echo $row['product_name'];?></td>
                          <td><?php echo $row['quantity'];?></td>
                        </tr>
                        <?php } ?>
                    </tbody>
                </table>
            
              </ul>
            </div>
            
          </div>
          <div class="top-sales box">
            <div class="title">Best Selling Product</div>
              <ul class="top-sales-details">
           
                  <table class="table table table-striped table-bordered table-condensed" id="" style="margin-top: 50px;">
                    <thead>
                      <tr>
                        <th scope="col" class="column-text ">Name</th>
                        <th scope="col" class="column-text ">Sold</th>
                        <th scope="col" class="column-text ">Stock</th>
                      </tr>
                    </thead>
                      <tbody class="table-hover">
                      <?php 
                            while($row1 = mysqli_fetch_assoc($result1)){
                            ?>
                          <tr class="table-active">
                            <td><?php echo $row1['product_name'];?></td>
                            <td><?php echo $row1['totalSold'];?></td>
                            <td><?php echo $row1['Stock'];?></td>
                           
                          </tr>
                          <?php } ?>
                      </tbody>
                </table>
              
              </ul>
            </div>
          </div>
        </div>
      </section>
  <script src="../bootstrap4/jquery/jquery.min.js"></script>
	<script src="../bootstrap4/js/jquery.dataTables.js"></script>
	<script src="../bootstrap4/js/dataTables.bootstrap4.min.js"></script>
	<script src="../bootstrap4/js/bootstrap.bundle.min.js"></script>
  <script type="text/javascript" src="script.js"></script>
	<script src="bootstrap4/js/time.js"></script>
	
</html>
