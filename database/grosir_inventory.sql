-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 29 Des 2022 pada 09.19
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `find_recent_delivery_added` (IN `lim` INT(25))   SELECT CONCAT(CONCAT(pd.total_qty,' ',p.unit),' ',product_name) as product_in ,d.date
FROM products p
JOIN product_delivered pd ON pd.product_id = p.product_no
JOIN delivery  d ON d.transaction_no = pd.transaction_no
ORDER BY d.date DESC LIMIT lim$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `find_recent_sale_added` (IN `lim` INT)   SELECT CONCAT(CONCAT(sp.qty,' ',p.unit),' ',product_name) as product_out ,s.date
FROM products p
JOIN sales_product sp ON sp.product_id = p.product_no
JOIN sales  s ON s.reciept_no = sp.reciept_no
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
('63AA739275056', 23, 'admin', '2022-12-27 11:26:25'),
('63AAE2067D99E', 23, 'admin', '2022-12-27 19:16:32'),
('63AAE31E0064E', 23, 'admin', '2022-12-27 19:21:15'),
('63AB36D34F31C', 26, 'admin', '2022-12-28 01:18:19'),
('63AB388CE598A', 23, 'admin', '2022-12-28 01:26:10'),
('63AB543038EAC', 26, 'admin', '2022-12-28 03:29:03'),
('63AB5FB617F34', 26, 'admin', '2022-12-28 04:12:37'),
('63AB6047E8FB3', 26, 'admin', '2022-12-28 04:15:01'),
('63ABCD739BB92', 26, 'admin', '2022-12-28 12:00:52'),
('63ABCE7C50731', 26, 'admin', '2022-12-28 12:05:17'),
('63ABCEBC65FDF', 26, 'admin', '2022-12-28 12:06:14'),
('63ABCF13C4693', 26, 'admin', '2022-12-28 12:07:41'),
('63ABCF3783EBE', 23, 'admin', '2022-12-28 12:08:18'),
('63ABD20E6F5BF', 26, 'admin', '2022-12-28 12:20:29'),
('63ABD40F307FA', 26, 'admin', '2022-12-28 12:28:57'),
('63ABD45F99EA5', 23, 'admin', '2022-12-28 12:30:17'),
('63ABD73C85B25', 26, 'admin', '2022-12-28 12:42:30'),
('63ABD75EDAF87', 26, 'admin', '2022-12-28 12:43:06'),
('63ABD7FDA9525', 26, 'admin', '2022-12-28 12:45:43'),
('63ABDBE9A41C6', 26, 'admin', '2022-12-28 13:02:26'),
('63ABDC2D810BC', 23, 'admin', '2022-12-28 13:03:35'),
('63ABDCD3D22AC', 26, 'admin', '2022-12-28 13:06:20'),
('63ABE32C1062C', 23, 'admin', '2022-12-28 13:33:29'),
('63ABE3C4D56ED', 26, 'admin', '2022-12-28 13:36:00'),
('63ABE3FC7B985', 23, 'admin', '2022-12-28 13:37:43'),
('63ABE4A0B8C51', 26, 'admin', '2022-12-28 13:39:39'),
('63ABE50A6A5D8', 26, 'admin', '2022-12-28 13:41:29'),
('63ABE5BB85081', 24, 'admin', '2022-12-28 13:44:25'),
('63ABE6FE10D63', 26, 'admin', '2022-12-28 13:49:48'),
('63ABE7BA7D830', 26, 'admin', '2022-12-28 13:52:58'),
('63ABE7DE45943', 26, 'admin', '2022-12-28 13:53:27'),
('63ABE8F7EE1A7', 24, 'admin', '2022-12-28 13:58:11'),
('63ABE93040BE0', 24, 'admin', '2022-12-28 13:59:07'),
('63ABE989B11EB', 26, 'admin', '2022-12-28 14:00:36'),
('63ABE9E5495F8', 24, 'admin', '2022-12-28 14:02:05'),
('63ABEA22323DE', 24, 'admin', '2022-12-28 14:03:07'),
('63ABEA625E884', 26, 'admin', '2022-12-28 14:04:26'),
('63ABEBCABA936', 24, 'admin', '2022-12-28 14:10:16'),
('63ABECA5D6478', 24, 'admin', '2022-12-28 14:13:50'),
('63ABF99DD0C84', 24, 'admin', '2022-12-28 15:11:22'),
('63ABFA4DD47D5', 24, 'admin', '2022-12-28 15:12:06'),
('63ABFA8B11BB9', 24, 'admin', '2022-12-28 15:13:09'),
('63ABFAC9B0424', 24, 'admin', '2022-12-28 15:14:14'),
('63ABFAF832C39', 24, 'admin', '2022-12-28 15:14:57'),
('63ABFD9AD9B55', 24, 'admin', '2022-12-28 15:26:10'),
('63ABFDCB0A8A9', 24, 'admin', '2022-12-28 15:27:01'),
('63AC00FB6CB62', 24, 'admin', '2022-12-28 15:40:41'),
('63AC011DC524E', 24, 'admin', '2022-12-28 15:41:11'),
('63AC0172B7991', 24, 'admin', '2022-12-28 15:42:34'),
('63AC029EC521D', 24, 'admin', '2022-12-28 15:47:37'),
('63AC05CD24950', 24, 'admin', '2022-12-28 16:01:12'),
('63AC069226D9E', 24, 'admin', '2022-12-28 16:04:30'),
('63AC07118FB7C', 24, 'admin', '2022-12-28 16:06:34'),
('63AC074420ECC', 24, 'admin', '2022-12-28 16:08:15'),
('63AC079278E4B', 24, 'admin', '2022-12-28 16:08:42'),
('63AC08349AEF0', 24, 'admin', '2022-12-28 16:11:31'),
('63AC08DBDEF49', 24, 'admin', '2022-12-28 16:14:12'),
('63AC0961A3054', 24, 'admin', '2022-12-28 16:16:29'),
('63AC09B861497', 24, 'admin', '2022-12-28 16:17:52'),
('63AC0B1885F78', 24, 'admin', '2022-12-28 16:23:45'),
('63AC0BAEA2028', 24, 'admin', '2022-12-28 16:26:16'),
('63AC0BD7BA9E5', 24, 'admin', '2022-12-28 16:26:56'),
('63AC0CB9BCC04', 24, 'admin', '2022-12-28 16:30:44'),
('63AC0D3F9E3D0', 24, 'admin', '2022-12-28 16:32:59'),
('63AC0DDC71DA8', 24, 'admin', '2022-12-28 16:35:41'),
('63AC0EC6E198B', 24, 'admin', '2022-12-28 16:39:31'),
('63AC0F5F6C9B6', 24, 'admin', '2022-12-28 16:41:59'),
('63AC0F9F649A3', 24, 'admin', '2022-12-28 16:43:04'),
('63AC0FD39A238', 24, 'admin', '2022-12-28 16:43:55'),
('63AC101124BD9', 24, 'admin', '2022-12-28 16:44:56'),
('63AC103FA3AF2', 24, 'admin', '2022-12-28 16:45:45'),
('63AC109BC75D3', 24, 'admin', '2022-12-28 16:47:16'),
('63AC118716AB3', 24, 'admin', '2022-12-28 16:51:16'),
('63AC30D9B2C7D', 24, 'admin', '2022-12-28 19:04:53'),
('63AC34F11C75B', 24, 'admin', '2022-12-28 19:22:26'),
('63AC35D41566F', 24, 'admin', '2022-12-28 19:26:06'),
('63AC3B1D79F6D', 24, 'admin', '2022-12-28 19:49:32'),
('63AC5264B75BE', 26, 'admin', '2022-12-28 21:28:03'),
('63AC54D43234C', 26, 'admin', '2022-12-28 21:38:23'),
('63AC55168DAEA', 24, 'admin', '2022-12-28 21:39:34'),
('63AC55FB3AC25', 26, 'admin', '2022-12-28 21:43:20'),
('63AC564D28EA8', 24, 'admin', '2022-12-28 21:44:38'),
('63AC56832588A', 24, 'admin', '2022-12-28 21:45:32'),
('63AC56B9C5243', 26, 'admin', '2022-12-28 21:46:29'),
('63AC58FA3CDA4', 24, 'admin', '2022-12-28 21:56:04'),
('63AC5E54730BB', 24, 'admin', '2022-12-28 22:18:57'),
('63AC5ED903889', 26, 'admin', '2022-12-28 22:21:06'),
('63AC6268367D4', 26, 'admin', '2022-12-28 22:36:18'),
('63AC648566676', 24, 'admin', '2022-12-28 22:45:22'),
('63AC658C210A8', 26, 'admin', '2022-12-28 22:49:41'),
('63AC6B54C76FF', 26, 'admin', '2022-12-28 23:14:23'),
('63AD0A800CB01', 26, 'admin', '2022-12-29 10:33:31'),
('63AD10803C498', 23, 'admin', '2022-12-29 11:00:15');

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
('10000', 21),
('006', 1),
('barcode1', 25),
('barcode2', 25),
('barcode3', 25),
('barcode4', 25),
('barcode5', 25),
('barcode6', 25),
('barcode7', 25),
('barcode8', 25),
('barcode9', 25),
('barcode10', 25),
('barcode11', 25),
('025', 48),
('026', 48),
('027', 56),
('028', 56),
('029', 32),
('030', 32),
('031', 16),
('032', 16),
('033', 32),
('034', 96),
('035', 18),
('013', 20),
('014', 100),
('015', 100),
('016', 50),
('017', 50),
('018', 30),
('019', 30),
('020', 30),
('021', 50),
('022', 50),
('023', 50),
('024', 25);

