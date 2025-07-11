/*M!999999\- enable the sandbox mode */
-- MariaDB dump 10.19  Distrib 10.11.11-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: crowdsec_test
-- ------------------------------------------------------
-- Server version	10.11.11-MariaDB-0+deb12u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `scenario` varchar(255) NOT NULL,
  `bucket_id` varchar(255) DEFAULT '',
  `message` varchar(255) DEFAULT '',
  `events_count` int(11) DEFAULT 0,
  `started_at` timestamp NULL DEFAULT NULL,
  `stopped_at` timestamp NULL DEFAULT NULL,
  `source_ip` varchar(255) DEFAULT NULL,
  `source_range` varchar(255) DEFAULT NULL,
  `source_as_number` varchar(255) DEFAULT NULL,
  `source_as_name` varchar(255) DEFAULT NULL,
  `source_country` varchar(255) DEFAULT NULL,
  `source_latitude` double DEFAULT NULL,
  `source_longitude` double DEFAULT NULL,
  `source_scope` varchar(255) DEFAULT NULL,
  `source_value` varchar(255) DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `leak_speed` varchar(255) DEFAULT NULL,
  `scenario_version` varchar(255) DEFAULT NULL,
  `scenario_hash` varchar(255) DEFAULT NULL,
  `simulated` tinyint(1) NOT NULL DEFAULT 0,
  `uuid` varchar(255) DEFAULT NULL,
  `remediation` tinyint(1) DEFAULT NULL,
  `machine_alerts` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `alert_id` (`id`),
  KEY `alerts_machines_alerts` (`machine_alerts`),
  CONSTRAINT `alerts_machines_alerts` FOREIGN KEY (`machine_alerts`) REFERENCES `machines` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerts`
--

LOCK TABLES `alerts` WRITE;
/*!40000 ALTER TABLE `alerts` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `allow_list_allowlist_items`
--

DROP TABLE IF EXISTS `allow_list_allowlist_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `allow_list_allowlist_items` (
  `allow_list_id` bigint(20) NOT NULL,
  `allow_list_item_id` bigint(20) NOT NULL,
  PRIMARY KEY (`allow_list_id`,`allow_list_item_id`),
  KEY `allow_list_allowlist_items_allow_list_item_id` (`allow_list_item_id`),
  CONSTRAINT `allow_list_allowlist_items_allow_list_id` FOREIGN KEY (`allow_list_id`) REFERENCES `allow_lists` (`id`) ON DELETE CASCADE,
  CONSTRAINT `allow_list_allowlist_items_allow_list_item_id` FOREIGN KEY (`allow_list_item_id`) REFERENCES `allow_list_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allow_list_allowlist_items`
--

LOCK TABLES `allow_list_allowlist_items` WRITE;
/*!40000 ALTER TABLE `allow_list_allowlist_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `allow_list_allowlist_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `allow_list_items`
--

DROP TABLE IF EXISTS `allow_list_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `allow_list_items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `value` varchar(255) NOT NULL,
  `start_ip` bigint(20) DEFAULT NULL,
  `end_ip` bigint(20) DEFAULT NULL,
  `start_suffix` bigint(20) DEFAULT NULL,
  `end_suffix` bigint(20) DEFAULT NULL,
  `ip_size` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `allowlistitem_id` (`id`),
  KEY `allowlistitem_start_ip_end_ip` (`start_ip`,`end_ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allow_list_items`
--

LOCK TABLES `allow_list_items` WRITE;
/*!40000 ALTER TABLE `allow_list_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `allow_list_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `allow_lists`
--

DROP TABLE IF EXISTS `allow_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `allow_lists` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `from_console` tinyint(1) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `allowlist_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `allowlist_id` (`id`),
  UNIQUE KEY `allowlist_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allow_lists`
--

LOCK TABLES `allow_lists` WRITE;
/*!40000 ALTER TABLE `allow_lists` DISABLE KEYS */;
INSERT INTO `allow_lists` VALUES
(1,'2025-06-30 05:44:56','2025-06-30 05:44:56','default',0,'default', NULL);
/*!40000 ALTER TABLE `allow_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bouncers`
--

DROP TABLE IF EXISTS `bouncers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bouncers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `api_key` varchar(255) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `ip_address` varchar(255) DEFAULT '',
  `type` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `last_pull` timestamp NULL DEFAULT NULL,
  `auth_type` varchar(255) NOT NULL DEFAULT 'api-key',
  `osname` varchar(255) DEFAULT NULL,
  `osversion` varchar(255) DEFAULT NULL,
  `featureflags` varchar(255) DEFAULT NULL,
  `auto_created` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bouncers`
--

LOCK TABLES `bouncers` WRITE;
/*!40000 ALTER TABLE `bouncers` DISABLE KEYS */;
/*!40000 ALTER TABLE `bouncers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config_items`
--

DROP TABLE IF EXISTS `config_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_items`
--

LOCK TABLES `config_items` WRITE;
/*!40000 ALTER TABLE `config_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `decisions`
--

DROP TABLE IF EXISTS `decisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `decisions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `until` datetime DEFAULT NULL,
  `scenario` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `start_ip` bigint(20) DEFAULT NULL,
  `end_ip` bigint(20) DEFAULT NULL,
  `start_suffix` bigint(20) DEFAULT NULL,
  `end_suffix` bigint(20) DEFAULT NULL,
  `ip_size` bigint(20) DEFAULT NULL,
  `scope` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `origin` varchar(255) NOT NULL,
  `simulated` tinyint(1) NOT NULL DEFAULT 0,
  `uuid` varchar(255) DEFAULT NULL,
  `alert_decisions` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `decision_start_ip_end_ip` (`start_ip`,`end_ip`),
  KEY `decision_value` (`value`),
  KEY `decision_until` (`until`),
  KEY `decision_alert_decisions` (`alert_decisions`),
  CONSTRAINT `decisions_alerts_decisions` FOREIGN KEY (`alert_decisions`) REFERENCES `alerts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `decisions`
--

LOCK TABLES `decisions` WRITE;
/*!40000 ALTER TABLE `decisions` DISABLE KEYS */;
INSERT INTO `decisions` VALUES
(2259,'2025-06-30 05:44:56','2025-06-30 05:44:56','2025-07-06 23:44:56','generic:scan','ban',-9223372035094580419,-9223372035094580419,-9223372036854775807,-9223372036854775807,4,'Ip','104.234.115.60','CAPI',0,NULL,1);
/*!40000 ALTER TABLE `decisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `time` timestamp NULL DEFAULT NULL,
  `serialized` varchar(8191) NOT NULL,
  `alert_events` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_alert_events` (`alert_events`),
  CONSTRAINT `events_alerts_events` FOREIGN KEY (`alert_events`) REFERENCES `alerts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locks`
--

DROP TABLE IF EXISTS `locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `locks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locks`
--

LOCK TABLES `locks` WRITE;
/*!40000 ALTER TABLE `locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `machines`
--

DROP TABLE IF EXISTS `machines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `machines` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `last_push` timestamp NULL DEFAULT NULL,
  `last_heartbeat` timestamp NULL DEFAULT NULL,
  `machine_id` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `ip_address` varchar(255) NOT NULL,
  `scenarios` longtext DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `is_validated` tinyint(1) NOT NULL DEFAULT 0,
  `auth_type` varchar(255) NOT NULL DEFAULT 'password',
  `osname` varchar(255) DEFAULT NULL,
  `osversion` varchar(255) DEFAULT NULL,
  `featureflags` varchar(255) DEFAULT NULL,
  `hubstate` longtext DEFAULT NULL CHECK (json_valid(`hubstate`)),
  `datasources` longtext DEFAULT NULL CHECK (json_valid(`datasources`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `machine_id` (`machine_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `machines`
--

LOCK TABLES `machines` WRITE;
/*!40000 ALTER TABLE `machines` DISABLE KEYS */;
/*!40000 ALTER TABLE `machines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meta`
--

DROP TABLE IF EXISTS `meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `meta` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(4095) NOT NULL,
  `alert_metas` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `meta_alert_metas` (`alert_metas`),
  CONSTRAINT `meta_alerts_metas` FOREIGN KEY (`alert_metas`) REFERENCES `alerts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meta`
--

LOCK TABLES `meta` WRITE;
/*!40000 ALTER TABLE `meta` DISABLE KEYS */;
/*!40000 ALTER TABLE `meta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metrics`
--

DROP TABLE IF EXISTS `metrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `metrics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `generated_type` enum('LP','RC') NOT NULL,
  `generated_by` varchar(255) NOT NULL,
  `received_at` timestamp NULL DEFAULT NULL,
  `pushed_at` timestamp NULL DEFAULT NULL,
  `payload` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metrics`
--

LOCK TABLES `metrics` WRITE;
/*!40000 ALTER TABLE `metrics` DISABLE KEYS */;
/*!40000 ALTER TABLE `metrics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'crowdsec_test'
--

--
-- Dumping routines for database 'crowdsec_test'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-10  6:08:32
