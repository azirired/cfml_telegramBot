-- phpMyAdmin SQL Dump
-- version 3.5.7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 19, 2017 at 04:06 PM
-- Server version: 5.5.29
-- PHP Version: 5.4.10

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `telegramBot`
--

-- --------------------------------------------------------
--
-- Table structure for table `tbl_appointment`
--

CREATE TABLE `tbl_appointment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Date_App` datetime DEFAULT NULL,
  `masa` time DEFAULT NULL,
  `subject` varchar(150) DEFAULT NULL,
  `lokasi` varchar(150) DEFAULT NULL,
  `notes` varchar(250) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `entryBy` varchar(20) DEFAULT NULL,
  `uuidPos` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_commandPos`
--

CREATE TABLE `tbl_commandPos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `telegram_id` varchar(50) DEFAULT NULL,
  `tkh_state` datetime DEFAULT NULL,
  `commandTxt` varchar(20) DEFAULT NULL,
  `uuidPos` varchar(40) DEFAULT NULL,
  `temptxt` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_daftar`
--

CREATE TABLE `tbl_daftar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `noic` varchar(12) DEFAULT NULL,
  `telegram_id` varchar(50) NOT NULL,
  `telegram_firstname` varchar(150) DEFAULT NULL,
  `tkh_register` datetime DEFAULT NULL,
  `uuid` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;


-- --------------------------------------------------------

--
-- Table structure for table `tbl_pegawai`
--

CREATE TABLE `tbl_pegawai` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `noic` varchar(15) DEFAULT NULL,
  `nama` varchar(150) DEFAULT NULL,
  `tel` varchar(50) DEFAULT NULL,
  `emel` varchar(100) DEFAULT NULL,
  `userType` varchar(10) DEFAULT NULL,
  `responseTo` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=21 ;

--
-- Dumping data for table `tbl_pegawai`
--

INSERT INTO `tbl_pegawai` (`id`, `noic`, `nama`, `tel`, `emel`, `userType`, `responseTo`) VALUES
(2, '7472', 'Muhammad', '7472', 'muhammad@gmail.my', 'Admin', '');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_permohonan`
--

CREATE TABLE `tbl_permohonan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `perkara` varchar(250) DEFAULT NULL,
  `kelulusan` int(11) DEFAULT NULL,
  `tarikh_lulus` date DEFAULT NULL,
  `telegram_pelulus` varchar(20) DEFAULT NULL,
  `telegram_pemohon` varchar(20) DEFAULT NULL,
  `uuid` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;