-- --------------------------------------------------------

--
-- Struktur dari tabel `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `purpose` varchar(225) NOT NULL,
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
(971, 'admin', 'User admin login', '2022-12-27 15:10:58'),
(972, 'admin', 'Delivery added/ product added', '2022-12-27 19:16:32'),
(973, 'admin', 'Delivery added/ product added', '2022-12-27 19:21:15'),
(974, 'admin', 'Supplier PT. GLOBAL MITRA PRIM', '2022-12-27 19:43:09'),
(975, 'admin', 'Supplier PT. GLOBAL MITRA PRIM', '2022-12-27 19:49:42'),
(976, 'admin', 'Supplier PT. GLOBAL MITRA PRIM', '2022-12-27 19:49:42'),
(977, 'admin', 'Supplier PT. GLOBAL MITRA PRIMA updated', '2022-12-27 19:52:34'),
(978, 'admin', 'Supplier PT. GLOBAL MITRA PRIMA updated', '2022-12-27 19:52:34'),
(979, 'admin', 'Supplier PT. GLOBAL MITRA PRIMA updated', '2022-12-27 19:53:50'),
(980, 'admin', 'Supplier PT. GLOBAL MITRA PRIMA updated', '2022-12-27 19:53:50'),
(981, 'admin', 'Supplier PT. INDOMARCO ADI PRIMA updated', '2022-12-27 19:54:56'),
(982, 'admin', 'Supplier PT. INDOMARCO ADI PRIMA updated', '2022-12-27 19:54:56'),
(983, 'admin', 'Supplier Limbong Mula updated', '2022-12-27 19:55:21'),
(984, 'admin', 'Supplier Limbong Mula updated', '2022-12-27 19:55:21'),
(986, 'admin', 'User admin logout', '2022-12-27 21:21:27'),
(987, 'user', 'User user login', '2022-12-27 21:21:34'),
(988, 'user', 'User user logout', '2022-12-27 21:23:15'),
(989, 'admin', 'User admin login', '2022-12-27 21:23:20'),
(990, '', 'Delivery added/ product added', '2022-12-28 01:18:19'),
(991, 'admin', 'Delivery added/ product added', '2022-12-28 01:26:10'),
(992, 'admin', 'Delivery added/ product added', '2022-12-28 03:29:03'),
(993, 'admin', 'Delivery added/ product added', '2022-12-28 04:12:37'),
(994, 'admin', 'Delivery added/ product added', '2022-12-28 04:15:01'),
(995, 'admin', 'User admin login', '2022-12-28 08:50:25'),
(996, 'admin', 'User admin logout', '2022-12-28 10:54:23'),
(997, 'admin', 'User admin login', '2022-12-28 10:55:01'),
(998, 'admin', 'Delivery added/ product added', '2022-12-28 12:00:52'),
(999, 'admin', 'Delivery added/ product added', '2022-12-28 12:05:17'),
(1000, 'admin', 'Delivery added/ product added', '2022-12-28 12:06:14'),
(1001, 'admin', 'Delivery added/ product added', '2022-12-28 12:07:41'),
(1002, 'admin', 'Delivery added/ product added', '2022-12-28 12:08:18'),
(1003, 'admin', 'Delivery added/ product added', '2022-12-28 12:20:29'),
(1004, 'admin', 'Delivery added/ product added', '2022-12-28 12:28:57'),
(1005, 'admin', 'Delivery added/ product added', '2022-12-28 12:30:17'),
(1006, 'admin', 'Delivery added/ product added', '2022-12-28 12:42:30'),
(1007, 'admin', 'Delivery added/ product added', '2022-12-28 12:43:06'),
(1008, 'admin', 'Delivery added/ product added', '2022-12-28 12:45:43'),
(1009, 'admin', 'Delivery added/ product added', '2022-12-28 13:02:26'),
(1010, 'admin', 'Delivery added/ product added', '2022-12-28 13:03:35'),
(1011, 'admin', 'Delivery added/ product added', '2022-12-28 13:06:20'),
(1012, 'admin', 'Delivery added/ product added', '2022-12-28 13:33:29'),
(1013, 'admin', 'Delivery Added', '2022-12-28 13:33:29'),
(1014, 'admin', 'Delivery added/ product added', '2022-12-28 13:36:00'),
(1015, 'admin', 'Delivery Added', '2022-12-28 13:36:00'),
(1016, 'admin', 'Delivery added/ product added', '2022-12-28 13:37:43'),
(1017, 'admin', 'Delivery Added', '2022-12-28 13:37:43'),
(1018, 'admin', 'Delivery added/ product added', '2022-12-28 13:39:39'),
(1019, 'admin', 'Delivery added/ product added', '2022-12-28 13:41:29'),
(1020, 'admin', 'Delivery Added', '2022-12-28 13:41:29'),
(1021, 'admin', 'Delivery added/ product added', '2022-12-28 13:44:25'),
(1022, 'admin', 'Delivery Added', '2022-12-28 13:44:25'),
(1023, 'admin', 'Delivery added/ product added', '2022-12-28 13:49:48'),
(1024, 'admin', 'Delivery Added', '2022-12-28 13:49:48'),
(1025, 'admin', 'Delivery added/ product added', '2022-12-28 13:52:58'),
(1026, 'admin', 'Delivery Added', '2022-12-28 13:52:58'),
(1027, 'admin', 'Delivery added/ product added', '2022-12-28 13:53:27'),
(1028, 'admin', 'Delivery Added', '2022-12-28 13:53:27'),
(1029, 'admin', 'Delivery added/ product added', '2022-12-28 13:58:11'),
(1030, 'admin', 'Delivery Added', '2022-12-28 13:58:11'),
(1031, 'admin', 'Delivery added/ product added', '2022-12-28 13:59:07'),
(1032, 'admin', 'Delivery added/ product added', '2022-12-28 14:00:36'),
(1033, 'admin', 'Delivery added/ product added', '2022-12-28 14:02:05'),
(1034, 'admin', 'Delivery added/ product added', '2022-12-28 14:03:07'),
(1035, 'admin', 'Delivery added/ product added', '2022-12-28 14:04:26'),
(1036, 'admin', 'Delivery added/ product added', '2022-12-28 14:10:16'),
(1037, 'admin', 'Delivery added/ product added', '2022-12-28 14:13:50'),
(1038, 'admin', 'Delivery added/ product added', '2022-12-28 15:11:22'),
(1039, 'admin', 'Delivery added/ product added', '2022-12-28 15:12:06'),
(1040, 'admin', 'Delivery added/ product added', '2022-12-28 15:13:09'),
(1041, 'admin', 'Delivery added/ product added', '2022-12-28 15:14:14'),
(1042, 'admin', 'Delivery added/ product added', '2022-12-28 15:14:57'),
(1043, 'admin', 'Delivery Added', '2022-12-28 15:14:58'),
(1044, 'admin', 'Delivery added/ product added', '2022-12-28 15:26:10'),
(1045, 'admin', 'Delivery added/ product added', '2022-12-28 15:27:01'),
(1046, 'admin', 'Delivery added/ product added', '2022-12-28 15:40:41'),
(1047, 'admin', 'Delivery added/ product added', '2022-12-28 15:41:11'),
(1048, 'admin', 'Delivery Added', '2022-12-28 15:41:11'),
(1049, 'admin', 'Delivery added/ product added', '2022-12-28 15:42:34'),
(1050, 'admin', 'Delivery Added', '2022-12-28 15:42:34'),
(1051, 'admin', 'Delivery added/ product added', '2022-12-28 15:47:37'),
(1052, 'admin', 'Delivery added/ product added', '2022-12-28 16:01:12'),
(1053, 'admin', 'Delivery added/ product added', '2022-12-28 16:04:30'),
(1054, 'admin', 'Delivery added/ product added', '2022-12-28 16:06:34'),
(1055, 'admin', 'Delivery added/ product added', '2022-12-28 16:08:15'),
(1056, 'admin', 'Delivery added/ product added', '2022-12-28 16:08:42'),
(1057, 'admin', 'Delivery added/ product added', '2022-12-28 16:11:31'),
(1058, 'admin', 'Delivery Added', '2022-12-28 16:11:31'),
(1059, 'admin', 'Delivery added/ product added', '2022-12-28 16:14:12'),
(1060, 'admin', 'Delivery Added', '2022-12-28 16:14:12'),
(1061, 'admin', 'Delivery added/ product added', '2022-12-28 16:16:29'),
(1062, 'admin', 'Delivery Added', '2022-12-28 16:16:29'),
(1063, 'admin', 'Delivery added/ product added', '2022-12-28 16:17:52'),
(1064, 'admin', 'Delivery added/ product added', '2022-12-28 16:23:45'),
(1065, 'admin', 'Delivery added/ product added', '2022-12-28 16:26:16'),
(1066, 'admin', 'Delivery added/ product added', '2022-12-28 16:26:56'),
(1067, 'admin', 'Delivery Added', '2022-12-28 16:26:56'),
(1068, 'admin', 'Delivery added/ product added', '2022-12-28 16:30:44'),
(1069, 'admin', 'Delivery added/ product added', '2022-12-28 16:32:59'),
(1070, 'admin', 'Delivery added/ product added', '2022-12-28 16:35:41'),
(1071, 'admin', 'Delivery Added', '2022-12-28 16:35:41'),
(1072, 'admin', 'Delivery added/ product added', '2022-12-28 16:39:31'),
(1073, 'admin', 'Delivery Added', '2022-12-28 16:39:31'),
(1074, 'admin', 'Delivery added/ product added', '2022-12-28 16:41:59'),
(1075, 'admin', 'Delivery Added', '2022-12-28 16:41:59'),
(1076, 'admin', 'Delivery added/ product added', '2022-12-28 16:43:04'),
(1077, 'admin', 'Delivery added/ product added', '2022-12-28 16:43:55'),
(1078, 'admin', 'Delivery Added', '2022-12-28 16:43:55'),
(1079, 'admin', 'Delivery added/ product added', '2022-12-28 16:44:56'),
(1080, 'admin', 'Delivery added/ product added', '2022-12-28 16:45:45'),
(1081, 'admin', 'Delivery Added', '2022-12-28 16:45:45'),
(1082, 'admin', 'Delivery added/ product added', '2022-12-28 16:47:16'),
(1083, 'admin', 'Delivery Added', '2022-12-28 16:47:16'),
(1084, 'admin', 'Delivery added/ product added', '2022-12-28 16:51:16'),
(1085, 'admin', 'Delivery Added', '2022-12-28 16:51:16'),
(1086, 'admin', 'Delivery added/ product added', '2022-12-28 19:04:53'),
(1087, 'admin', 'Delivery Added', '2022-12-28 19:04:53'),
(1088, 'admin', 'Delivery added/ product added', '2022-12-28 19:22:26'),
(1089, 'admin', 'Delivery Added', '2022-12-28 19:22:26'),
(1090, 'admin', 'Delivery added/ product added', '2022-12-28 19:26:06'),
(1091, 'admin', 'Delivery Added', '2022-12-28 19:26:06'),
(1092, 'admin', 'Delivery added/ product added', '2022-12-28 19:49:32'),
(1093, 'admin', 'User admin login', '2022-12-28 21:19:41'),
(1094, 'admin', 'Delivery added/ product added', '2022-12-28 21:28:03'),
(1095, 'admin', 'Delivery Added', '2022-12-28 21:28:03'),
(1096, 'admin', 'Delivery added/ product added', '2022-12-28 21:38:23'),
(1097, 'admin', 'Delivery added/ product added', '2022-12-28 21:39:34'),
(1098, 'admin', 'Delivery Added', '2022-12-28 21:39:34'),
(1099, 'admin', 'Delivery added/ product added', '2022-12-28 21:43:20'),
(1100, 'admin', 'Delivery added/ product added', '2022-12-28 21:44:38'),
(1101, 'admin', 'Delivery added/ product added', '2022-12-28 21:45:32'),
(1102, 'admin', 'Delivery added/ product added', '2022-12-28 21:46:29'),
(1103, 'admin', 'Delivery Added', '2022-12-28 21:46:29'),
(1104, 'admin', 'Delivery added/ product added', '2022-12-28 21:56:04'),
(1105, 'admin', 'Delivery Added', '2022-12-28 21:56:04'),
(1106, 'admin', 'Delivery added/ product added', '2022-12-28 22:18:57'),
(1107, 'admin', 'Delivery added/ product added', '2022-12-28 22:21:06'),
(1108, 'admin', 'Delivery Added', '2022-12-28 22:21:06'),
(1109, 'admin', 'Delivery added/ product added', '2022-12-28 22:36:18'),
(1110, 'admin', 'Delivery Added', '2022-12-28 22:36:18'),
(1111, 'admin', 'Delivery added/ product added', '2022-12-28 22:45:22'),
(1112, 'admin', 'Delivery Added', '2022-12-28 22:45:23'),
(1113, 'admin', 'Delivery added/ product added', '2022-12-28 22:49:41'),
(1114, 'admin', 'Delivery Added', '2022-12-28 22:49:41'),
(1115, 'admin', 'Delivery added/ product added', '2022-12-28 23:14:23'),
(1116, 'admin', 'Delivery added/ product added', '2022-12-29 10:33:31'),
(1117, 'admin', 'User admin login', '2022-12-29 10:44:21'),
(1118, 'admin', 'Delivery added/ product added', '2022-12-29 11:00:15'),
(1119, 'admin', 'Delivery Added', '2022-12-29 11:00:15'),
(1120, 'admin', 'User admin logout', '2022-12-29 13:09:58'),
(1121, 'admin', 'User admin login', '2022-12-29 13:10:03'),
(1122, 'admin', 'User admin logout', '2022-12-29 15:12:32'),
(1123, 'user', 'User user login', '2022-12-29 15:12:42');

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
('006', '153 kretek', '10500.00', 2, 'Slop', 1, '-', '-', NULL),
('013', 'MADU TJO-MADU TJ SACHET ORIGIN', '8404.20', 40, 'BOX', 6, '-', '-', NULL),
('014', 'BKACS-bumbu kaldu ayam cube sa', '16968.00', 200, 'RCG', 25, '-', '-', NULL),
('015', 'BKSCS-bumbu kaldu sapi cube sa', '16968.00', 200, 'RCG', 25, '-', '-', NULL),
('016', 'BISKUAT CHOCOLATE 20X151 2G PR', '134746.50', 100, 'PCS', 15, '-', '-', NULL),
('017', 'BISKUAT CHOCOLATE 12X (20X,6GR', '101298.75', 100, 'CRT', 15, '-', '-', NULL),
('018', 'OREO CHOCO CHOCO WAFER 24X140', '157653.30', 60, 'PCS', 10, '-', '-', NULL),
('019', 'OREO CHOCO VANILLA WAFER 24X14', '157653.30', 60, 'PCS', 10, '-', '-', NULL),
('020', 'OREO VANILLA 24X138G (119,6G', '157107.30', 60, 'PCS', 10, '-', '-', NULL),
('021', 'FULLO VANILA MILK 7GR', '59725.05', 100, 'PCS', 20, '-', '-', NULL),
('022', 'FULLO CHOCOLATE 7GR', '59725.05', 100, 'PCS', 20, '-', '-', NULL),
('023', 'FULLO BLACK VANILLA 14GR', '98319.90', 100, 'PCS', 20, '-', '-', NULL),
('024', 'BIHUN JAGUNG IDOLA 4*S', '55535.55', 50, 'BAG', 7, '-', '-', NULL),
('025', 'WATAMIE CHICKEN', '45311.70', 96, 'CAR', 10, '-', '-', NULL),
('026', 'WATAMIE SPICY', '45311.70', 96, 'CAR', 10, '-', '-', NULL),
('027', 'POPO CRUNCHY', '45071.25', 112, 'CAR', 20, '-', '-', NULL),
('028', 'KOLATOS', '44903.25', 112, 'CAR', 20, '-', '-', NULL),
('029', 'HATARI COCONUT 40 BKS 8X5X125G', '116655.00', 64, 'CRT', 12, '-', '-', NULL),
('030', 'HATARI CHOCOLATE 40BKS 8X5X125', '116655.00', 64, 'CRT', 12, '-', '-', NULL),
('031', 'PRENAGEN ENESIS STR 2006', '39423.30', 32, 'KLG', 5, '-', '-', NULL),
('032', 'PRENAGEN LACTA MOCHA 4006', '70735.35', 32, 'KLG', 5, '-', '-', NULL),
('033', 'CHIL KID PLAT VAN 200 6', '68169.15', 64, 'KLG', 8, '-', '-', NULL),
('034', 'SPKA70-MI INSTAN SUPERMI RASA', '59698.80', 192, 'CAR', 24, '-', '-', NULL),
('035', 'IKAP-S-IF KECAP ASIN SPECIAL P', '203616.00', 36, 'CAR', 4, '-', '-', NULL),
('1', 'Coffee', '12.00', 91, 'sachet', 20, '-', '-', NULL),
('10000', 'asdas', '25575.60', 21, 'KA', 29, NULL, NULL, NULL),
('1001', 'Glass', '22.00', 100, 'Box', 20, NULL, NULL, NULL),
('10011', 'Chair', '600.00', 198, 'Each', 20, NULL, NULL, NULL),
('10012', 'Sofa', '2400.00', 92, 'Each', 20, NULL, NULL, NULL),
('2', 'Tooth Paste', '24.00', 205, 'sachet', 10, '-', '-', NULL),
('23213', 'sdfsd', '42.24', 19, 'sdfsdf', 23, 'fdsfds', 'dffdf', NULL),
('3', 'Shampoo', '6.60', 148, 'sachet', 20, '-', '-', NULL),
('4', 'Soap', '17.25', 122, 'sachet', 20, '------', '-', NULL),
('5', 'Conditioner', '12.00', 100, 'sachet', 10, NULL, NULL, NULL),
('barcode1', 'Aqua 1,5 Liter', '405135.00', 275, '1', 310000, '-', '-', NULL),
('barcode10', 'Lenovo Ideapad 1550', '156002.00', 250, '1', 7810000, '-', '-,', NULL),
('barcode11', 'Aqua 1,5 Liter', '1350300.00', 250, '1', 460000, '-', '-', NULL),
('barcode2', 'Mouse Wireless Logitech M220', '270015.00', 250, '1', 1810000, '-', '-,', NULL),
('barcode3', 'Aqua 1,5 Liter', '125050.00', 250, '1', 260000, '-', '-', NULL),
('barcode4', 'Samsung Galaxy J1 Ace', '3120040.00', 250, '1', 7810000, '-', '-,', NULL),
('barcode5', 'Mouse Wireless Logitech M220', '67515.00', 250, '1', 460000, '-', '-,', NULL),
('barcode6', 'Samsung Galaxy J1 Ace', '23010.00', 250, '1', 240000, '-', '-,', NULL),
('barcode7', 'Lenovo Ideapad 1550', '60020.00', 250, '1', 310000, '-', '-,', NULL),
('barcode8', 'Aqua 1,5 Liter', '14400800.00', 250, '1', 1810000, '-', '-', NULL),
('barcode9', 'Samsung Galaxy J1 Ace', '25010.00', 250, '1', 260000, '-', '-,', NULL);

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
('63A8178B9262F', '1', 5, '10.00', 20),
('63AAE2067D99E', '1', 5, '10.00', 20),
('63AAE31E0064E', '1', 5, '10.00', 20),
('63AB36D34F31C', '1', 1, '10.00', 20),
('63AB388CE598A', '006', 1, '10000.00', 5),
('63AC3B1D79F6D', '1', 5, '10.00', 20),
('63AC3B1D79F6D', '2', 5, '20.00', 20),
('63AD0A800CB01', '025', 48, '43154.00', 5),
('63AD0A800CB01', '026', 48, '43154.00', 5),
('63AD0A800CB01', '027', 56, '42925.00', 5),
('63AD0A800CB01', '028', 56, '42765.00', 5),
('63AD0A800CB01', '029', 32, '111100.00', 5),
('63AD0A800CB01', '030', 32, '111100.00', 5),
('63AD0A800CB01', '031', 16, '37546.00', 5),
('63AD0A800CB01', '032', 16, '67367.00', 5),
('63AD0A800CB01', '033', 32, '64923.00', 5),
('63AD0A800CB01', '034', 96, '56856.00', 5),
('63AD0A800CB01', '035', 18, '193920.00', 5),
('63AD10803C498', '013', 20, '8004.00', 5),
('63AD10803C498', '014', 100, '16160.00', 5),
('63AD10803C498', '015', 100, '16160.00', 5),
('63AD10803C498', '016', 50, '128330.00', 5),
('63AD10803C498', '017', 50, '96475.00', 5),
('63AD10803C498', '018', 30, '150146.00', 5),
('63AD10803C498', '019', 30, '150146.00', 5),
('63AD10803C498', '020', 30, '149626.00', 5),
('63AD10803C498', '021', 50, '56881.00', 5),
('63AD10803C498', '022', 50, '56881.00', 5),
('63AD10803C498', '023', 50, '93638.00', 5),
('63AD10803C498', '024', 25, '52891.00', 5);

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
(23, 'Limbong Mula', 'Ricky', 'Simanjuntak', 'Panei Tongah, Kab. Simalungun', '082211804923', 'E_YqCK_VgAANr3-.jpg'),
(24, 'PT. INDOMARCO ADI PRIMA', 'Ahmad', 'Nasution', 'JL.JEND SUDIRMAN KAV 76-78 SetiaBudi JAKARTA SELATAN', '082211804888', 'E_YqCK_VgAANr3-.jpg'),
(26, 'PT. GLOBAL MITRA PRIMA', 'Bambang', 'Yudono', 'JL.LAU CIMBA ,RAMBUNG MERAH \\r\\nPEMATANG SIANTAR', '082211804981', 'E_YqCK_VgAANr3-.jpg');

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
('admin', NULL, NULL, NULL);

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
(13, 'user', 'Chris', 'Doemama', 'Employee', '082211804933', 'men-in-black.png', 'ee11cbb19052e40b07aac0ca060c23ee'),
(15, 'billywicaksono', 'Billy', 'Wicaksono', 'Employee', '082211804921', 'Screenshot 2022-07-22 225126.p', '7c30cd0dd3449665360c275cf14d6a3b');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1124;

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
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

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
