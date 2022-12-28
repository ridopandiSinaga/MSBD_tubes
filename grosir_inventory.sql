-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 28, 2022 at 08:11 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `grosir_inventory`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `find_higest_saleing_product` (IN `lim` INT(25))   SELECT p.product_name, CONCAT(sp.qty, ' ', p.unit) AS totalSold, CONCAT(p.quantity,' ',p.unit) AS Stock
FROM sales_product sp
LEFT JOIN products p ON p.product_no = sp.product_id
GROUP BY p.product_no
ORDER BY sp.qty DESC LIMIT lim$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `find_recent_sale_added` (IN `lim` INT(25))   SELECT sp.reciept_no,CONCAT(sp.qty, ' ' , p.unit) AS quantity,s.total,s.date,p.product_name,CONCAT('Rp.',' ',sp.price,'/',p.unit) AS price_
FROM sales_product sp
LEFT JOIN products p ON sp.product_id= p.product_no
LEFT JOIN sales s ON s.reciept_no = sp.reciept_no
ORDER BY s.date DESC LIMIT lim$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `find_sale_by_dates` (IN `date_from` DATE, IN `date_to` DATE)   SELECT s.date, p.product_name, p.sell_price, pd.buy_price, 
COUNT(sp.product_id) AS total_records, SUM(sp.qty) AS total_sales, 
SUM(p.sell_price * p.quantity) AS total_saleing_price, 
SUM(pd.buy_price * p.quantity) AS total_buying_price
FROM sales s 
INNER JOIN sales_product sp ON s.reciept_no = sp.reciept_no
INNER JOIN products p ON p.product_no = sp.product_id 
INNER JOIN product_delivered pd ON pd.product_id = p.product_no
WHERE s.date BETWEEN date_from AND date_to
GROUP BY DATE(s.date), p.product_name
ORDER BY DATE(s.date) DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_customer_sales` (IN `id` INT(25))   BEGIN 
SELECT sales_product.reciept_no,sales_product.price,sales_product.qty FROM customer,sales,sales_product WHERE customer.customer_id = id AND sales.customer_id = id AND sales.reciept_no = sales_product.reciept_no;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_get_name_fname` (IN `uname` VARCHAR(25), IN `fname` VARCHAR(25))   BEGIN
  DROP TABLE IF EXISTS `temporary_var`;
 
 CREATE  TABLE `temporary_var`(
 tempt_username VARCHAR( 20 ) ,
 tempt_productname VARCHAR( 30 ),
 tempt_first_name VARCHAR( 30 ),
 tempt_company VARCHAR( 30 )
 )Engine = MyISAM;

 INSERT INTO `temporary_var`(tempt_username,tempt_first_name) VALUES (uname,fname);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_get_name_namec` (IN `username` VARCHAR(25), IN `companyname` VARCHAR(25))   BEGIN
DROP TABLE IF EXISTS `temporary_var`;
 
 CREATE  TABLE `temporary_var`(
 tempt_username VARCHAR( 20 ) ,
 tempt_productname VARCHAR( 30 ),
 tempt_first_name VARCHAR( 30 ),
 tempt_company VARCHAR( 30 )
 )Engine = MyISAM;

 INSERT INTO `temporary_var`(tempt_username ,tempt_company ) VALUES ( username,companyname);
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_get_name_namep` (IN `name` VARCHAR(25), IN `pname` VARCHAR(25))  DETERMINISTIC BEGIN
 DROP TABLE IF EXISTS `temporary_var`;
 
 CREATE  TABLE `temporary_var`(
 tempt_username VARCHAR( 20 ) ,
 tempt_productname VARCHAR( 30 ),
 tempt_first_name VARCHAR( 30 ),
 tempt_company VARCHAR( 30 )
 )Engine = MyISAM;

 INSERT INTO `temporary_var`(tempt_username ,tempt_productname ) VALUES ( name, pname);
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_get_session_username` (IN `user_name` VARCHAR(25))   BEGIN
  DROP TABLE IF EXISTS `temporary_var`;
 
 CREATE  TABLE `temporary_var`(
 tempt_username VARCHAR( 20 ) ,
 tempt_productname VARCHAR( 30 ),
 tempt_first_name VARCHAR( 30 ),
 tempt_company VARCHAR( 30 )
 )Engine = MyISAM;

 INSERT INTO `temporary_var`(tempt_username) VALUES (user_name);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_log_add_costumer` (IN `user_name` VARCHAR(25), IN `first_name` VARCHAR(25))   BEGIN
