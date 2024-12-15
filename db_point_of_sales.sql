-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 15, 2024 at 12:33 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_point_of_sales`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_beli_d`
--

CREATE TABLE `tbl_beli_d` (
  `id_beli` bigint(20) NOT NULL,
  `no_faktur` varchar(15) NOT NULL,
  `id_produk` int(10) NOT NULL,
  `qty` mediumint(9) NOT NULL DEFAULT 0,
  `harga_beli` decimal(10,2) NOT NULL DEFAULT 0.00,
  `margin` decimal(10,2) NOT NULL DEFAULT 0.00,
  `nilai_margin` decimal(10,2) NOT NULL DEFAULT 0.00,
  `harga_pokok` decimal(10,2) NOT NULL DEFAULT 0.00,
  `harga_jual` decimal(10,2) NOT NULL DEFAULT 0.00,
  `diskon` decimal(4,2) NOT NULL DEFAULT 0.00,
  `nilai_diskon` decimal(10,2) NOT NULL,
  `sub_total` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_beli_d`
--

INSERT INTO `tbl_beli_d` (`id_beli`, `no_faktur`, `id_produk`, `qty`, `harga_beli`, `margin`, `nilai_margin`, `harga_pokok`, `harga_jual`, `diskon`, `nilai_diskon`, `sub_total`) VALUES
(1, '1', 1, 5, 7000000.00, 0.00, 0.00, 0.00, 0.00, 10.00, 350000.00, 6650000.00),
(2, '1', 2, 10, 150000.00, 0.00, 0.00, 0.00, 0.00, 5.00, 75000.00, 1425000.00),
(3, '4', 2, 7, 500000.00, 0.00, 0.00, 0.00, 0.00, 8.00, 28000.00, 4600.00),
(4, '3', 2, 3, 2000000.00, 0.00, 0.00, 0.00, 0.00, 12.00, 720000.00, 5280000.00),
(5, '3', 1, 4, 1500000.00, 0.00, 0.00, 0.00, 0.00, 6.00, 90000.00, 5940000.00),
(6, '1', 1, 6, 750000.00, 0.00, 0.00, 0.00, 0.00, 7.00, 315000.00, 4200000.00),
(7, '3', 2, 20, 80000.00, 0.00, 0.00, 0.00, 0.00, 3.00, 48000.00, 1552000.00),
(8, '4', 2, 2, 10000000.00, 0.00, 0.00, 0.00, 0.00, 15.00, 1500000.00, 18500000.00),
(9, '1', 1, 8, 350000.00, 0.00, 0.00, 0.00, 0.00, 5.00, 140000.00, 2660000.00),
(10, '4', 2, 15, 450000.00, 0.00, 0.00, 0.00, 0.00, 5.00, 675000.00, 6300000.00);

--
-- Triggers `tbl_beli_d`
--
DELIMITER $$
CREATE TRIGGER `trg_beli_hapus` BEFORE DELETE ON `tbl_beli_d` FOR EACH ROW BEGIN
	UPDATE tbl_produk_stok SET beli=beli-old.qty Where id_produk=old.id_produk;
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_beli_tambah` AFTER INSERT ON `tbl_beli_d` FOR EACH ROW BEGIN
	-- Periksa apakah sudan ada ID produk pada tabel tbl_produk_stok 
	IF EXISTS (SELECT id_produk FROM tbl_produk_stok WHERE id_produk=new.id_produk) THEN 
		-- Jika sudah ada maka Update field beli 
		UPDATE tbl_produk_stok SET beli=beli+new.qty WHERE id_produk=new.id_produk;
	ELSE -- Jika belum ada ID Produk 
		-- Tambahkan produk Baru dengan nilai field beli - qty 
		INSERT INTO tbl_produk_stok (id_produk, saldo, beli, jual) 
		VALUES (new.id_produk, 0,new.qty,0); 
	END IF;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_beli_m`
--

CREATE TABLE `tbl_beli_m` (
  `no_faktur` varchar(15) NOT NULL,
  `tgl_faktur` date DEFAULT NULL,
  `id_supp` int(6) NOT NULL,
  `no_bukti` varchar(15) DEFAULT NULL,
  `total_beli` decimal(10,2) NOT NULL DEFAULT 0.00,
  `potongan` decimal(10,2) NOT NULL DEFAULT 0.00,
  `biaya_lain` decimal(10,2) NOT NULL DEFAULT 0.00,
  `ppn` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'nilai pajak',
  `total_bersih` decimal(10,2) NOT NULL DEFAULT 0.00,
  `stts_bayar` smallint(1) NOT NULL DEFAULT 1 COMMENT 'in Tunai,or Kredit',
  `term` smallint(1) NOT NULL DEFAULT 0,
  `tgl_jt` date DEFAULT NULL,
  `stts_beli` smallint(1) NOT NULL DEFAULT 1,
  `created_date` date DEFAULT NULL,
  `created_by` varchar(25) DEFAULT NULL,
  `update_date` date DEFAULT NULL,
  `update_by` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_beli_m`
--

INSERT INTO `tbl_beli_m` (`no_faktur`, `tgl_faktur`, `id_supp`, `no_bukti`, `total_beli`, `potongan`, `biaya_lain`, `ppn`, `total_bersih`, `stts_bayar`, `term`, `tgl_jt`, `stts_beli`, `created_date`, `created_by`, `update_date`, `update_by`) VALUES
('1', '2024-10-10', 1, NULL, 500000.00, 25000.00, 10000.00, 50000.00, 515000.00, 1, 0, '2024-11-10', 1, '2024-10-10', 'admin', '2024-10-11', 'admin'),
('2', '2024-10-11', 2, NULL, 300000.00, 15000.00, 5000.00, 30000.00, 320000.00, 0, 0, '2024-11-11', 0, '2024-10-11', 'staff1', '2024-10-12', 'staff1'),
('3', '2024-10-12', 3, NULL, 750000.00, 50000.00, 20000.00, 75000.00, 745000.00, 1, 0, '2024-11-12', 1, '2024-10-12', 'admin', '2024-10-12', 'admin'),
('4', '2024-10-13', 4, NULL, 450000.00, 22500.00, 15000.00, 45000.00, 487500.00, 0, 0, '2024-11-13', 0, '2024-10-13', 'staff2', '2024-10-13', 'staff2'),
('5', '2024-10-14', 5, NULL, 600000.00, 30000.00, 10000.00, 60000.00, 640000.00, 1, 0, '2024-11-14', 1, '2024-10-14', 'admin', '2024-10-14', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_m_kategori`
--

CREATE TABLE `tbl_m_kategori` (
  `id_kategori` int(6) NOT NULL,
  `nama_kategori` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_m_kategori`
--

INSERT INTO `tbl_m_kategori` (`id_kategori`, `nama_kategori`) VALUES
(2, 'Minuman'),
(4, 'Obat-obatan'),
(5, 'Rokok'),
(6, 'Mainan'),
(7, 'Cemilan'),
(17, 'Makanan'),
(21, 'Perabotan');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_m_produk`
--

CREATE TABLE `tbl_m_produk` (
  `id_produk` int(11) NOT NULL,
  `nama_produk` varchar(100) NOT NULL,
  `id_kategori` int(6) NOT NULL,
  `id_satuan` int(6) NOT NULL,
  `barcode` varchar(10) DEFAULT NULL,
  `harga_beli` decimal(10,2) NOT NULL DEFAULT 0.00,
  `harga_pokok` decimal(10,2) NOT NULL DEFAULT 0.00,
  `harga_jual` decimal(10,2) DEFAULT 0.00,
  `is_status` smallint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_m_produk`
--

INSERT INTO `tbl_m_produk` (`id_produk`, `nama_produk`, `id_kategori`, `id_satuan`, `barcode`, `harga_beli`, `harga_pokok`, `harga_jual`, `is_status`) VALUES
(1, 'Teh Pucuk Super Murah', 2, 2, '#tehpucuk', 5000.00, 5000.00, 80000.00, 0),
(2, 'Chitos', 7, 6, '#chitos', 3000.00, 3000.00, 6000.00, 1),
(9, 'Chitato', 6, 6, '#chitato', 8000.00, 8000.00, 16000.00, 1),
(2000003, 'Pocari', 2, 2, '#Pocari', 6000.00, 6000.00, 9000.00, 1),
(4000001, 'Bodrex', 4, 4, '#bodrex', 3000.00, 3000.00, 6000.00, 1),
(5000001, 'Pikachu', 6, 4, '#pikachu', 23000.00, 23000.00, 30000.00, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_m_satuan`
--

CREATE TABLE `tbl_m_satuan` (
  `id_satuan` int(6) NOT NULL,
  `nama_satuan` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_m_satuan`
--

INSERT INTO `tbl_m_satuan` (`id_satuan`, `nama_satuan`) VALUES
(1, 'kilogram'),
(2, 'botol'),
(3, 'gram'),
(4, 'pcs'),
(5, 'batang'),
(6, 'bungkus'),
(11, 'ekor'),
(12, 'piring');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_m_supplier`
--

CREATE TABLE `tbl_m_supplier` (
  `id_supp` int(6) NOT NULL,
  `jenis` varchar(35) NOT NULL,
  `nama_supp` varchar(35) NOT NULL,
  `kontak_person` varchar(35) DEFAULT NULL,
  `no_kontak` varchar(12) DEFAULT NULL,
  `alamat` varchar(100) DEFAULT NULL,
  `kota` varchar(35) DEFAULT NULL,
  `email` varchar(25) DEFAULT NULL,
  `no_telp` varchar(15) DEFAULT NULL,
  `no_fax` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_m_supplier`
--

INSERT INTO `tbl_m_supplier` (`id_supp`, `jenis`, `nama_supp`, `kontak_person`, `no_kontak`, `alamat`, `kota`, `email`, `no_telp`, `no_fax`) VALUES
(1, 'Perabotan', 'Aneka Perabotan', 'Rudi', '081234567890', 'Jl. Negara No.67', 'Medan', 'anekaperabotan@gmail.com', '081234567890', '1'),
(2, 'Elektonik', 'Toko Elektronik Jaya', 'Siti', '081987654321', 'Jl. Karya No.21', 'Jakarta', 'tokoelektronikjaya@gmail.', '081987654321', '2'),
(3, 'Pakaian', 'Busana Indah', 'Budi', '081234999888', 'Jl. Mawar No.56', 'Surabaya', 'busanaindah@gmail.com', '081234999888', '3'),
(4, 'Makanan', 'Toko Kue Manis', 'Ani', '081345678901', 'Jl. Bunga No.33', 'Bandung', 'tokokuemanis@gmail.com', '081345678901', '4'),
(5, 'Kesehatan', 'Apotek Sehat', 'Yanto', '081567890123', 'Jl. Merdeka No.10', 'Yogyakarta', 'apoteksehat@gmail.com', '081567890123', '5'),
(6, 'Otomotif', 'Bengkel Mobil Lestari', 'Rina', '081234567800', 'Jl. Raya Barat No.12', 'Makassar', 'bengkelmobil@gmail.com', '081234567800', '6'),
(7, 'Mainan', 'Dunia Mainan', 'Sari', '081345123456', 'Jl. Pahlawan No.9', 'Denpasar', 'duniamainan@gmail.com', '081345123456', '7'),
(8, 'Olahraga', 'Sport Center', 'Joko', '081234567812', 'Jl. Kebun No.45', 'Medan', 'sportcenter@gmail.com', '081234567812', '8'),
(9, 'Perhiasan', 'Emas Cantik', 'Dewi', '081987654333', 'Jl. Cendana No.8', 'Semarang', 'emascantik@gmail.com', '081987654333', '9'),
(10, 'Kosmetik', 'Toko Kecantikan', 'Nina', '081345678899', 'Jl. Melati No.20', 'Palembang', 'tokokecantikan@gmail.com', '081345678899', '10');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_produk_kartu_stok`
--

CREATE TABLE `tbl_produk_kartu_stok` (
  `id_kartu` bigint(20) NOT NULL,
  `tanggal` date NOT NULL,
  `no_ref` varchar(15) NOT NULL COMMENT 'nomor transaksi',
  `id_produk` int(20) NOT NULL,
  `transaksi` varchar(25) NOT NULL COMMENT 'jenis transaksi',
  `is_dk` smallint(1) NOT NULL DEFAULT 0 COMMENT '0: Masuk, 1: Keluar',
  `harga` decimal(10,2) NOT NULL DEFAULT 0.00,
  `qty` mediumint(9) NOT NULL DEFAULT 0,
  `keterangan` mediumint(9) NOT NULL DEFAULT 0,
  `edit_by` varchar(25) NOT NULL DEFAULT 'Admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_produk_stok`
--

CREATE TABLE `tbl_produk_stok` (
  `id_stok` bigint(20) NOT NULL,
  `id_produk` int(20) NOT NULL,
  `saldo` int(11) DEFAULT NULL,
  `beli` int(11) DEFAULT NULL,
  `jual` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_beli_d`
--
ALTER TABLE `tbl_beli_d`
  ADD PRIMARY KEY (`id_beli`),
  ADD KEY `no_faktur` (`no_faktur`),
  ADD KEY `id_produk` (`id_produk`);

--
-- Indexes for table `tbl_beli_m`
--
ALTER TABLE `tbl_beli_m`
  ADD PRIMARY KEY (`no_faktur`),
  ADD KEY `id_supp` (`id_supp`);

--
-- Indexes for table `tbl_m_kategori`
--
ALTER TABLE `tbl_m_kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indexes for table `tbl_m_produk`
--
ALTER TABLE `tbl_m_produk`
  ADD PRIMARY KEY (`id_produk`),
  ADD KEY `id_kategori` (`id_kategori`),
  ADD KEY `id_satuan` (`id_satuan`);

--
-- Indexes for table `tbl_m_satuan`
--
ALTER TABLE `tbl_m_satuan`
  ADD PRIMARY KEY (`id_satuan`);

--
-- Indexes for table `tbl_m_supplier`
--
ALTER TABLE `tbl_m_supplier`
  ADD PRIMARY KEY (`id_supp`);

--
-- Indexes for table `tbl_produk_kartu_stok`
--
ALTER TABLE `tbl_produk_kartu_stok`
  ADD PRIMARY KEY (`id_kartu`);

--
-- Indexes for table `tbl_produk_stok`
--
ALTER TABLE `tbl_produk_stok`
  ADD PRIMARY KEY (`id_stok`),
  ADD KEY `id_produk` (`id_produk`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_beli_d`
--
ALTER TABLE `tbl_beli_d`
  MODIFY `id_beli` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `tbl_m_kategori`
--
ALTER TABLE `tbl_m_kategori`
  MODIFY `id_kategori` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `tbl_m_produk`
--
ALTER TABLE `tbl_m_produk`
  MODIFY `id_produk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21000002;

--
-- AUTO_INCREMENT for table `tbl_m_satuan`
--
ALTER TABLE `tbl_m_satuan`
  MODIFY `id_satuan` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tbl_m_supplier`
--
ALTER TABLE `tbl_m_supplier`
  MODIFY `id_supp` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tbl_produk_kartu_stok`
--
ALTER TABLE `tbl_produk_kartu_stok`
  MODIFY `id_kartu` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_produk_stok`
--
ALTER TABLE `tbl_produk_stok`
  MODIFY `id_stok` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_beli_d`
--
ALTER TABLE `tbl_beli_d`
  ADD CONSTRAINT `tbl_beli_d_ibfk_1` FOREIGN KEY (`no_faktur`) REFERENCES `tbl_beli_m` (`no_faktur`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_beli_d_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `tbl_m_produk` (`id_produk`) ON UPDATE CASCADE;

--
-- Constraints for table `tbl_beli_m`
--
ALTER TABLE `tbl_beli_m`
  ADD CONSTRAINT `tbl_beli_m_ibfk_1` FOREIGN KEY (`id_supp`) REFERENCES `tbl_m_supplier` (`id_supp`) ON UPDATE CASCADE;

--
-- Constraints for table `tbl_m_produk`
--
ALTER TABLE `tbl_m_produk`
  ADD CONSTRAINT `tbl_m_produk_ibfk_1` FOREIGN KEY (`id_kategori`) REFERENCES `tbl_m_kategori` (`id_kategori`) ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_m_produk_ibfk_2` FOREIGN KEY (`id_satuan`) REFERENCES `tbl_m_satuan` (`id_satuan`) ON UPDATE CASCADE;

--
-- Constraints for table `tbl_produk_stok`
--
ALTER TABLE `tbl_produk_stok`
  ADD CONSTRAINT `tbl_produk_stok_ibfk_1` FOREIGN KEY (`id_produk`) REFERENCES `tbl_m_produk` (`id_produk`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
