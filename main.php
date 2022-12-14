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
  $akhir = new DateTime();

	include 'set.php';
    
  	$sql = "CALL find_recent_delivery_added('3')";//panggil prosedur untuk recend sale, dibatasi 7 row
    $sql1 = "CALL find_recent_sale_added('3')";//panggil prosedur untuk recend sale, dibatasi 7 row
  	$higest_selling_product = "CALL find_higest_saleing_product('5')";//panggil prosedur untuk product keluar terbanyak, rows diabatsi 7
    $product_in = "SELECT count_product_in()";//fungsi menghitung banyak product  masuk
    $product_out = "SELECT count_product_out()";//fungsi menghitung banyak product keluar
    $stock = "SELECT count_stock()";//fungsi menghitung banyak product/stock

    $result = mysqli_query($db, $sql);
      while($db->next_result()) continue;//supaya tidak out s +++++++++++++++++++ync
    $result1 = mysqli_query($db, $higest_selling_product);
      while($db->next_result()) continue;//supaya tidak out sync
    $result_product_in = mysqli_query($db, $product_in);
      while($db->next_result()) continue;//supaya tidak out sync
    $result_product_out = mysqli_query($db, $product_out);
      while($db->next_result()) continue;//supaya tidak out sync
    $result_stock = mysqli_query($db, $stock);
     while($db->next_result()) continue;//supaya tidak out sync
    $resultsql1 = mysqli_query($db, $sql1);
  
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
    <title>TOKOKU</title>
    <link rel="icon" type="image/png" sizes="180x180" href="images/p-icon.png"/>
    <link rel="stylesheet" href="style.css" />
    <!-- Boxicons CDN Link -->
    <link
      href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css"
      rel="stylesheet"
    />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" 
    integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  </head>
  <body>
    <!-- side bar -->
    <div class="sidebar">
      <div class="logo-details">
        <i class="bx bxl-store-alt"></i>
        <span class="logo_name">TOKOKU</span>
      </div>
      <ul class="nav-links">
        <!-- <li id="sidebar_button">
          <a href="" class="links_name">
            <i class="bx bx-grid-alt"></i>
            <span class="links_name">Dashboard</span>
          </a>
        </li> -->
        <li class="row gx-5" id="sidebar_button">
          <a href="products/products.php">
            <i class="bx bx-box" style="color: black;"></i>
            <span class=" links_name">Product</span>
          </a>
        </li>
        <li class="row gx-5" id="sidebar_button">
            <a href="supplier/supplier.php">
              <i class="bx bx-user" style="color: black;"></i>
              <span class="links_name">Supplier</span>
            </a>
        </li>
        <li class="row gx-5" id="sidebar_button">
          <a href="sales/sales.php">
            <i class="bx bx-coin-stack" style="color: black;"></i>
            <span class="links_name">Sales</span>
          </a>
        </li>
        <li class="row gx-5" id="sidebar_button">
          <a href="delivery/delivery.php">
            <i class="bx bx-message" style="color: black;"></i>
            <span class="links_name">Order</span>
          </a>
        </li>
          <li class="row gx-5" id="sidebar_button">
            <a href="user/user.php">
              <i class="bx bx-user" style="color: black;"></i>
              <span class="links_name">User</span>
            </a>
        </li>
        <li class="row gx-5" id="sidebar_button">
            <a href="customer/customer.php">
              <i class="bx bx-user" style="color: black;"></i>
              <span class="links_name">Costumer</span>
            </a>
        </li>
        <li class="row gx-5" id="sidebar_button">
          <a href="logs/logs.php">
            <i class="bx bx-book-alt" style="color: black;"></i>
            <span class="links_name">Logs</span>
          </a>
        </li>
        <li class="row gx-5" id="sidebar_button">
          <a href="cashflow/cashflow.php">
            <i class="bx bx-pie-chart-alt-2" style="color: black;"></i>
            <span class="links_name">Cash</span>
          </a>
        </li>
        
        <li class="row gx-5" id="sidebar_button">
          <a href="#">
            <i class="bx bx-cog" style="color: black;"></i>
            <span class="links_name">Configuration</span>
          </a>
        </li>
        <li class="log_out">
            <button id="buttons" name="logout" type="button" onclick="out();" class="logout btn btn-danger mx-auto"><i class="fas fa-sign-out-alt"></i> Logout</button> 
          </a>
        </li>
      </ul>
    </div>
    <!-- end sidebar -->
    <!-- header -->
    <section class="home-section">
      <nav>
        <div class="sidebar-button">
          <span class="dashboard">Dashboard</span>
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
          <!-- <div class="box">
            <div class="right-side">
              <div class="box-topic">Revenu</div>
              <div class="number">11,086</div>
              <div class="indicator">
                <i class="bx bx-down-arrow-alt down"></i>
                <span class="text">Aujourd'hui</span>
              </div>
            </div>
            <i class="bx bxs-cart-download cart four"></i>
          </div> -->
          <!--  -->
        </div>
        <div class="sales-boxes">
          
        <div class="recent-sales box">
            <div class="title">Recent Product Activity</div>
            <div class="sales-details">
              <ul class="details">
            
                  <table class="table table-hover" id="" style="margin-top: 5px;">
                  <thead>
                    <tr>
                      <th scope="col" class="column-text">Delivery</th>
                      
                      <!-- <th scope="col" class="column-text">sales</th>       -->
                    </tr>
                  </thead>
                    <tbody class="table table-hover">
                        <?php while($row = mysqli_fetch_assoc($result)){?>
                        <tr>
                          <td><div><?php echo $row['product_in']; ?></div><div class="my-0"><span class="text"><small>
                            <?php 
                            $awal  = new DateTime($row['date']);
                            $akhir = new DateTime(); 
                            $diff  = date_diff($akhir, $awal);
                            echo  $diff->format(" %d days %h  hour %i minute ago"); ?></small></span></div></td>              
                        </tr>
                        <?php } ?>
                          
                    </tbody>
                    <thead>
                      <tr>
                      <th scope="col" class="column-text m">Sale</th>
                      <!-- <th scope="col" class="column-text">sales</th>       -->
                    </tr>
                    </thead>
                    <tbody class="table table-hover">
                        <?php while($row1 = mysqli_fetch_assoc($resultsql1)){?>
                        <tr>
                          <td><div><?php echo $row1['product_out']; ?></div><div class="my-0"><span class="text"><small>
                            <?php 
                            $awal  = new DateTime($row1['date']);
                            $akhir = new DateTime(); 
                            $diff  = date_diff($akhir, $awal);
                            echo  $diff->format(" %d days %h  hour %i minute ago"); ?></small></span></div></td>              
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
           
                  <table class="table table-hover" id="" style="margin-top: 50px;">
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
                          <tr>
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
      <?php include('templates/js_popper.php');?>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" 
      integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
  <script src="../bootstrap4/jquery/jquery.min.js"></script>
	<script src="../bootstrap4/js/jquery.dataTables.js"></script>
	<script src="../bootstrap4/js/dataTables.bootstrap4.min.js"></script>
	<script src="../bootstrap4/js/bootstrap.bundle.min.js"></script>
  <script type="text/javascript" src="script.js"></script>
	<script src="bootstrap4/js/time.js"></script>
	
</html>