INSERT INTO logs(username,purpose) 
VALUES(user_name, CONCAT('Customer ', first_name,' added'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_log_add_delivery` (IN `user_name` VARCHAR(25))   BEGIN
INSERT INTO logs (username,purpose) 
VALUES(user_name,'Delivery added/ product added');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_log_add_suplier` (IN `user_name` VARCHAR(25), IN `company_name` VARCHAR(25))   BEGIN
INSERT INTO logs (username,purpose) 
VALUES(user_name,CONCAT('Supplier', company_name, 'added'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_log_add_user` (IN `user_name` VARCHAR(25), IN `first_name` VARCHAR(25))   BEGIN
INSERT INTO logs (username,purpose) 
VALUES(user_name,CONCAT('User ', first_name,' added'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_log_del_costumer` (IN `user_name` VARCHAR(25))   BEGIN
INSERT INTO logs (username,purpose) 
VALUES(user_name,'Customer deleted');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_log_del_delivery` (IN `user_name` VARCHAR(25))   BEGIN
INSERT INTO logs (username,purpose) 
VALUES(user_name,'Supplier Deleted');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_log_del_product` (IN `user_name` VARCHAR(25))   BEGIN
INSERT INTO logs (username,purpose) 
VALUES(user_name,'Product deleted');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_log_del_supplier` (IN `username` VARCHAR(25))   BEGIN
INSERT INTO logs (username,purpose) 
VALUES(user_name,'Supplier deleted');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_log_del_user` (IN `user_name` VARCHAR(25))   BEGIN
INSERT INTO logs (username,purpose) 
VALUES(user_name,'User Deleted');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_log_upd_costumer` (IN `user_name` VARCHAR(25), IN `first_name` VARCHAR(25))   BEGIN
INSERT INTO logs (username,purpose) 
VALUES(user_name,CONCAT('Customer ',first_name,' updated'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_log_upd_product` (IN `user_name` VARCHAR(25), IN `product_name` VARCHAR(25))   BEGIN
INSERT INTO logs (username,purpose) 
VALUES(user_name,CONCAT('Product ',product_name ,' updated'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_log_upd_supplier` (IN `user_name` VARCHAR(25), IN `company_name` VARCHAR(25))   BEGIN
INSERT INTO logs (username,purpose) 
VALUES(user_name,CONCAT('Supplier ', company_name, ' updated'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_log_upd_user` (IN `user_name` VARCHAR(25), IN `first_name` VARCHAR(25))   BEGIN
INSERT INTO logs(username,purpose) 
VALUES(user_name,CONCAT('User ', first_name ,' updated'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_supplier_detail` (IN `id` INT)   BEGIN
SELECT * FROM supplier,delivery,product_delivered,products 
WHERE supplier.supplier_id = id AND delivery.supplier_id = id AND delivery.transaction_no = product_delivered.transaction_no AND products.product_no = product_delivered.product_id 
GROUP BY products.product_no;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_view_cashflow` (IN `id` VARCHAR(25))   BEGIN
SELECT * FROM cashflow WHERE transaction_id =ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_view_costumer` (IN `id` INT(25))   BEGIN
SELECT * FROM customer WHERE customer_id =id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_view_logs` (IN `id_logs` INT(25))   BEGIN
SELECT * FROM logs WHERE id = id_logs;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_view_product` (IN `view_product_id` CHAR(250))   BEGIN
SELECT * FROM products WHERE product_no = view_product_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_view_supplier` (IN `id` INT(25))   BEGIN
SELECT * FROM supplier WHERE supplier_id=id;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `count_product_in` () RETURNS VARCHAR(11) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
DECLARE p_in VARCHAR(10);
SET p_in = IFNULL((SELECT SUM(pd.total_qty) AS total FROM product_delivered pd),"0") ;
RETURN p_in ;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `count_product_out` () RETURNS VARCHAR(15) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
DECLARE p_out VARCHAR(10);
SET p_out = IFNULL((SELECT SUM(sp.qty) AS total FROM sales_product sp),"0") ;
RETURN p_out ;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `count_stock` () RETURNS VARCHAR(15) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
DECLARE stock VARCHAR(10);
SET stock = IFNULL((SELECT SUM(p.quantity) AS total FROM products p),"0") ;
RETURN stock ;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cashflow`
--

CREATE TABLE `cashflow` (
  `transaction_id` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `amount` decimal(18,2) DEFAULT NULL,
  `username` varchar(30) DEFAULT NULL,
  `transaction_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `cashflow`
--

INSERT INTO `cashflow` (`transaction_id`, `description`, `amount`, `username`, `transaction_date`) VALUES
(1, 'Cash-in', '10000.00', 'admin', '2019-04-08 15:51:58');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL,
  `firstname` varchar(30) DEFAULT NULL,
  `lastname` varchar(30) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `contact_number` varchar(30) DEFAULT NULL,
  `image` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `firstname`, `lastname`, `address`, `contact_number`, `image`) VALUES
(16, 'jersel', 'Bill', 'Philippines', '+63(09)1234-1234', 'user.png'),
(26, 'Andra', 'Wijaksana', 'jl. Hakim Sembiring Medan', '+63(09)1234-1266', 'E_YqCK_VgAANr3-.jpg');

--
-- Triggers `customer`
--
DELIMITER $$
CREATE TRIGGER `tr_log_add_cos` AFTER INSERT ON `customer` FOR EACH ROW BEGIN
DECLARE uname VARCHAR(25);
DECLARE fname VARCHAR(25);
 SELECT temporary_var.tempt_username INTO uname FROM temporary_var;
 SELECT temporary_var.tempt_first_name INTO fname FROM temporary_var;
 CALL procedure_log_add_costumer(uname,fname);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_log_del_cos` AFTER DELETE ON `customer` FOR EACH ROW BEGIN
DECLARE name VARCHAR(25);
 SELECT temporary_var.tempt_username INTO name FROM temporary_var;
 CALL procedure_log_del_costumer(name);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_log_upd_cos` AFTER UPDATE ON `customer` FOR EACH ROW BEGIN
DECLARE uname VARCHAR(25);
DECLARE fname VARCHAR(25);
 SELECT temporary_var.tempt_username INTO uname FROM temporary_var;
 SELECT temporary_var.tempt_first_name INTO fname FROM temporary_var;
 CALL procedure_log_upd_costumer(uname,fname);
 END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `delivery`
--

CREATE TABLE `delivery` (
  `transaction_no` varchar(20) NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `delivery`
--

INSERT INTO `delivery` (`transaction_no`, `supplier_id`, `username`, `date`) VALUES
('5CAAFDA8CD697', 21, 'admin', '2019-04-08 15:52:40'),
('5CAAFDEEDB333', 22, 'admin', '2019-04-08 15:54:19'),
('5CAAFE37D21E8', 21, 'admin', '2019-04-08 15:55:28'),
('5E7F00084C934', 22, 'admin', '2020-03-28 15:43:22'),
('5E81DF2B7B8F7', 22, 'admin', '2020-03-30 20:00:48'),
('63A811F16EA16', 23, 'admin', '2022-12-25 16:09:44'),
('63A8176E7380A', 23, 'admin', '2022-12-25 16:27:28'),
('63A8178B9262F', 23, 'admin', '2022-12-25 16:28:05'),
('63A82C8D753F2', 23, 'admin', '2022-12-25 17:57:34'),
('63A8F1BB3B037', 22, 'admin', '2022-12-26 07:59:41'),
('63AA66002BD0D', 24, 'admin', '2022-12-27 11:22:30'),
('63AA739275056', 23, 'admin', '2022-12-27 11:26:25'),
('63ABE16FA00A5', 26, 'admin', '2022-12-28 13:33:16'),
('63ABE5BFD6B16', 27, 'admin', '2022-12-28 13:46:58'),
('63ABE74F335AE', 28, 'admin', '2022-12-28 13:54:19'),
('63ABE8E780BE7', 29, 'admin', '2022-12-28 13:59:22'),
('63ABE9B0E2443', 30, 'admin', '2022-12-28 14:02:56'),
('63ABEA370EA56', 30, 'admin', '2022-12-28 14:04:39'),
('63ABEB2169103', 25, 'admin', '2022-12-28 14:09:39');

--
-- Triggers `delivery`
--
DELIMITER $$
CREATE TRIGGER `tr_log_add_dlv` AFTER INSERT ON `delivery` FOR EACH ROW BEGIN
DECLARE uname VARCHAR(25);
 SELECT temporary_var.tempt_username INTO uname FROM temporary_var;
 CALL procedure_log_add_delivery(uname);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `initial_products`
--

CREATE TABLE `initial_products` (
  `id` varchar(50) NOT NULL,
  `initial_quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `initial_products`
--

INSERT INTO `initial_products` (`id`, `initial_quantity`) VALUES
('001', 96),
('002', 2),
('003', 2),
('004', 6),
('005', 6),
('006', 12),
('007', 12),
('008', 12),
('009', 12),
('010', 18),
('011', 48),
('012', 1),
('013', 10),
('014', 1),
('015', 1),
('016', 10),
('017', 1),
('018', 6),
('019', 6),
('020', 12),
('021', 1),
('022', 1),
('023', 1),
('024', 4),
('025', 2),
('026', 2),
('027', 2),
('028', 2),
('029', 2),
('030', 2),
('031', 3),
('032', 3),
('033', 3),
('034', 40),
('035', 48);

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `username` varchar(30) NOT NULL,
  `purpose` varchar(30) NOT NULL,
  `logs_time` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id`, `username`, `purpose`, `logs_time`) VALUES
(851, 'admin', 'User admin login', '2019-04-08 15:48:04'),
(854, 'admin', 'User admin logout', '2019-04-08 15:49:48'),
(855, 'admin', 'User admin login', '2019-04-08 15:50:04'),
(856, 'admin', 'Supplier OrangeCompany added', '2019-04-08 15:50:54'),
(857, 'admin', 'Customer jersel Added', '2019-04-08 15:51:25'),
(858, 'admin', 'Cash-in', '2019-04-08 15:51:58'),
(859, 'admin', 'Delivery Added', '2019-04-08 15:52:40'),
(860, 'admin', 'Customer Bill Added', '2019-04-08 15:53:18'),
(861, 'admin', 'Delivery Added', '2019-04-08 15:54:19'),
(862, 'admin', 'Delivery Added', '2019-04-08 15:55:29'),
(863, 'admin', 'Product sold', '2019-04-08 15:56:39'),
(864, 'admin', 'User admin logout', '2019-04-08 15:57:38'),
(865, 'admin', 'User admin login', '2019-04-08 16:06:54'),
(866, 'admin', 'User admin login', '2019-04-08 20:28:36'),
(867, 'admin', 'Product sold', '2019-04-08 20:29:27'),
(868, 'admin', 'User admin login', '2020-03-23 16:04:06'),
(869, 'admin', 'User admin logout', '2020-03-23 16:04:24'),
(870, 'admin', 'User admin login', '2020-03-28 12:58:34'),
(871, 'admin', 'User admin logout', '2020-03-28 13:02:20'),
(872, 'admin', 'User admin login', '2020-03-28 13:02:26'),
(873, 'admin', 'User admin logout', '2020-03-28 13:02:59'),
(874, 'admin', 'User admin login', '2020-03-28 13:05:48'),
(875, 'admin', 'Product sold', '2020-03-28 14:06:26'),
(876, 'admin', 'Product sold', '2020-03-28 14:07:27'),
(877, 'admin', 'Product sold', '2020-03-28 14:08:09'),
(878, 'admin', 'Product sold', '2020-03-28 14:14:46'),
(879, 'admin', 'Product sold', '2020-03-28 14:22:55'),
(880, 'admin', 'Product sold', '2020-03-28 14:27:51'),
(881, 'admin', 'Delivery Added', '2020-03-28 15:43:22'),
(882, 'admin', 'Product sold', '2020-03-28 16:14:30'),
(883, 'admin', 'User admin login', '2020-03-29 09:26:29'),
(884, 'admin', 'User admin login', '2020-03-29 09:40:46'),
(885, 'admin', 'Product Coffee updated', '2020-03-29 09:53:36'),
(886, 'admin', 'Product Coffee updated', '2020-03-29 09:53:51'),
(887, 'admin', 'User admin login', '2020-03-30 09:05:52'),
(888, 'admin', 'Product sold', '2020-03-30 09:07:10'),
(889, 'admin', 'User admin login', '2020-03-30 19:59:24'),
(890, 'admin', 'Delivery Added', '2020-03-30 20:00:48'),
(891, 'admin', 'User admin login', '2020-03-30 22:26:03'),
(892, 'admin', 'Customer PT Limbong Added', '2022-12-25 16:03:45'),
(893, 'admin', 'Delivery Added', '2022-12-25 16:28:05'),
(896, 'admin', 'User admin logout', '2022-12-25 22:51:10'),
(897, 'admin', 'User admin login', '2022-12-25 22:51:17'),
(898, 'admin', 'User admin logout', '2022-12-25 23:45:07'),
(899, 'admin', 'User admin login', '2022-12-25 23:45:26'),
(902, 'admin', 'User admin login', '2022-12-26 07:49:24'),
(903, 'admin', 'Delivery Added', '2022-12-26 07:59:41'),
(904, 'admin', 'User admin login', '2022-12-26 13:17:42'),
(919, 'admin', 'User admin logout', '2022-12-26 17:56:39'),
(920, 'admin', 'User admin login', '2022-12-26 17:56:45'),
(923, 'admin', 'Product aqua updated', '2022-12-26 18:08:24'),
(924, 'admin', 'Customer sifaaa updated', '2022-12-26 18:10:27'),
(925, 'admin', 'Product sofa updated', '2022-12-26 18:11:33'),
(926, 'admin', 'User admin logout', '2022-12-26 21:58:23'),
(927, 'admin', 'User admin login', '2022-12-26 21:58:28'),
(928, 'admin', 'Product Shampoo updated', '2022-12-26 22:42:33'),
(929, 'admin', 'Product Coffee updated', '2022-12-26 22:47:43'),
(930, 'admin', 'User admin login', '2022-12-26 23:49:33'),
(931, 'admin', 'Product deleted', '2022-12-27 01:13:24'),
(932, 'admin', 'Product deleted', '2022-12-27 01:17:59'),
(933, 'admin', 'Customer Andi added', '2022-12-27 01:48:58'),
(934, 'admin', 'Customer ANDI added', '2022-12-27 01:53:48'),
(935, 'admin', 'Customer Andi added', '2022-12-27 01:58:09'),
(936, 'admin', 'Customer Andi added', '2022-12-27 02:16:55'),
(937, 'admin', 'Customer Andi added', '2022-12-27 02:29:34'),
(938, 'admin', 'Customer Andi added', '2022-12-27 02:33:04'),
(939, 'admin', 'Customer Andi added', '2022-12-27 02:34:28'),
(940, 'admin', 'Customer Andra added', '2022-12-27 02:44:29'),
(941, 'admin', 'User admin login', '2022-12-27 08:46:14'),
(944, 'admin', 'Customer Andra updated', '2022-12-27 09:06:26'),
(945, 'admin', 'Customer Andra updated', '2022-12-27 09:06:26'),
(946, 'admin', 'Supplier PTINDOMARCO added', '2022-12-27 11:21:24'),
(947, 'admin', 'Delivery added/ product added', '2022-12-27 11:22:30'),
(948, 'admin', 'Delivery added/ product added', '2022-12-27 11:26:25'),
(949, 'admin', 'User admin logout', '2022-12-27 11:58:38'),
(950, 'user', 'User user login', '2022-12-27 11:58:45'),
(951, 'user', 'Product sold', '2022-12-27 11:59:57'),
(952, 'user', 'Product sold', '2022-12-27 12:00:17'),
(953, 'user', 'Product sold', '2022-12-27 12:01:09'),
(954, 'user', 'Product sold', '2022-12-27 12:01:44'),
(955, 'user', 'Product sold', '2022-12-27 12:01:58'),
(956, 'admin', 'User admin login', '2022-12-27 12:06:40'),
(957, 'admin', 'User admin login', '2022-12-27 13:48:48'),
(958, 'admin', 'Product deleted', '2022-12-27 13:52:46'),
(959, 'admin', 'Supplier PTINDOMARCO updated', '2022-12-27 13:54:55'),
(960, 'admin', 'Supplier BrandName updated', '2022-12-27 13:56:18'),
(961, 'admin', 'Supplier BrandName updated', '2022-12-27 13:58:46'),
(962, 'admin', 'Supplier PTGLOBAL updated', '2022-12-27 14:03:06'),
(963, 'admin', 'Supplier BrandName updated', '2022-12-27 14:10:22'),
(964, 'admin', 'Supplier BrandName updated', '2022-12-27 14:10:22'),
(965, 'admin', 'Supplier Deleted', '2022-12-27 14:11:15'),
(967, 'admin', 'User admin logout', '2022-12-27 14:49:39'),
(968, 'admin', 'User admin login', '2022-12-27 14:49:46'),
(969, 'admin', 'User Chris updated', '2022-12-27 15:05:54'),
(970, 'admin', 'User admin logout', '2022-12-27 15:10:54'),
(971, 'admin', 'User admin login', '2022-12-27 15:10:58'),
(0, 'admin', 'User admin login', '2022-12-28 12:39:03'),
(0, 'admin', 'User admin logout', '2022-12-28 13:02:26'),
(0, 'user', 'User user login', '2022-12-28 13:04:15'),
(0, 'admin', 'User admin login', '2022-12-28 13:05:12'),
(0, 'admin', 'Supplier PTSUKSESREZEKIBERSAMA', '2022-12-28 13:25:21'),
(0, 'admin', 'Delivery added/ product added', '2022-12-28 13:33:16'),
(0, 'admin', 'Delivery Added', '2022-12-28 13:33:16'),
(0, 'admin', 'Customer siantar Added', '2022-12-28 13:38:04'),
(0, 'admin', 'Supplier Deleted', '2022-12-28 13:40:31'),
(0, 'admin', 'Supplier Deleted', '2022-12-28 13:40:49'),
(0, 'admin', 'Supplier LimbongMula updated', '2022-12-28 13:42:37'),
(0, 'admin', 'Delivery added/ product added', '2022-12-28 13:46:58'),
(0, 'admin', 'Delivery Added', '2022-12-28 13:46:58'),
(0, 'admin', 'Customer wicaksana Added', '2022-12-28 13:50:55'),
(0, 'admin', 'Delivery added/ product added', '2022-12-28 13:54:19'),
(0, 'admin', 'Delivery Added', '2022-12-28 13:54:19'),
(0, 'admin', 'Customer bintang Added', '2022-12-28 13:57:16'),
(0, 'admin', 'Delivery added/ product added', '2022-12-28 13:59:22'),
(0, 'admin', 'Delivery Added', '2022-12-28 13:59:22'),
(0, 'admin', 'Customer enseval Added', '2022-12-28 14:01:04'),
(0, 'admin', 'Delivery added/ product added', '2022-12-28 14:02:56'),
(0, 'admin', 'Delivery Added', '2022-12-28 14:02:56'),
(0, 'admin', 'Delivery added/ product added', '2022-12-28 14:04:39'),
(0, 'admin', 'Delivery Added', '2022-12-28 14:04:39'),
(0, 'admin', 'Delivery added/ product added', '2022-12-28 14:09:39'),
(0, 'admin', 'Delivery Added', '2022-12-28 14:09:39');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_no` varchar(50) NOT NULL,
  `product_name` varchar(30) DEFAULT NULL,
  `sell_price` decimal(18,2) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `unit` varchar(30) DEFAULT NULL,
  `min_stocks` int(11) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `images` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_no`, `product_name`, `sell_price`, `quantity`, `unit`, `min_stocks`, `remarks`, `location`, `images`) VALUES
('001', 'FRF SCM BKM CAN 370gr', '11354.72', 92, 'CAN', 5, '-', '-', NULL),
('002', 'LISTERINE COOLMINT 100ml CRC', '7120.50', 4, 'BOTOL', 5, '-', '-', NULL),
('003', 'LISTERINE FRESH BURST 100ml CR', '7120.50', 4, 'BOTOL', 5, '-', '-', NULL),
('004', 'SHINZUI 8 SOAP MATSU 80gr', '3931.93', 12, 'PCS', 5, '-', '-', NULL),
('005', 'SHINZUI 8 SOAP MYORI 80gr ', '3931.93', 12, 'PCS', 5, '-', '-', NULL),
('006', 'MERRIES PANTS GOOD SKIN L-8', '17325.00', 24, 'PCS', 5, '-', '-', NULL),
('007', 'MERRIES PANTS GOOD SKIN XL-7', '15750.00', 24, 'PCS', 5, '-', '-', NULL),
('008', 'MERRIES PANTS GOOD SKIN S-11', '15750.00', 24, 'PCS', 5, '-', '-', NULL),
('009', 'MERRIES PANTS GOOD SKIN M-9', '15750.00', 24, 'PCS', 5, '-', '-', NULL),
('010', 'LAURIER NIGHT SAFE WING 30cm 1', '13231.00', 36, 'PCS', 5, '-', '-', NULL),
('011', 'LAURIER NATURAL CLEAN WINGS 5\'', '3465.00', 96, 'PCS', 5, '-', '-', NULL),
('012', 'TSP370-Krimer Kental Manis Tig', '505000.00', 2, 'CAR', 5, '-', '-', NULL),
('013', 'MADU TJO-MADU TJ SACHET ORIGIN', '8004.25', 20, 'BOX', 5, '-', '-', NULL),
('014', 'BKACS-bumbu kaldu ayam cube sa', '16160.00', 2, 'RCG', 5, '-', '-', NULL),
('015', 'BKSCS-bumbu kaldu sapi cube sa', '16160.00', 2, 'RCG', 5, '-', '-', NULL),
('016', 'BISKUAT CHOCOLATE 20X151 2G PR', '128330.60', 20, 'PCS', 5, '-', '-', NULL),
('017', 'BISKUAT CHOCOLATE 12X (20X,6GR', '96475.20', 2, 'CRT', 5, '-', '-', NULL),
('018', 'OREO CHOCO CHOCO WAFER 24X140,', '150146.60', 12, 'PCS', 5, '-', '-', NULL),
('019', 'OREO CHOCO VANILLA WAFER 24X14', '150146.60', 12, 'PCS', 5, '-', '-', NULL),
('020', 'OREO VANILLA 24X138G (119,6G +', '149626.45', 24, 'PCS', 5, '-', '-', NULL),
('021', 'FULLO VANILA MILK 7GR', '56881.32', 2, 'CS', 5, '-', '-', NULL),
('022', 'FULLO CHOCOLATE 7GR', '56881.32', 2, 'CS', 5, '-', '-', NULL),
('023', 'FULLO BLACK VANILLA 14GR', '93638.04', 2, 'CS', 5, '-', '-', NULL),
('024', 'BIHUN JAGUNG IDOLA 4*S', '52891.68', 8, 'BAG', 5, '-', '-', NULL),
('025', 'WATAMIE CHICKEN', '43154.27', 4, 'CAR', 5, '-', '-', NULL),
('026', 'WATAMIE SPICY', '43154.27', 4, 'CAR', 5, '-', '-', NULL),
('027', 'POPO CRUNCHY', '42925.00', 4, 'CAR', 5, '-', '-', NULL),
('028', 'KOLATOS', '42765.42', 4, 'CAR', 5, '-', '-', NULL),
('029', 'HATARI COCONUT 40 BKS 8X5X125G', '111100.00', 4, 'CRT', 5, '-', '-', NULL),
('030', 'HATARI CHOCOLATE 40BKS 8X5X125', '111100.00', 4, 'CRT', 5, '-', '-', NULL),
('031', 'PRENAGEN ENESIS STR 2006', '37546.20', 6, 'KALENG', 5, '-', '-', NULL),
('032', 'PRENAGEN LACTA MOCHA 4006', '67367.94', 6, 'KALENG', 5, '-', '-', NULL),
('033', 'CHIL KID PLAT VAN 200 6', '64923.00', 6, 'KALENG', 5, '-', '-', NULL),
('034', 'SPKA70-MI INSTAN SUPERMI RASA ', '56856.00', 80, 'CAR', 5, '-', '-', NULL),
('035', 'IKAP-S-IF KECAP ASIN SPECIAL P', '193920.00', 96, 'CAR', 5, '-', '-', NULL);

--
-- Triggers `products`
--
DELIMITER $$
CREATE TRIGGER `delete` BEFORE DELETE ON `products` FOR EACH ROW DELETE FROM initial_products WHERE id=old.product_no
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert` AFTER INSERT ON `products` FOR EACH ROW INSERT INTO initial_products(id,initial_quantity) VALUES(new.product_no,new.quantity)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `product_delivered`
--

CREATE TABLE `product_delivered` (
  `transaction_no` varchar(30) NOT NULL,
  `product_id` varchar(30) NOT NULL,
  `total_qty` int(11) NOT NULL,
  `buy_price` decimal(18,2) NOT NULL,
  `tax_rate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `product_delivered`
--

INSERT INTO `product_delivered` (`transaction_no`, `product_id`, `total_qty`, `buy_price`, `tax_rate`) VALUES
('63A801683FF97', '001', 96, '10918.00', 4),
('63A8060D0FECB', '002', 2, '7050.00', 1),
('63A8060D0FECB', '003', 2, '7050.00', 1),
('63A8060D0FECB', '004', 6, '3893.00', 1),
('63A8060D0FECB', '005', 6, '3893.00', 1),
('63A807B84B454', '006', 12, '16500.00', 5),
('63A8089A6122A', '007', 12, '15000.00', 5),
('63A8089A6122A', '008', 12, '15000.00', 5),
('63A8089A6122A', '009', 12, '15000.00', 5),
('63A8089A6122A', '010', 18, '13100.00', 1),
('63A8089A6122A', '011', 48, '3150.00', 10),
('63A80B5461AF2', '012', 1, '500000.00', 1),
('63A80B5461AF2', '013', 10, '7925.00', 1),
('63A80B5461AF2', '014', 1, '16000.00', 1),
('63A80B5461AF2', '015', 1, '16000.00', 1),
('63ABE16FA00A5', '016', 10, '127060.00', 1),
('63ABE16FA00A5', '017', 1, '95520.00', 1),
('63ABE16FA00A5', '018', 6, '148660.00', 1),
('63ABE16FA00A5', '019', 6, '148660.00', 1),
('63ABE16FA00A5', '020', 12, '148145.00', 1),
('63ABE5BFD6B16', '021', 1, '55766.00', 2),
('63ABE5BFD6B16', '022', 1, '55766.00', 2),
('63ABE5BFD6B16', '023', 1, '91802.00', 2),
('63ABE74F335AE', '024', 4, '52368.00', 1),
('63ABE74F335AE', '025', 2, '42727.00', 1),
('63ABE74F335AE', '026', 2, '42727.00', 1),
('63ABE74F335AE', '027', 2, '42500.00', 1),
('63ABE74F335AE', '028', 2, '42342.00', 1),
('63ABE8E780BE7', '029', 2, '110000.00', 1),
('63ABE8E780BE7', '030', 2, '110000.00', 1),
('63ABE9B0E2443', '031', 3, '36810.00', 2),
('63ABE9B0E2443', '032', 3, '66047.00', 2),
('63ABEA370EA56', '033', 3, '63650.00', 2),
('63ABEB2169103', '034', 40, '55200.00', 3),
('63ABEB2169103', '035', 48, '192000.00', 1);

--
-- Triggers `product_delivered`
--
DELIMITER $$
CREATE TRIGGER `update_product_in` BEFORE INSERT ON `product_delivered` FOR EACH ROW UPDATE `products` SET `products`.`quantity` = `products`.`quantity` + NEW.total_qty WHERE `products`.`product_no` = NEW.product_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `reciept_no` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL DEFAULT 0,
  `username` varchar(30) NOT NULL,
  `discount` int(11) NOT NULL,
  `total` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`reciept_no`, `customer_id`, `username`, `discount`, `total`, `date`) VALUES
(20, 16, 'admin', 0, 0, '2019-04-08 07:56:39'),
(21, 16, 'admin', 0, 0, '2019-04-08 12:29:27'),
(22, 16, 'admin', 0, 0, '2020-03-28 06:06:26'),
(23, 16, 'admin', 0, 0, '2020-03-28 06:07:27'),
(24, 16, 'admin', 0, 0, '2020-03-28 06:08:08'),
(25, 16, 'admin', 10, 0, '2020-03-28 06:14:46'),
(26, 16, 'admin', 10, 0, '2020-03-28 06:22:55'),
(27, 16, 'admin', 10, 2160, '2020-03-28 06:27:51'),
(28, 16, 'admin', 20, 1920, '2020-03-28 08:14:30'),
(29, 16, 'admin', 20, 4017, '2020-03-30 01:07:10'),
(30, 26, 'user', 0, 17, '2022-12-27 04:59:57'),
(31, 26, 'user', 0, 17, '2022-12-27 05:00:17'),
(32, 26, 'user', 0, 17, '2022-12-27 05:01:09'),
(33, 26, 'user', 0, 17, '2022-12-27 05:01:44'),
(34, 26, 'user', 0, 17, '2022-12-27 05:01:58');

-- --------------------------------------------------------

--
-- Table structure for table `sales_product`
--

CREATE TABLE `sales_product` (
  `reciept_no` int(11) NOT NULL,
  `product_id` varchar(20) NOT NULL,
  `price` decimal(18,2) NOT NULL,
  `qty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `sales_product`
--

INSERT INTO `sales_product` (`reciept_no`, `product_id`, `price`, `qty`) VALUES
(20, '1', '12.00', 10),
(20, '10011', '600.00', 2),
(21, '1', '12.00', 20),
(22, '10012', '2400.00', 1),
(23, '3', '6.60', 2),
(24, '10012', '2400.00', 1),
(25, '10012', '2400.00', 1),
(26, '10012', '2400.00', 1),
(27, '10012', '2400.00', 1),
(28, '10012', '2400.00', 1),
(29, '10012', '2400.00', 2),
(29, '4', '17.25', 3),
(29, '23213', '42.24', 4);

--
-- Triggers `sales_product`
--
DELIMITER $$
CREATE TRIGGER `update_products_out` BEFORE INSERT ON `sales_product` FOR EACH ROW UPDATE `products` SET `products`.`quantity` = `products`.`quantity` - 
NEW.qty WHERE `products`.`product_no` = NEW.product_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `supplier_id` int(11) NOT NULL,
  `company_name` varchar(30) DEFAULT NULL,
  `firstname` varchar(30) DEFAULT NULL,
  `lastname` varchar(30) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `contact_number` varchar(30) DEFAULT NULL,
  `image` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`supplier_id`, `company_name`, `firstname`, `lastname`, `address`, `contact_number`, `image`) VALUES
(23, 'LimbongMula', 'limbong', 'mula', 'JL.MEDAN KM 12 ,PEMATANG SIANTAR', '+08(22)1180-4931', 'Ambassador-pana.png'),
(24, 'PT. GLOBAL MITRA PRIMA', 'MITRA', 'PRIMA', 'JL.LAU CIMBA ,RAMBUNG MERAH \r\nPEMATANG SIANTAR', '(0622)7550888', 'blank-profile-picture-973460_1280.png'),
(25, 'PT.INDOMARCO ADI PRIMA', 'ADI', 'PRIMA', 'JL.JEND SUDIRMAN KAV 76-78 SetiaBudi JAKARTA SELATAN ', '(0622)75501234', 'blank-profile-picture-973460_1280.png'),
(26, 'PTSUKSESREZEKIBERSAMA', 'sukses', 'rezeki', 'JL.P.SUMBAWA NO.8 KM 11 ,MABAR - MEDAN', '+02(09)9293-1203', 'blank-profile-picture-973460_1280.png'),
(27, 'CV.SIANTAR SIMALUNGUN SUKSES', 'siantar', 'simalungun sukses', 'JL. RAKUTA SEMBIRING NO 155-PEMATANG SIANTAR', '066262561235', 'blank-profile-picture-973460_1280.png'),
(28, 'PT.WICAKSANA OVERSEAS INTERNAT', 'wicaksana', 'overseas', 'JL.ANCOL BARAT VII A5D NO.2 ANCOL PENJARINGAN , JAKARTA PUSAT', '(0622)7550746', 'blank-profile-picture-973460_1280.png'),
(29, 'PT.BINTANG MUTIARA CEMERLANG', 'bintang', 'cemerlang', 'JL.SANGNAWALUH KOMPLEK MEGALAND BLOK EE NO.17 ', '+02(09)9293-1203', 'blank-profile-picture-973460_1280.png'),
(30, 'PT.ENSEVAL PUTERA MEGATRADING ', 'enseval', 'putera', 'JL. MEDAN KM 4.5 , PEMATANG SIANTAR', '0622-435354', 'blank-profile-picture-973460_1280.png');

-- --------------------------------------------------------

--
-- Table structure for table `temporary_var`
--

CREATE TABLE `temporary_var` (
  `tempt_username` varchar(20) DEFAULT NULL,
  `tempt_productname` varchar(30) DEFAULT NULL,
  `tempt_first_name` varchar(30) DEFAULT NULL,
  `tempt_company` varchar(30) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `temporary_var`
--

INSERT INTO `temporary_var` (`tempt_username`, `tempt_productname`, `tempt_first_name`, `tempt_company`) VALUES
('admin', NULL, 'Chris', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(30) NOT NULL,
  `firstname` varchar(30) NOT NULL,
  `lastname` varchar(30) NOT NULL,
  `position` varchar(20) NOT NULL,
  `contact_number` varchar(30) NOT NULL,
  `image` varchar(30) NOT NULL,
  `password` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `firstname`, `lastname`, `position`, `contact_number`, `image`, `password`) VALUES
(7, 'admin', 'Juan', 'Cruz', 'admin', '082211804911', 'Myprofile.jpg', '21232f297a57a5a743894a0e4a801fc3'),
(13, 'user', 'Chris', 'Doemama', 'Employee', '082211804933', 'men-in-black.png', 'ee11cbb19052e40b07aac0ca060c23ee');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `tr_log_add_user` AFTER INSERT ON `users` FOR EACH ROW BEGIN
DECLARE a VARCHAR(25);
DECLARE b VARCHAR(25);
SELECT temporary_var.tempt_username INTO a FROM temporary_var;
SELECT temporary_var.tempt_first_name INTO b FROM temporary_var;
CALL procedure_log_add_user(a,b);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_log_del_ser` AFTER DELETE ON `users` FOR EACH ROW BEGIN
DECLARE a VARCHAR(25);
SELECT temporary_var.tempt_username INTO a FROM temporary_var;
CALL procedure_log_del_user(a);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_log_upd_user` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
DECLARE a VARCHAR(25);
DECLARE b VARCHAR(25);
 SELECT temporary_var.tempt_username INTO a FROM temporary_var;
 SELECT temporary_var.tempt_first_name INTO b FROM temporary_var;
 
 CALL procedure_log_upd_user(a,b);
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `initial_products`
--
ALTER TABLE `initial_products`
  ADD KEY `id` (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_no`);

--
-- Indexes for table `product_delivered`
--
ALTER TABLE `product_delivered`
  ADD KEY `product_id` (`product_id`),
  ADD KEY `transaction_no` (`transaction_no`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`supplier_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `initial_products`
--
ALTER TABLE `initial_products`
  ADD CONSTRAINT `initial_products_ibfk_1` FOREIGN KEY (`id`) REFERENCES `products` (`product_no`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
