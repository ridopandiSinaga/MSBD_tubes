-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 23 Des 2022 pada 04.14
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
-- Database: `pointofsale`
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
CREATE DEFINER=`root`@`localhost` FUNCTION `count_by_id` (`table_name` VARCHAR(25)) RETURNS INT(20)  BEGIN
DECLARE a INT(10);
SET a = IFNULL((SELECT COUNT(table_id) AS total FROM table_name),"0") ;
RETURN a;
END$$

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
(16, 'jersel', 'Bill', 'Philippines', '082211804772', 'user.png'),
(17, 'ridopandi', 'sinaga', 'Pariksabungan\r\nSipintuangin', '082211804921', 'Ambassador-pana.png'),
(18, 'Bayu', 'Permata', 'Pariksabungan\r\nSipintuangin', '082211804921', 'Ambassador-pana.png'),
(19, 'Eru erlangga', 'nasution', 'Pariksabungan\r\nSipintuangin', '082211804921', '2022-12-19 (3).png');

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
('639B28F949118', 23, 'admin', '2022-12-15 21:04:28');

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
(892, 'admin', 'User admin login', '2022-12-05 16:33:07'),
(893, 'admin', 'User admin login', '2022-12-05 17:11:34'),
(895, 'admin', 'Customer limbong Added', '2022-12-05 17:23:48'),
(896, 'admin', 'User admin logout', '2022-12-05 17:47:37'),
(897, 'admin', 'User admin login', '2022-12-05 17:47:50'),
(898, 'admin', 'User admin login', '2022-12-05 17:49:26'),
(899, 'admin', 'User admin logout', '2022-12-05 17:52:23'),
(900, 'admin', 'User admin login', '2022-12-05 17:52:55'),
(901, 'admin', 'User admin login', '2022-12-05 18:05:18'),
(902, 'admin', 'User admin login', '2022-12-05 18:09:08'),
(903, 'admin', 'Product 153 kretek updated', '2022-12-05 18:16:25'),
(904, 'admin', 'Product Surya 16 updated', '2022-12-05 18:18:07'),
(905, 'admin', 'Product Surya 12 updated', '2022-12-05 18:21:39'),
(906, 'admin', 'Product Sampoerna Mild 16 upda', '2022-12-05 18:22:30'),
(907, 'admin', 'Product Magnum Hitam 12 update', '2022-12-05 18:23:46'),
(908, 'admin', 'User admin login', '2022-12-05 18:42:23'),
(909, 'admin', 'Product sold', '2022-12-05 18:44:22'),
(910, 'admin', 'Product 153 kretek updated', '2022-12-05 18:46:28'),
(911, 'admin', 'User admin login', '2022-12-05 19:01:22'),
(912, 'admin', 'User admin login', '2022-12-05 21:58:59'),
(913, 'admin', 'User admin logout', '2022-12-05 22:52:41'),
(914, 'admin', 'User admin login', '2022-12-05 22:52:52'),
(916, 'admin', 'User admin logout', '2022-12-05 22:57:04'),
(917, 'ridopandi', 'User ridopandi login', '2022-12-05 22:57:19'),
(919, 'ridopandi', 'Product sold', '2022-12-05 23:01:27'),
(920, 'admin', 'User admin login', '2022-12-05 23:17:03'),
(922, 'admin', 'User admin login', '2022-12-06 03:29:17'),
(923, 'admin', 'Product 153 kretek updated', '2022-12-06 03:32:37'),
(924, 'admin', 'Product 153 kretek updated', '2022-12-06 03:35:55'),
(925, 'admin', 'User admin logout', '2022-12-06 04:47:59'),
(926, 'admin', 'User admin login', '2022-12-06 04:48:09'),
(927, 'admin', 'User admin login', '2022-12-12 23:22:40'),
(928, 'admin', 'User admin login', '2022-12-15 11:05:30'),
(929, 'admin', 'User admin login', '2022-12-15 11:34:06'),
(930, 'admin', 'User admin login', '2022-12-15 11:43:49'),
(931, 'admin', 'Product Surya 12 updated', '2022-12-15 12:38:02'),
(932, 'admin', 'User admin login', '2022-12-15 18:07:54'),
(933, 'admin', 'Product Sampoerna Mild 16 upda', '2022-12-15 18:57:05'),
(934, 'admin', 'Product Surya 12 updated', '2022-12-15 18:57:17'),
(935, 'admin', 'Product Surya 16 updated', '2022-12-15 18:57:23'),
(936, 'admin', 'Product 153 kretek updated', '2022-12-15 18:57:35'),
(937, 'admin', 'Delivery Added', '2022-12-15 21:04:28'),
(939, 'admin', 'User admin logout', '2022-12-16 00:31:37'),
(940, 'admin', 'User admin login', '2022-12-16 00:31:53'),
(942, 'admin', 'User admin logout', '2022-12-16 00:33:47'),
(943, 'tito', 'User tito login', '2022-12-16 00:34:03'),
(944, 'admin', 'User admin login', '2022-12-16 23:51:49'),
(945, 'admin', 'User admin login', '2022-12-17 13:08:29'),
(946, 'admin', 'User admin login', '2022-12-17 20:57:48'),
(947, 'admin', 'User admin login', '2022-12-18 12:58:10'),
(948, 'admin', 'User admin login', '2022-12-19 02:17:01'),
(949, 'admin', 'User admin login', '2022-12-19 09:12:09'),
(950, 'admin', 'User admin login', '2022-12-19 12:37:39'),
(951, 'admin', 'User admin login', '2022-12-20 11:06:45'),
(952, 'admin', 'User admin logout', '2022-12-20 19:53:05'),
(953, 'user', 'User user login', '2022-12-20 19:54:19'),
(954, 'user', 'Product sold', '2022-12-20 19:55:36'),
(955, 'user', 'User user logout', '2022-12-20 19:56:00'),
(956, 'user', 'User user login', '2022-12-20 19:56:11'),
(957, 'user', 'User user logout', '2022-12-20 20:31:56'),
(958, 'admin', 'User admin login', '2022-12-20 20:32:01'),
(959, 'admin', 'User admin logout', '2022-12-20 23:01:30'),
(960, 'user', 'User user login', '2022-12-20 23:01:40'),
(961, 'user', 'User user logout', '2022-12-20 23:03:10'),
(962, 'admin', 'User admin login', '2022-12-20 23:03:15'),
(963, 'admin', 'User admin logout', '2022-12-20 23:17:58'),
(964, 'user', 'User user login', '2022-12-20 23:18:07'),
(965, 'user', 'User user logout', '2022-12-21 01:44:02'),
(966, 'admin', 'User admin login', '2022-12-21 01:44:08'),
(967, 'admin', 'User admin login', '2022-12-21 12:33:10'),
(968, 'admin', 'User admin login', '2022-12-21 15:23:05'),
(969, 'admin', 'User admin logout', '2022-12-21 19:24:51'),
(970, 'user', 'User user login', '2022-12-21 19:25:01'),
(971, 'user', 'User user logout', '2022-12-21 19:36:38'),
(972, 'admin', 'User admin login', '2022-12-21 19:36:43'),
(973, 'admin', 'User admin login', '2022-12-22 21:47:25'),
(974, 'admin', 'User admin logout', '2022-12-22 21:48:22'),
(975, 'admin', 'User admin login', '2022-12-22 21:53:15'),
(976, 'admin', 'User admin logout', '2022-12-22 21:57:24'),
(977, 'admin', 'User admin login', '2022-12-22 21:59:14'),
(978, 'admin', 'User admin logout', '2022-12-22 23:52:20'),
(979, 'admin', 'User admin login', '2022-12-22 23:52:29');

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
('1', '153 kretek', '120000.00', 100, 'Slop', 10, 'sfdsfdsf', 'fsdfdsfdsfd', NULL),
('10000', 'asdas', '25575.60', 21, 'KA', 29, NULL, NULL, NULL),
('1001', 'Glass', '22.00', 100, 'Box', 20, NULL, NULL, NULL),
('10011', 'Chair', '600.00', 198, 'Each', 20, NULL, NULL, NULL),
('10012', 'Sofa', '2400.00', 91, 'Each', 20, NULL, NULL, NULL),
('2', 'Surya 16', '256000.00', 18, 'Slop', 10, '-', '-', NULL),
('23213', 'sdfsd', '42.24', 18, 'sdfsdf', 23, 'fdsfds', 'dffdf', NULL),
('3', 'Surya 12', '200500.00', 2, 'Slop', 10, '-', '-', NULL);

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
('639B28F949118', '3', 3, '6.00', 10);

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
(20, 16, 'admin', 0, 0, '2019-03-27 17:00:00'),
(21, 16, 'admin', 0, 0, '2019-04-08 12:29:27'),
(22, 16, 'admin', 0, 0, '2020-03-28 06:06:26'),
(23, 16, 'admin', 0, 0, '2020-03-28 06:07:27'),
(24, 16, 'admin', 0, 0, '2020-03-28 06:08:08'),
(25, 16, 'admin', 10, 0, '2020-03-28 06:14:46'),
(26, 16, 'admin', 10, 0, '2020-03-28 06:22:55'),
(27, 16, 'admin', 10, 2160, '2020-03-28 06:27:51'),
(28, 16, 'admin', 20, 1920, '2020-03-28 08:14:30'),
(29, 16, 'admin', 20, 4017, '2020-03-30 01:07:10'),
(30, 17, 'admin', 0, 893500, '2022-12-05 11:44:22'),
(31, 18, 'ridopandi', 0, 3408500, '2022-12-05 16:01:27'),
(32, 17, 'user', 0, 458942, '2022-12-20 12:55:36');

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
(29, '23213', '42.24', 4),
(30, '4', '256500.00', 1),
(30, '5', '180500.00', 1),
(30, '2', '256000.00', 1),
(30, '3', '200500.00', 1),
(31, '3', '200500.00', 17),
(32, '3', '200500.00', 1),
(32, '2', '256000.00', 1),
(32, '10012', '2400.00', 1),
(32, '23213', '42.24', 1);

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
(21, 'OrangeCompany', 'Oracle', 'LTD', 'USA', '082245456751', 'Internship-Web-Graphic-01.png'),
(22, 'BrandName', 'Bill', 'Joe', 'Africa', '082245456741', 'multi-user-icon.png'),
(23, 'Limbong Mula', 'limbong', 'mula', 'siantar', '082211804931', 'Ambassador-pana.png');

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
(7, 'admin', 'Juan', 'Cruz', 'admin', '+63(09)1234-1234', 'Myprofile.jpg', '21232f297a57a5a743894a0e4a801fc3'),
(13, 'user', 'Chris', 'Doe', 'Employee', '+63(09)1234-1234', 'men-in-black.png', 'ee11cbb19052e40b07aac0ca060c23ee'),
(15, 'ridopandi', 'rido', 'pandi', 'Employee', '+99(99)9999-9999', 'Ambassador-pana.png', '9d3aa98720813362b99c5626db91186c'),
(16, 'tito', 'tito', 'trinidad', 'Employee', '+99(99)9999-9999', '17378.jpg', '5a5831b9bc64bc5bad1eebcceb4b24ba');

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
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT untuk tabel `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=981;

--
-- AUTO_INCREMENT untuk tabel `sales`
--
ALTER TABLE `sales`
  MODIFY `reciept_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT untuk tabel `sales_product`
--
ALTER TABLE `sales_product`
  MODIFY `reciept_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT untuk tabel `supplier`
--
ALTER TABLE `supplier`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

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
-- Ketidakleluasaan untuk tabel `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`);

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
