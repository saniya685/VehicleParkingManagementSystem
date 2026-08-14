-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: vehicle_parking_db
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `parking_entries`
--

DROP TABLE IF EXISTS `parking_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parking_entries` (
  `entry_id` int NOT NULL AUTO_INCREMENT,
  `vehicle_id` int NOT NULL,
  `slot_id` int NOT NULL,
  `entry_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `exit_time` datetime DEFAULT NULL,
  `duration_hours` decimal(5,2) DEFAULT NULL,
  `parking_fee` decimal(10,2) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'PARKED',
  PRIMARY KEY (`entry_id`),
  KEY `vehicle_id` (`vehicle_id`),
  KEY `slot_id` (`slot_id`),
  CONSTRAINT `parking_entries_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`),
  CONSTRAINT `parking_entries_ibfk_2` FOREIGN KEY (`slot_id`) REFERENCES `parking_slots` (`slot_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parking_entries`
--

LOCK TABLES `parking_entries` WRITE;
/*!40000 ALTER TABLE `parking_entries` DISABLE KEYS */;
INSERT INTO `parking_entries` VALUES (1,4,1,'2026-08-11 19:08:18','2026-08-11 19:23:02',NULL,NULL,'COMPLETED'),(2,5,1,'2026-08-11 19:56:14','2026-08-12 16:44:39',21.00,660.00,'COMPLETED'),(3,6,2,'2026-08-11 19:57:50','2026-08-11 20:18:05',1.00,20.00,'COMPLETED'),(4,7,2,'2026-08-11 20:19:23','2026-08-11 20:19:53',1.00,60.00,'COMPLETED'),(5,8,2,'2026-08-11 20:33:33','2026-08-11 20:34:08',1.00,60.00,'COMPLETED'),(6,8,2,'2026-08-11 20:34:37',NULL,NULL,NULL,'PARKED'),(7,4,3,'2026-08-11 20:54:52',NULL,NULL,NULL,'PARKED'),(8,9,4,'2026-08-12 20:18:40','2026-08-12 20:19:03',1.00,40.00,'COMPLETED'),(9,10,4,'2026-08-12 20:51:12','2026-08-12 20:52:57',1.00,40.00,'COMPLETED'),(10,11,4,'2026-08-12 21:37:04','2026-08-12 21:38:09',1.00,40.00,'COMPLETED'),(11,12,4,'2026-08-12 22:06:14',NULL,NULL,NULL,'PARKED');
/*!40000 ALTER TABLE `parking_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parking_slots`
--

DROP TABLE IF EXISTS `parking_slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parking_slots` (
  `slot_id` int NOT NULL AUTO_INCREMENT,
  `slot_number` varchar(10) NOT NULL,
  `vehicle_type` varchar(20) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'AVAILABLE',
  PRIMARY KEY (`slot_id`),
  UNIQUE KEY `slot_number` (`slot_number`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parking_slots`
--

LOCK TABLES `parking_slots` WRITE;
/*!40000 ALTER TABLE `parking_slots` DISABLE KEYS */;
INSERT INTO `parking_slots` VALUES (1,'A-01','CAR','AVAILABLE'),(2,'A-02','CAR','OCCUPIED'),(3,'A-03','CAR','OCCUPIED'),(4,'A-04','CAR','OCCUPIED'),(5,'A-05','CAR','AVAILABLE'),(6,'B-01','BIKE','AVAILABLE'),(7,'B-02','BIKE','AVAILABLE'),(8,'B-03','BIKE','AVAILABLE'),(9,'B-04','BIKE','AVAILABLE'),(10,'B-05','BIKE','AVAILABLE'),(11,'C-01','SUV','AVAILABLE'),(12,'C-02','SUV','AVAILABLE'),(13,'C-03','SUV','AVAILABLE'),(14,'D-01','AUTO','AVAILABLE'),(15,'D-02','AUTO','AVAILABLE'),(16,'E-01','TRUCK','AVAILABLE'),(17,'E-02','TRUCK','AVAILABLE');
/*!40000 ALTER TABLE `parking_slots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `entry_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(20) NOT NULL,
  `payment_status` varchar(20) NOT NULL DEFAULT 'PAID',
  `payment_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `entry_id` (`entry_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`entry_id`) REFERENCES `parking_entries` (`entry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,3,20.00,'CASH','PAID','2026-08-11 20:18:05'),(2,4,60.00,'UPI','PAID','2026-08-11 20:19:53'),(3,5,60.00,'CASH','PAID','2026-08-11 20:34:08'),(4,8,40.00,'CASH','PAID','2026-08-12 20:19:03'),(5,9,40.00,'UPI','PAID','2026-08-12 20:52:58'),(6,10,40.00,'CARD','PAID','2026-08-12 21:38:09'),(7,2,660.00,'CARD','PAID','2026-08-12 22:14:39');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pricing`
--

DROP TABLE IF EXISTS `pricing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pricing` (
  `pricing_id` int NOT NULL AUTO_INCREMENT,
  `vehicle_type` varchar(20) NOT NULL,
  `first_hour_rate` decimal(10,2) NOT NULL,
  `additional_hour_rate` decimal(10,2) NOT NULL,
  PRIMARY KEY (`pricing_id`),
  UNIQUE KEY `vehicle_type` (`vehicle_type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pricing`
--

LOCK TABLES `pricing` WRITE;
/*!40000 ALTER TABLE `pricing` DISABLE KEYS */;
INSERT INTO `pricing` VALUES (1,'BIKE',20.00,10.00),(2,'CAR',40.00,20.00),(3,'SUV',50.00,25.00),(4,'AUTO',30.00,15.00),(5,'TRUCK',60.00,30.00);
/*!40000 ALTER TABLE `pricing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'ADMIN',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9','ADMIN');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicles` (
  `vehicle_id` int NOT NULL AUTO_INCREMENT,
  `vehicle_number` varchar(20) NOT NULL,
  `owner_name` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `vehicle_type` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`vehicle_id`),
  UNIQUE KEY `vehicle_number` (`vehicle_number`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` VALUES (1,'MH12AB1234','Rahul Patil','9876543210','CAR','2026-08-11 07:47:17'),(2,'MH14CD5678','Amit Shah','9876501234','BIKE','2026-08-11 07:47:17'),(3,'mh15ad5768','sanu',NULL,'TRUCK','2026-08-11 13:35:44'),(4,'mh12ty6785','samm',NULL,'OTHER','2026-08-11 13:38:18'),(5,'mh14gh4657','sanuu',NULL,'TRUCK','2026-08-11 14:26:14'),(6,'mh15ad5790','shh',NULL,'BIKE','2026-08-11 14:27:50'),(7,'MH18HE5678','tas',NULL,'TRUCK','2026-08-11 14:49:23'),(8,'MH16SS7890','tas',NULL,'TRUCK','2026-08-11 15:03:33'),(9,'MH12SS2822','samn',NULL,'CAR','2026-08-12 14:48:40'),(10,'MH16SA2922','shh',NULL,'CAR','2026-08-12 15:21:12'),(11,'MH12AC2222','sss',NULL,'CAR','2026-08-12 16:07:04'),(12,'MH11SS2822','saaa',NULL,'TRUCK','2026-08-12 16:36:14');
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-14 21:30:48
