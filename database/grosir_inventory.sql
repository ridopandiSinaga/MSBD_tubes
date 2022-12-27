-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 27 Des 2022 pada 10.10
-- Versi server: 10.4.24-MariaDB
-- Versi PHP: 8.0.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `coba3`
--

DELIMITER $$
--
-- Prosedur
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
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `count_product_in` () RETURNS VARCHAR(11) CHARSET utf8mb4  BEGIN
DECLARE p_in VARCHAR(10);
SET p_in = IFNULL((SELECT SUM(pd.total_qty) AS total FROM product_delivered pd),"0") ;
RETURN p_in ;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `count_product_out` () RETURNS VARCHAR(15) CHARSET utf8mb4  BEGIN
DECLARE p_out VARCHAR(10);
SET p_out = IFNULL((SELECT SUM(sp.qty) AS total FROM sales_product sp),"0") ;
RETURN p_out ;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `count_stock` () RETURNS VARCHAR(15) CHARSET utf8mb4  BEGIN
DECLARE stock VARCHAR(10);
SET stock = IFNULL((SELECT SUM(p.quantity) AS total FROM products p),"0") ;
RETURN stock ;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `cashflow`
--

CREATE TABLE `cashflow` (
  `transaction_id` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `amount` decimal(18,2) DEFAULT NULL,
  `username` varchar(30) DEFAULT NULL,
  `transaction_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `cashflow`
--

INSERT INTO `cashflow` (`transaction_id`, `description`, `amount`, `username`, `transaction_date`) VALUES
(1, 'Cash-in', '10000.00', 'admin', '2019-04-08 15:51:58');

-- --------------------------------------------------------

--
-- Struktur dari tabel `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL,
  `firstname` varchar(30) DEFAULT NULL,
  `lastname` varchar(30) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `contact_number` varchar(30) DEFAULT NULL,
  `image` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `customer`
--

INSERT INTO `customer` (`customer_id`, `firstname`, `lastname`, `address`, `contact_number`, `image`) VALUES
(16, 'jersel', 'Bill', 'Philippines', '+63(09)1234-1234', 'user.png'),
(26, 'Andra', 'Wijaksana', 'jl. Hakim Sembiring Medan', '+63(09)1234-1266', 'E_YqCK_VgAANr3-.jpg');

--
-- Trigger `customer`
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
-- Struktur dari tabel `delivery`
--

CREATE TABLE `delivery` (
  `transaction_no` varchar(20) NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `delivery`
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
('63AA739275056', 23, 'admin', '2022-12-27 11:26:25');

--
-- Trigger `delivery`
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
-- Stand-in struktur untuk tampilan `get_all_sales`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `get_all_sales` (
`reciept_no` int(11)
,`discount` int(11)
,`TotalPrice` int(11)
,`username` varchar(30)
,`date` timestamp
,`firstname` varchar(30)
,`lastname` varchar(30)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `initial_products`
--

CREATE TABLE `initial_products` (
  `id` varchar(50) NOT NULL,
  `initial_quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `initial_products`
--

INSERT INTO `initial_products` (`id`, `initial_quantity`) VALUES
('1001', 100),
('10011', 200),
('10012', 100),
('1', 100),
('2', 200),
('3', 150),
('4', 125),
('5', 100),
('23213', 23),
('10000', 21);

-- --------------------------------------------------------

--
-- Struktur dari tabel `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `username` varchar(30) NOT NULL,
  `purpose` varchar(30) NOT NULL,
  `logs_time` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `logs`
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
(971, 'admin', 'User admin login', '2022-12-27 15:10:58');

-- --------------------------------------------------------

--
-- Struktur dari tabel `products`
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `products`
--

INSERT INTO `products` (`product_no`, `product_name`, `sell_price`, `quantity`, `unit`, `min_stocks`, `remarks`, `location`, `images`) VALUES
('1', 'Coffee', '12.00', 75, 'sachet', 20, '-', '-', NULL),
('10000', 'asdas', '25575.60', 21, 'KA', 29, NULL, NULL, NULL),
('1001', 'Glass', '22.00', 100, 'Box', 20, NULL, NULL, NULL),
('10011', 'Chair', '600.00', 198, 'Each', 20, NULL, NULL, NULL),
('10012', 'Sofa', '2400.00', 92, 'Each', 20, NULL, NULL, NULL),
('2', 'Tooth Paste', '24.00', 200, 'sachet', 10, '-', '-', NULL),
('23213', 'sdfsd', '42.24', 19, 'sdfsdf', 23, 'fdsfds', 'dffdf', NULL),
('3', 'Shampoo', '6.60', 148, 'sachet', 20, '-', '-', NULL),
('4', 'Soap', '17.25', 122, 'sachet', 20, '------', '-', NULL),
('5', 'Conditioner', '12.00', 100, 'sachet', 10, NULL, NULL, NULL);

--
-- Trigger `products`
--
DELIMITER $$
CREATE TRIGGER `delete` BEFORE DELETE ON `products` FOR EACH ROW DELETE FROM initial_products WHERE id=old.product_no
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert` AFTER INSERT ON `products` FOR EACH ROW INSERT INTO initial_products(id,initial_quantity) VALUES(new.product_no,new.quantity)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_log_del_pro` AFTER DELETE ON `products` FOR EACH ROW BEGIN
DECLARE name VARCHAR(25);
 SELECT temporary_var.tempt_username INTO name FROM temporary_var;
 CALL procedure_log_del_product(name);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `product_delivered`
--

CREATE TABLE `product_delivered` (
  `transaction_no` varchar(30) NOT NULL,
  `product_id` varchar(30) NOT NULL,
  `total_qty` int(11) NOT NULL,
  `buy_price` decimal(18,2) NOT NULL,
  `tax_rate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `product_delivered`
--

INSERT INTO `product_delivered` (`transaction_no`, `product_id`, `total_qty`, `buy_price`, `tax_rate`) VALUES
('5CAAFDA8CD697', '1001', 100, '20.00', 10),
('5CAAFDEEDB333', '10011', 200, '500.00', 20),
('5CAAFDEEDB333', '10012', 100, '2000.00', 20),
('5CAAFE37D21E8', '1', 100, '10.00', 20),
('5CAAFE37D21E8', '2', 200, '20.00', 20),
('5CAAFE37D21E8', '3', 150, '6.00', 10),
('5CAAFE37D21E8', '4', 125, '15.00', 15),
('5CAAFE37D21E8', '5', 100, '10.00', 20),
('5E7F00084C934', '23213', 23, '32.00', 32),
('5E81DF2B7B8F7', '10000', 21, '21313.00', 20),
('63A8178B9262F', '1', 5, '10.00', 20);

--
-- Trigger `product_delivered`
--
DELIMITER $$
CREATE TRIGGER `update_product_in` BEFORE INSERT ON `product_delivered` FOR EACH ROW UPDATE `products` SET `products`.`quantity` = `products`.`quantity` + NEW.total_qty WHERE `products`.`product_no` = NEW.product_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `sales`
--

CREATE TABLE `sales` (
  `reciept_no` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL DEFAULT 0,
  `username` varchar(30) NOT NULL,
  `discount` int(11) NOT NULL,
  `total` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `sales`
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
-- Struktur dari tabel `sales_product`
--

CREATE TABLE `sales_product` (
  `reciept_no` int(11) NOT NULL,
  `product_id` varchar(20) NOT NULL,
  `price` decimal(18,2) NOT NULL,
  `qty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `sales_product`
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
-- Trigger `sales_product`
--
DELIMITER $$
CREATE TRIGGER `update_products_out` BEFORE INSERT ON `sales_product` FOR EACH ROW UPDATE `products` SET `products`.`quantity` = `products`.`quantity` - 
NEW.qty WHERE `products`.`product_no` = NEW.product_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `supplier`
--

CREATE TABLE `supplier` (
  `supplier_id` int(11) NOT NULL,
  `company_name` varchar(30) DEFAULT NULL,
  `firstname` varchar(30) DEFAULT NULL,
  `lastname` varchar(30) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `contact_number` varchar(30) DEFAULT NULL,
  `image` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `supplier`
--

INSERT INTO `supplier` (`supplier_id`, `company_name`, `firstname`, `lastname`, `address`, `contact_number`, `image`) VALUES
(21, 'OrangeCompany', 'Oracle', 'LTD', 'USA', '+63(09)1234-1234', 'Internship-Web-Graphic-01.png'),
(22, 'BrandName', 'Bill', 'Joemama', 'Africa', '+63(09)1234-1234', 'multi-user-icon.png'),
(23, 'Limbong Mula', 'PT Limbong', 'Mula', 'Panei Tongah, Kab. Simalungun', '082211804923', 'E_YqCK_VgAANr3-.jpg'),
(24, 'PTINDOMARCO', 'ADI', 'PRIMA', 'JL.JEND SUDIRMAN KAV 76-78 SetiaBudi JAKARTA SELATAN', '+99(99)9999-9932', 'E_YqCK_VgAANr3-.jpg');

--
-- Trigger `supplier`
--
DELIMITER $$
CREATE TRIGGER `log_log_del_sup` AFTER DELETE ON `supplier` FOR EACH ROW BEGIN
DECLARE name VARCHAR(25);
 SELECT temporary_var.tempt_username INTO name FROM temporary_var;
 CALL procedure_log_del_supplier(name);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_log_add_sup` AFTER INSERT ON `supplier` FOR EACH ROW BEGIN
DECLARE a VARCHAR(25);
DECLARE b VARCHAR(25);
 SELECT temporary_var.tempt_username INTO a FROM temporary_var;
 SELECT temporary_var.tempt_company INTO b FROM temporary_var;
 CALL procedure_log_upd_supplier(a,b);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_log_upd_sup` AFTER UPDATE ON `supplier` FOR EACH ROW BEGIN
DECLARE a VARCHAR(25);
DECLARE b VARCHAR(25);
 SELECT temporary_var.tempt_username INTO a FROM temporary_var;
 SELECT temporary_var.tempt_company INTO b FROM temporary_var;
 CALL procedure_log_upd_supplier(a,b);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `temporary_var`
--

CREATE TABLE `temporary_var` (
  `tempt_username` varchar(20) DEFAULT NULL,
  `tempt_productname` varchar(30) DEFAULT NULL,
  `tempt_first_name` varchar(30) DEFAULT NULL,
  `tempt_company` varchar(30) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `temporary_var`
--

INSERT INTO `temporary_var` (`tempt_username`, `tempt_productname`, `tempt_first_name`, `tempt_company`) VALUES
('admin', NULL, 'Chris', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `firstname`, `lastname`, `position`, `contact_number`, `image`, `password`) VALUES
(7, 'admin', 'Juan', 'Cruz', 'admin', '082211804911', 'Myprofile.jpg', '21232f297a57a5a743894a0e4a801fc3'),
(13, 'user', 'Chris', 'Doemama', 'Employee', '082211804933', 'men-in-black.png', 'ee11cbb19052e40b07aac0ca060c23ee');

--
-- Trigger `users`
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

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `view_record_delivery`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `view_record_delivery` (
`transaction_no` varchar(20)
,`company_name` varchar(30)
,`username` varchar(20)
,`TotalPrice` decimal(50,2)
,`TotalQuantity` decimal(32,0)
,`date` datetime
);

-- --------------------------------------------------------

--
-- Struktur untuk view `get_all_sales`
--
DROP TABLE IF EXISTS `get_all_sales`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_all_sales`  AS SELECT `sales_product`.`reciept_no` AS `reciept_no`, `sales`.`discount` AS `discount`, `sales`.`total` AS `TotalPrice`, `sales`.`username` AS `username`, `sales`.`date` AS `date`, `customer`.`firstname` AS `firstname`, `customer`.`lastname` AS `lastname` FROM ((`sales_product` join `sales` on(`sales_product`.`reciept_no` = `sales`.`reciept_no`)) join `customer` on(`sales`.`customer_id` = `customer`.`customer_id`)) GROUP BY `sales_product`.`reciept_no``reciept_no`  ;

-- --------------------------------------------------------

--
-- Struktur untuk view `view_record_delivery`
--
DROP TABLE IF EXISTS `view_record_delivery`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_record_delivery`  AS SELECT `delivery`.`transaction_no` AS `transaction_no`, `supplier`.`company_name` AS `company_name`, `delivery`.`username` AS `username`, sum(`product_delivered`.`buy_price` * `product_delivered`.`total_qty`) AS `TotalPrice`, sum(`product_delivered`.`total_qty`) AS `TotalQuantity`, `delivery`.`date` AS `date` FROM (((`delivery` join `product_delivered` on(`delivery`.`transaction_no` = `product_delivered`.`transaction_no`)) join `supplier` on(`delivery`.`supplier_id` = `supplier`.`supplier_id`)) join `products` on(`product_delivered`.`product_id` = `products`.`product_no`)) GROUP BY `delivery`.`transaction_no` ORDER BY `delivery`.`date` AS `DESCdesc` ASC  ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `cashflow`
--
ALTER TABLE `cashflow`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `username` (`username`);

--
-- Indeks untuk tabel `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indeks untuk tabel `delivery`
--
ALTER TABLE `delivery`
  ADD PRIMARY KEY (`transaction_no`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `username` (`username`);

--
-- Indeks untuk tabel `initial_products`
--
ALTER TABLE `initial_products`
  ADD KEY `id` (`id`);

--
-- Indeks untuk tabel `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`);

--
-- Indeks untuk tabel `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_no`);

--
-- Indeks untuk tabel `product_delivered`
--
ALTER TABLE `product_delivered`
  ADD KEY `product_id` (`product_id`),
  ADD KEY `transaction_no` (`transaction_no`);

--
-- Indeks untuk tabel `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`reciept_no`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `username` (`username`);

--
-- Indeks untuk tabel `sales_product`
--
ALTER TABLE `sales_product`
  ADD KEY `product_id` (`product_id`),
  ADD KEY `reciept_no` (`reciept_no`);

--
-- Indeks untuk tabel `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD UNIQUE KEY `user_id` (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `cashflow`
--
ALTER TABLE `cashflow`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT untuk tabel `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=972;

--
-- AUTO_INCREMENT untuk tabel `sales`
--
ALTER TABLE `sales`
  MODIFY `reciept_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT untuk tabel `sales_product`
--
ALTER TABLE `sales_product`
  MODIFY `reciept_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT untuk tabel `supplier`
--
ALTER TABLE `supplier`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `cashflow`
--
ALTER TABLE `cashflow`
  ADD CONSTRAINT `cashflow_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`);

--
-- Ketidakleluasaan untuk tabel `delivery`
--
ALTER TABLE `delivery`
  ADD CONSTRAINT `delivery_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`),
  ADD CONSTRAINT `delivery_ibfk_2` FOREIGN KEY (`username`) REFERENCES `users` (`username`);

--
-- Ketidakleluasaan untuk tabel `initial_products`
--
ALTER TABLE `initial_products`
  ADD CONSTRAINT `initial_products_ibfk_1` FOREIGN KEY (`id`) REFERENCES `products` (`product_no`);

--
-- Ketidakleluasaan untuk tabel `product_delivered`
--
ALTER TABLE `product_delivered`
  ADD CONSTRAINT `product_delivered_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_no`),
  ADD CONSTRAINT `product_delivered_ibfk_2` FOREIGN KEY (`transaction_no`) REFERENCES `delivery` (`transaction_no`);

--
-- Ketidakleluasaan untuk tabel `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  ADD CONSTRAINT `sales_ibfk_3` FOREIGN KEY (`username`) REFERENCES `users` (`username`);

--
-- Ketidakleluasaan untuk tabel `sales_product`
--
ALTER TABLE `sales_product`
  ADD CONSTRAINT `sales_product_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_no`),
  ADD CONSTRAINT `sales_product_ibfk_3` FOREIGN KEY (`reciept_no`) REFERENCES `sales` (`reciept_no`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
