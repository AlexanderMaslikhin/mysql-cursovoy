CREATE DATABASE  IF NOT EXISTS `gb_mysql_curs` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `gb_mysql_curs`;
-- MySQL dump 10.13  Distrib 8.0.12, for macos10.13 (x86_64)
--
-- Host: localhost    Database: gb_mysql_curs
-- ------------------------------------------------------
-- Server version	8.0.29-0ubuntu0.20.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `abonents`
--

DROP TABLE IF EXISTS `abonents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `abonents` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(100) NOT NULL,
  `midname` varchar(100) DEFAULT NULL,
  `lastname` varchar(100) NOT NULL,
  `gender` enum('f','m') DEFAULT NULL,
  `document_type_id` tinyint unsigned NOT NULL,
  `document_number` varchar(30) DEFAULT NULL,
  `document_address` varchar(200) DEFAULT NULL,
  `phone` char(11) NOT NULL,
  `birthday` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `document_number` (`document_number`),
  KEY `document_type_id` (`document_type_id`),
  CONSTRAINT `abonents_ibfk_1` FOREIGN KEY (`document_type_id`) REFERENCES `document_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `abonents`
--

LOCK TABLES `abonents` WRITE;
/*!40000 ALTER TABLE `abonents` DISABLE KEYS */;
INSERT INTO `abonents` VALUES (1,'????????','????????????????','??????????????','m',1,'1234 123456','????????????, ????. ????????????, 25-20','79001234567','1990-10-10'),(2,'??????????','????????????????','????????????','m',1,'3245 654123','??. ??????????????????????????','79020010203','1960-12-10'),(3,'??????????','??????????????????','??????????????????','m',1,'1209 120987','??. ????????????????','79331230933','1976-09-12'),(4,'??????????????','????????????????','????????????????','m',2,'12 234 1234 5','??. ????????????, ????. ????????????????, ??29, ???? 12','79835461034','2000-01-10'),(5,'??????????','????????????????????','????????????????','f',1,'7402 324593','??????????????????, ????. ????????????????, 101-30','79223451265','1998-07-18');
/*!40000 ALTER TABLE `abonents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_payments`
--

DROP TABLE IF EXISTS `account_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `account_payments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned NOT NULL,
  `value` decimal(10,0) NOT NULL DEFAULT '0',
  `agent_id` bigint unsigned DEFAULT NULL,
  `pay_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `account_id` (`account_id`),
  KEY `agent_id` (`agent_id`),
  CONSTRAINT `account_payments_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `account_payments_ibfk_2` FOREIGN KEY (`agent_id`) REFERENCES `payment_agents` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_payments`
--

LOCK TABLES `account_payments` WRITE;
/*!40000 ALTER TABLE `account_payments` DISABLE KEYS */;
INSERT INTO `account_payments` VALUES (1,1,500,2,'2022-04-26 09:43:55'),(2,2,1500,4,'2022-04-26 09:43:55'),(3,3,500,3,'2022-04-26 09:43:55'),(4,7,250,2,'2022-04-26 09:43:55'),(5,5,3000,1,'2022-04-26 09:43:55'),(6,4,500,1,'2022-04-26 09:43:55'),(7,6,1000,3,'2022-04-26 09:43:55');
/*!40000 ALTER TABLE `account_payments` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sasha`@`%`*/ /*!50003 TRIGGER `add_money_trigger` AFTER INSERT ON `account_payments` FOR EACH ROW UPDATE accounts SET money_balance = money_balance + NEW.value WHERE accounts.id = NEW.account_id; */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `accounts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `contract` varchar(30) NOT NULL,
  `abonent_id` bigint unsigned NOT NULL,
  `login` varchar(50) NOT NULL,
  `pass_hash` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `contract_address_id` bigint unsigned DEFAULT NULL,
  `money_balance` decimal(10,0) DEFAULT NULL,
  `current_tariff_id` bigint unsigned DEFAULT NULL,
  `next_tariff_id` bigint unsigned NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `contract` (`contract`),
  UNIQUE KEY `login` (`login`),
  KEY `abonent_id` (`abonent_id`),
  KEY `contract_address_id` (`contract_address_id`),
  KEY `current_tariff_id` (`current_tariff_id`),
  KEY `next_tariff_id` (`next_tariff_id`),
  CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`abonent_id`) REFERENCES `abonents` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `accounts_ibfk_2` FOREIGN KEY (`contract_address_id`) REFERENCES `connected_addresses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `accounts_ibfk_3` FOREIGN KEY (`current_tariff_id`) REFERENCES `tariffs` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `accounts_ibfk_4` FOREIGN KEY (`next_tariff_id`) REFERENCES `tariffs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'1',1,'login1','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','2022-04-26 06:33:47','2022-05-04 07:19:53',3,500,2,2,1),(2,'2',5,'login2','114bd151f8fb0c58642d2170da4ae7d7c57977260ac2cc8905306cab6b2acabc','2022-04-26 06:44:11','2022-05-04 07:19:53',6,1500,3,3,1),(3,'3',5,'login3','114bd151f8fb0c58642d2170da4ae7d7c57977260ac2cc8905306cab6b2acabc','2022-04-26 06:44:11','2022-05-04 07:19:53',7,500,1,1,1),(4,'4',2,'login4','ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad','2022-04-26 06:48:34','2022-05-04 07:19:53',4,300,1,1,1),(5,'5',3,'login5','cb8379ac2098aa165029e3938a51da0bcecfc008fd6795f401178647f96c5b34','2022-04-26 06:48:34','2022-05-04 07:19:53',1,2500,4,4,1),(6,'6',3,'login6','cb8379ac2098aa165029e3938a51da0bcecfc008fd6795f401178647f96c5b34','2022-04-26 06:48:34','2022-05-04 07:19:53',2,1000,4,4,1),(7,'7',4,'login7','b14369d34fcb01880a94f04118c20e872b89a73961815d9dfa8b3c851d0d5bac','2022-04-26 06:48:34','2022-05-04 07:19:53',5,250,1,1,1),(8,'8',4,'login8','b14369d34fcb01880a94f04118c20e872b89a73961815d9dfa8b3c851d0d5bac','2022-05-04 15:03:37','2022-05-04 15:03:37',9,100,2,2,1);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sasha`@`%`*/ /*!50003 TRIGGER `insert_account` AFTER INSERT ON `accounts` FOR EACH ROW BEGIN
	DECLARE new_date DATE;
    SET new_date = add_tariff_period(NEW.current_tariff_id);
    INSERT INTO tariffs_write_offs VALUES (NEW.id, new_date);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `accounts_services_write_offs`
--

DROP TABLE IF EXISTS `accounts_services_write_offs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `accounts_services_write_offs` (
  `account_id` bigint unsigned NOT NULL,
  `service_id` bigint unsigned NOT NULL,
  `activated_at` date NOT NULL,
  `next_write_off_at` date NOT NULL,
  PRIMARY KEY (`account_id`,`service_id`),
  KEY `next_write_off_at` (`next_write_off_at`),
  KEY `service_id` (`service_id`),
  CONSTRAINT `accounts_services_write_offs_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `accounts_services_write_offs_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_services_write_offs`
--

LOCK TABLES `accounts_services_write_offs` WRITE;
/*!40000 ALTER TABLE `accounts_services_write_offs` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts_services_write_offs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `blocked_accounts`
--

DROP TABLE IF EXISTS `blocked_accounts`;
/*!50001 DROP VIEW IF EXISTS `blocked_accounts`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `blocked_accounts` AS SELECT 
 1 AS `fio`,
 1 AS `CONCAT(h.street, ", ??.", h.house_num, ", ????.", ca.flat_no)`,
 1 AS `contract`,
 1 AS `login`,
 1 AS `money_balance`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `connected_addresses`
--

DROP TABLE IF EXISTS `connected_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `connected_addresses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `house_id` bigint unsigned NOT NULL,
  `flat_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `house_id` (`house_id`,`flat_no`),
  CONSTRAINT `connected_addresses_ibfk_1` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `connected_addresses`
--

LOCK TABLES `connected_addresses` WRITE;
/*!40000 ALTER TABLE `connected_addresses` DISABLE KEYS */;
INSERT INTO `connected_addresses` VALUES (1,2,'10'),(2,2,'11'),(3,3,'25'),(4,4,'100'),(5,4,'101'),(6,5,'1'),(7,5,'2'),(8,6,'30'),(9,6,'33');
/*!40000 ALTER TABLE `connected_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_types`
--

DROP TABLE IF EXISTS `document_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `document_types` (
  `id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_types`
--

LOCK TABLES `document_types` WRITE;
/*!40000 ALTER TABLE `document_types` DISABLE KEYS */;
INSERT INTO `document_types` VALUES (1,'?????????????? ????'),(2,'?????????????????????? ?????????????? ????'),(3,'?????????????? ???????????????????? ????'),(4,'?????????????? ???????????????????? ????');
/*!40000 ALTER TABLE `document_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `houses`
--

DROP TABLE IF EXISTS `houses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `houses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `street` varchar(200) NOT NULL,
  `house_num` int unsigned DEFAULT NULL,
  `house_korpus` varchar(10) DEFAULT NULL,
  `house_litera` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `street` (`street`,`house_num`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `houses`
--

LOCK TABLES `houses` WRITE;
/*!40000 ALTER TABLE `houses` DISABLE KEYS */;
INSERT INTO `houses` VALUES (1,'????????????????????',99,NULL,NULL),(2,'????????????????????',101,NULL,NULL),(3,'????????????????????',103,NULL,NULL),(4,'??????????????',30,NULL,NULL),(5,'??????????????',32,NULL,NULL),(6,'??????????????',34,NULL,NULL);
/*!40000 ALTER TABLE `houses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ip_adresses`
--

DROP TABLE IF EXISTS `ip_adresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `ip_adresses` (
  `ip_address` int unsigned NOT NULL,
  `binded_mac` char(17) DEFAULT NULL,
  PRIMARY KEY (`ip_address`),
  KEY `binded_mac` (`binded_mac`),
  CONSTRAINT `ip_adresses_ibfk_1` FOREIGN KEY (`binded_mac`) REFERENCES `registered_macs` (`mac_address`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ip_adresses`
--

LOCK TABLES `ip_adresses` WRITE;
/*!40000 ALTER TABLE `ip_adresses` DISABLE KEYS */;
INSERT INTO `ip_adresses` VALUES (3232235520,NULL),(3232235521,NULL),(3232235529,NULL),(3232235530,NULL),(3232235531,NULL),(3232235532,NULL),(3232235533,NULL),(3232235534,NULL),(3232235535,NULL),(3232235536,NULL),(3232235537,NULL),(3232235538,NULL),(3232235539,NULL),(3232235540,NULL),(3232235541,NULL),(3232235542,NULL),(3232235543,NULL),(3232235544,NULL),(3232235522,'00:17:c8:75:c8:3f'),(3232235523,'38:b1:db:06:68:bd'),(3232235524,'38:ea:a7:0d:de:f1'),(3232235525,'50:57:a8:1a:d5:92'),(3232235526,'74:d0:2b:93:a9:f5'),(3232235527,'a8:a1:59:58:33:b0'),(3232235528,'b4:2e:99:5c:92:64');
/*!40000 ALTER TABLE `ip_adresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_agents`
--

DROP TABLE IF EXISTS `payment_agents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `payment_agents` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_agents`
--

LOCK TABLES `payment_agents` WRITE;
/*!40000 ALTER TABLE `payment_agents` DISABLE KEYS */;
INSERT INTO `payment_agents` VALUES (1,'Bank 1'),(2,'Bank 2'),(3,'Operator 1'),(4,'Operator 2');
/*!40000 ALTER TABLE `payment_agents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `periods`
--

DROP TABLE IF EXISTS `periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `periods` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `duration` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `durations_count` tinyint unsigned DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `periods`
--

LOCK TABLES `periods` WRITE;
/*!40000 ALTER TABLE `periods` DISABLE KEYS */;
INSERT INTO `periods` VALUES (1,'MONTH',1),(2,'DAY',1);
/*!40000 ALTER TABLE `periods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registered_macs`
--

DROP TABLE IF EXISTS `registered_macs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `registered_macs` (
  `mac_address` char(17) NOT NULL,
  `account_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`mac_address`),
  KEY `account_id` (`account_id`),
  CONSTRAINT `registered_macs_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registered_macs`
--

LOCK TABLES `registered_macs` WRITE;
/*!40000 ALTER TABLE `registered_macs` DISABLE KEYS */;
INSERT INTO `registered_macs` VALUES ('b4:2e:99:5c:92:64',1),('38:b1:db:06:68:bd',2),('38:ea:a7:0d:de:f1',3),('74:d0:2b:93:a9:f5',4),('a8:a1:59:58:33:b0',5),('00:17:c8:75:c8:3f',6),('50:57:a8:1a:d5:92',7);
/*!40000 ALTER TABLE `registered_macs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `services` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `s_name` varchar(100) DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `period_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `period_id` (`period_id`),
  CONSTRAINT `services_ibfk_1` FOREIGN KEY (`period_id`) REFERENCES `periods` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (1,'Internet 50 Mbit/s',500,1),(2,'Internet 100 Mbit/s',1000,1),(3,'Internet 20Mbit/s',400,1),(4,'TV',150,1),(5,'TV+ Extra',500,1);
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tariffs`
--

DROP TABLE IF EXISTS `tariffs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `tariffs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `period_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `period_id` (`period_id`),
  CONSTRAINT `tariffs_ibfk_1` FOREIGN KEY (`period_id`) REFERENCES `periods` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tariffs`
--

LOCK TABLES `tariffs` WRITE;
/*!40000 ALTER TABLE `tariffs` DISABLE KEYS */;
INSERT INTO `tariffs` VALUES (1,'????????????????',500,1),(2,'??????????????????????',600,1),(3,'??????????',1000,1),(4,'?????? ????????????????',1300,1),(5,'?????? ????????????',0,1);
/*!40000 ALTER TABLE `tariffs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tariffs_services`
--

DROP TABLE IF EXISTS `tariffs_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `tariffs_services` (
  `tariff_id` bigint unsigned NOT NULL,
  `service_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tariff_id`,`service_id`),
  KEY `service_id` (`service_id`),
  CONSTRAINT `tariffs_services_ibfk_1` FOREIGN KEY (`tariff_id`) REFERENCES `tariffs` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `tariffs_services_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tariffs_services`
--

LOCK TABLES `tariffs_services` WRITE;
/*!40000 ALTER TABLE `tariffs_services` DISABLE KEYS */;
INSERT INTO `tariffs_services` VALUES (2,1),(3,2),(4,2),(1,3),(1,4),(2,4),(3,4),(4,5);
/*!40000 ALTER TABLE `tariffs_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tariffs_write_offs`
--

DROP TABLE IF EXISTS `tariffs_write_offs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `tariffs_write_offs` (
  `account_id` bigint unsigned NOT NULL,
  `next_write_off_at` date NOT NULL,
  PRIMARY KEY (`account_id`),
  KEY `next_write_off_at` (`next_write_off_at`),
  CONSTRAINT `tariffs_write_offs_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tariffs_write_offs`
--

LOCK TABLES `tariffs_write_offs` WRITE;
/*!40000 ALTER TABLE `tariffs_write_offs` DISABLE KEYS */;
INSERT INTO `tariffs_write_offs` VALUES (1,'2022-05-26'),(2,'2022-05-26'),(3,'2022-05-26'),(4,'2022-05-26'),(5,'2022-05-26'),(6,'2022-05-26'),(7,'2022-05-26'),(8,'2022-06-04');
/*!40000 ALTER TABLE `tariffs_write_offs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `today_write_offs`
--

DROP TABLE IF EXISTS `today_write_offs`;
/*!50001 DROP VIEW IF EXISTS `today_write_offs`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `today_write_offs` AS SELECT 
 1 AS `account_id`,
 1 AS `current_tariff_id`,
 1 AS `next_tariff_id`,
 1 AS `price`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'gb_mysql_curs'
--
/*!50003 DROP FUNCTION IF EXISTS `add_service_period` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sasha`@`%` FUNCTION `add_service_period`(service_id INT) RETURNS date
    DETERMINISTIC
BEGIN
	DECLARE period, cnt VARCHAR(20);
    DECLARE new_date DATE;
	SELECT p.duration, p.durations_count INTO period, cnt 
    FROM services s 
    JOIN periods p ON s.period_id = p.id
    WHERE s.id = service_id;
    CASE period 
		WHEN 'DAY' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt DAY);
		WHEN 'MONTH' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt MONTH);
		WHEN 'WEEK' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt WEEK);
		WHEN 'YEAR' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt YEAR);
	END CASE;
    RETURN new_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `add_tariff_period` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sasha`@`%` FUNCTION `add_tariff_period`(tariff_id INT) RETURNS date
    DETERMINISTIC
BEGIN
	DECLARE period, cnt VARCHAR(20);
    DECLARE new_date DATE;
	SELECT p.duration, p.durations_count INTO period, cnt 
    FROM tariffs t 
    JOIN periods p ON t.period_id = p.id
    WHERE t.id = tariff_id;
    CASE period 
		WHEN 'DAY' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt DAY);
		WHEN 'MONTH' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt MONTH);
		WHEN 'WEEK' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt WEEK);
		WHEN 'YEAR' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt YEAR);
	END CASE;
    RETURN new_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fill_ip_adresses` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sasha`@`%` PROCEDURE `fill_ip_adresses`(start_address VARCHAR(30), ip_cnt INT)
BEGIN
	DECLARE start_ip INT UNSIGNED;
	DECLARE counter INT DEFAULT 0;
	SET start_ip = INET_ATON(start_address);
	WHILE counter < ip_cnt DO
		INSERT INTO ip_adresses (ip_address) VALUES (start_ip);
		SET counter = counter + 1;
		SET start_ip = start_ip + 1;
	END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `write_off` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sasha`@`%` PROCEDURE `write_off`()
BEGIN
	DECLARE a_id, current_tariff, next_tariff INT;
    DECLARE price DECIMAL;
    DECLARE is_end INT DEFAULT 0;

	DECLARE cur CURSOR FOR SELECT * FROM today_write_offs;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end = 1;

    OPEN cur;
    cycle: LOOP
		FETCH cur INTO a_id, current_tariff, next_tariff, price;
        IF is_end THEN LEAVE cycle;
        END IF;
        UPDATE accounts SET money_balance = money_balance - price WHERE id = a_id;
        IF current_tariff != next_tariff AND next_tariff != -1 THEN
			UPDATE accounts SET current_tariff_id = next_tariff WHERE id = a_id;
            SET current_tariff = nex_tariff;
		END IF;
        IF next_tariff != -1 THEN
			UPDATE tariffs_write_offs SET next_write_off_at = add_tariff_period(current_tarif) WHERE account_id = a_id;
		ELSE
			UPDATE accounts_services_write_offs SET next_write_off_at = add_service_period(current_tariff) WHERE account_id = a_id;			
        END IF;
	END LOOP;
    CLOSE cur;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `blocked_accounts`
--

/*!50001 DROP VIEW IF EXISTS `blocked_accounts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sasha`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `blocked_accounts` AS select concat(`ab`.`firstname`,' ',`ab`.`lastname`) AS `fio`,concat(`h`.`street`,', ??.',`h`.`house_num`,', ????.',`ca`.`flat_no`) AS `CONCAT(h.street, ", ??.", h.house_num, ", ????.", ca.flat_no)`,`a`.`contract` AS `contract`,`a`.`login` AS `login`,`a`.`money_balance` AS `money_balance` from (((`accounts` `a` join `abonents` `ab` on((`a`.`abonent_id` = `ab`.`id`))) join `connected_addresses` `ca` on((`a`.`contract_address_id` = `ca`.`id`))) join `houses` `h` on((`ca`.`house_id` = `h`.`id`))) where (`a`.`money_balance` <= 0) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `today_write_offs`
--

/*!50001 DROP VIEW IF EXISTS `today_write_offs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sasha`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `today_write_offs` AS select `two`.`account_id` AS `account_id`,`a`.`current_tariff_id` AS `current_tariff_id`,`a`.`next_tariff_id` AS `next_tariff_id`,`t`.`price` AS `price` from ((`tariffs_write_offs` `two` join `accounts` `a` on((`two`.`account_id` = `a`.`id`))) join `tariffs` `t` on((`a`.`current_tariff_id` = `t`.`id`))) where (`two`.`next_write_off_at` = curdate()) union all select `asw`.`account_id` AS `account_id`,`asw`.`service_id` AS `service_id`,-(1) AS `-1`,`services`.`price` AS `price` from (`accounts_services_write_offs` `asw` join `services` on((`asw`.`service_id` = `services`.`id`))) where (`asw`.`next_write_off_at` = curdate()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-05-04 22:48:04
