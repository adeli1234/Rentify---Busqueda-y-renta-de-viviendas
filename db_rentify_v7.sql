-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: viviendas_proyecto
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `codigos_postales`
--

DROP TABLE IF EXISTS `codigos_postales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `codigos_postales` (
  `id_codigo_postal` int NOT NULL AUTO_INCREMENT,
  `numero` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_codigo_postal`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `codigos_postales`
--

LOCK TABLES `codigos_postales` WRITE;
/*!40000 ALTER TABLE `codigos_postales` DISABLE KEYS */;
INSERT INTO `codigos_postales` VALUES (1,'76000'),(2,'76020'),(3,'76024'),(4,'76030'),(5,'76040'),(6,'76046'),(7,'76060'),(8,'76085'),(9,'76087'),(10,'76090'),(11,'76100'),(12,'76116'),(13,'76117'),(14,'76127'),(15,'76140'),(16,'76144'),(17,'76146'),(18,'76147'),(19,'76148'),(20,'76150'),(21,'76160'),(22,'76169'),(23,'76226'),(24,'76230'),(25,'76235');
/*!40000 ALTER TABLE `codigos_postales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colonias`
--

DROP TABLE IF EXISTS `colonias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `colonias` (
  `id_colonia` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) DEFAULT NULL,
  `id_codigo_postal` int DEFAULT NULL,
  PRIMARY KEY (`id_colonia`),
  KEY `codigo_postal_colonias_idx` (`id_codigo_postal`),
  CONSTRAINT `codigo_postal_colonias` FOREIGN KEY (`id_codigo_postal`) REFERENCES `codigos_postales` (`id_codigo_postal`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colonias`
--

LOCK TABLES `colonias` WRITE;
/*!40000 ALTER TABLE `colonias` DISABLE KEYS */;
INSERT INTO `colonias` VALUES (26,'Centro',1),(27,'Bosques del Acueducto',2),(28,'Calesa',2),(29,'Calesa 2a Sección',3),(30,'Cimatario',4),(31,'Las Fuentes',4),(32,'Mercurio',5),(33,'Villas del Sol',6),(34,'Loma Dorada',7),(35,'Milenio III',7),(36,'Colinas del Sur',8),(37,'Bosques de las Lomas',9),(38,'Constelación',9),(39,'Los Comerciantes',9),(40,'Centro Sur',10),(41,'Jurica',11),(42,'Privada de los Portones',11),(43,'Valle de Juriquilla',11),(44,'Ciudad del Sol',12),(45,'Colinas de Santa Cruz 2a Sección',13),(46,'El Salitre',14),(47,'Arboledas',15),(48,'Balcones Coloniales',15),(49,'Balcones del Acueducto',16),(50,'El Campanario',17),(51,'La Vista Residencial',17),(52,'Lomas del Marqués',17),(53,'Mirador del Campanario',17),(54,'Residencial El Refugio',17),(55,'Constituyentes',18),(56,'Independencia (San José El Alto)',18),(57,'Privalia Ambienta',18),(58,'Villas de Santiago',19),(59,'Tecnológico',20),(60,'Las Brujas',21),(61,'Álamos 3a Sección',21),(62,'Plaza del Parque',22),(63,'Juriquilla',23),(64,'Lomas de Juriquilla',23),(65,'Real de Juriquilla',23),(66,'Villas del Mesón',23),(67,'Caletto',24),(68,'Cumbres del Lago',24),(69,'Juriquilla Santa Fe',24),(70,'Nuevo Juriquilla',24),(71,'San Francisco Juriquilla',24),(72,'Sonterra',25);
/*!40000 ALTER TABLE `colonias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `establecimientos`
--

DROP TABLE IF EXISTS `establecimientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `establecimientos` (
  `id_establecimientos` int NOT NULL AUTO_INCREMENT,
  `id_tipo_establecimiento` int DEFAULT NULL,
  `nombre` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id_establecimientos`),
  KEY `tipo_establecimiento_establecimiento_idx` (`id_tipo_establecimiento`),
  CONSTRAINT `tipo_establecimiento_establecimiento` FOREIGN KEY (`id_tipo_establecimiento`) REFERENCES `tipos_establecimiento` (`id_tipo_establecimiento`)
) ENGINE=InnoDB AUTO_INCREMENT=1524 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `establecimientos`
--

LOCK TABLES `establecimientos` WRITE;
/*!40000 ALTER TABLE `establecimientos` DISABLE KEYS */;
INSERT INTO `establecimientos` VALUES (1301,1,'José María Arteaga'),(1302,1,'Margarita Morales Martínez'),(1303,1,'CEDVA'),(1304,1,'Escuela (sin nombre)'),(1305,1,'Universidad Marista de Querétaro'),(1306,1,'Instituto Queretano'),(1307,1,'Iscca'),(1308,1,'Facultad de Filosofía, Campus Centro Histórico'),(1309,1,'Margarita Maza de Juarez / Ignacio Manuel Altamirano'),(1310,1,'Facultad de Filosofia'),(1311,1,'Alma Muriel'),(1312,1,'Instituto La Paz'),(1313,1,'El Mundo del Saber'),(1314,1,'UNIVA'),(1315,1,'Instituto La Asunción'),(1316,1,'El Movi'),(1317,1,'Colegio Celta'),(1318,1,'Kínder (sin nombre)'),(1319,1,'Colegio Diego Olvera'),(1320,1,'José María Truchuelo'),(1321,1,'Primaria Nicolas Campa'),(1322,1,'Colegio Montessori Shanti'),(1323,1,'Universidad Cuauhtemoc'),(1324,1,'Centro SOI'),(1325,1,'champagnat'),(1326,1,'Taller'),(1327,1,'Colegio Bosques'),(1328,1,'Kiara'),(1329,1,'Primaria \"Colegio Santa Isabel\"'),(1330,1,'El Abeto'),(1331,1,'Colegio Washington, Secundaria'),(1332,1,'Instituto Rosa del Carmelo, A. C.'),(1333,1,'Escuela Primaria Cuitlahuac Turno Vespertino'),(1334,1,'Colegio del Olmo'),(1335,1,'Abeto - Primaria y Secundaria'),(1336,1,'Colegio El Tepeyaq'),(1337,1,'Instituto San Juan Pablo II'),(1338,1,'Colegio Nueva Raza'),(1339,1,'John F. Kennedy'),(1340,1,'ISQ - International School of Queretaro'),(1341,1,'Facultad de Ciencias Naturales'),(1342,1,'Colegio Austriaco Mexicano'),(1343,1,'Colegio Oakland'),(1344,1,'Escuela Secundaria Técnica Antonio Acosta Aguayo'),(1345,1,'Colegio Álamos'),(1346,1,'Secundaria Técnica 25 Epigmenio Gonzalez'),(1347,1,'Ubicación del proyecto'),(1348,1,'Escuela Primaria Urbana \"Querenda\"'),(1349,1,'Thomas Jefferson'),(1350,1,'Instituto Cumbres'),(1351,1,'Escuela de Artes y Oficios'),(1352,1,'Collegio Suizo'),(1353,1,'Escuela Talentos Deportivos'),(1354,1,'ITQ'),(1355,1,'International Community Center'),(1356,1,'Universidad Vizcaya de las Americas'),(1357,1,'Instituto Hispano Mexicano'),(1358,1,'CECATI 17'),(1359,1,'Instituto Marcelinas'),(1360,1,'talentos deportivos'),(1361,1,'Facultad de Informática'),(1362,1,'Centro educativo'),(1363,1,'Centro de Investigación y de Estudios Avanzados Unidad Querétaro'),(1364,1,'CECYTEQ No 8'),(1365,1,'Escuela Nacional de Estudios Superiores Juriquilla'),(1366,1,'Preparatoria Bicentenario UAQ'),(1367,1,'Jardín de Niños Estrella'),(1368,2,'Parque (sin nombre)'),(1369,2,'Plaza Mariano de las Casas'),(1370,2,'Ladera Río Querétaro'),(1371,2,'Deportiva del Ferrocarril'),(1372,2,'Plazuela Damián Carmona'),(1373,2,'Plaza de Armas'),(1374,2,'Jardín (sin nombre)'),(1375,2,'Plaza de la Constitución'),(1376,2,'Área Verde Pathé'),(1377,2,'Parque Calesa'),(1378,2,'Asta Bandera'),(1379,2,'Patio del Centro de las Artes de Querétaro'),(1380,2,'Área de juegos (sin nombre)'),(1381,2,'Parque Milenio III (De la Cañada)'),(1382,2,'Hercules'),(1383,2,'Parque Universo 2000'),(1384,2,'Parque Fraternidad de Santiago'),(1385,2,'Área común y casa club del fraccionamiento Claustro de Santiago'),(1386,2,'Parque Claustro del Sur'),(1387,2,'Ciruelos Park'),(1388,2,'Arboretum de Jurica'),(1389,2,'Zona de Preservación Ecológica Cañada Juriquilla'),(1390,2,'Parque Camellón Valle de Juriquilla'),(1391,2,'Parque La Loma IX'),(1392,2,'Parque Serra'),(1393,2,'Parque Lomas del Marqués'),(1394,2,'Parque Claustros'),(1395,2,'ARTES Y OFICIOS QUERETARO'),(1396,2,'oasis park'),(1397,2,'Parque Las Brujas'),(1398,2,'Parque Santa Fe'),(1399,2,'Parque Fujiyama'),(1400,2,'Área de Protección de Recursos Naturales Peña Colorada'),(1401,2,'Jardín botánico de la Universidad Autónoma de Querétaro'),(1402,2,'Jardín Plaza Calixe'),(1403,2,'Zona Sujeta a Conservación Zona Occidental de Microcuencas'),(1404,2,'Parque La Lagartija'),(1405,2,'Parque Deportivo Juriquilla'),(1406,2,'Sonterra area verde'),(1407,3,'Consultorio (sin nombre)'),(1408,3,'Farmacias Similares'),(1409,3,'Farmacia (sin nombre)'),(1410,3,'Generic'),(1411,3,'Farmacia Guadalajara'),(1412,3,'Sanatorio Alcocer Pozo'),(1413,3,'Farmacias del Ahorro'),(1414,3,'Hospital de la Cruz'),(1415,3,'Lugar (sin nombre)'),(1416,3,'San Francisco de Asís'),(1417,3,'Hospital (sin nombre)'),(1418,3,'Dentalia'),(1419,3,'Sanatorio Guadalupe'),(1420,3,'Clínica Médica Carretas'),(1421,3,'Mundo Wellness Fisoterapia'),(1422,3,'Plaza Guijar'),(1423,3,'Unidad De Medicina Familiar No. 2'),(1424,3,'Benavides'),(1425,3,'Farmacia de Descuento'),(1426,3,'Torre médica Del Sur'),(1427,3,'Centro De Salud'),(1428,3,'Farmacias Guadalajara'),(1429,3,'Centro de Rehabilitación Integral de Querétaro (CRIQ)'),(1430,3,'Cruz Roja Mexicana'),(1431,3,'Farmacia del Ahorro'),(1432,3,'Hospital Ángeles Centro Sur Queretaro'),(1433,3,'Dr Gerardo Menocal Tobias'),(1434,3,'Dharma: Terapia física y rehabilitación'),(1435,3,'Unidad Médica Jurica'),(1436,3,'Hospital Moscatti'),(1437,3,'Hospital Oncológico Teletón'),(1438,3,'Centro de Investigación Biomédica'),(1439,3,'Labor center UAQ'),(1440,3,'Farmacia Del Bajio'),(1441,3,'Laboratorio de biomédica'),(1442,3,'Farmacia de Soriana'),(1443,3,'Farmacias Benavides'),(1444,3,'Nutrición ENES'),(1445,3,'Enfermería ENES'),(1446,3,'Farmacia San Pablo'),(1447,3,'Mi Consultorio San Pablo'),(1448,4,'OXXO'),(1449,4,'Tiendas 3B'),(1450,4,'El Luchador'),(1451,4,'La Zulianita'),(1452,4,'Outlet Bimbo'),(1453,4,'Panadería (sin nombre)'),(1454,4,'Minisuper San Luis'),(1455,4,'Abarrotes'),(1456,4,'Tienda (sin nombre)'),(1457,4,'Panacea'),(1458,4,'Plaza Zinc'),(1459,4,'Saint Honoré Panadería Francesa'),(1460,4,'Súper Todo'),(1461,4,'Centro comercial (sin nombre)'),(1462,4,'Super Q'),(1463,4,'Zona Comercial Marianas'),(1464,4,'La Guadalupana'),(1465,4,'Miscelánea Cyntia'),(1466,4,'Sanborns'),(1467,4,'Puerta La Victoria'),(1468,4,'Stripmall'),(1469,4,'Fresko'),(1470,4,'Tinedas 3B'),(1471,4,'Plaza Fer'),(1472,4,'Deposito CORONA'),(1473,4,'Aránzazu'),(1474,4,'Plaza Milenio'),(1475,4,'LC Biotecnología de México, S. A. de C. V.'),(1476,4,'Superama'),(1477,4,'Plaza Cristal'),(1478,4,'Miscelánea La Paloma'),(1479,4,'Asturiano'),(1480,4,'Tienda Bara'),(1481,4,'Mercado (sin nombre)'),(1482,4,'Misc. Arroyo'),(1483,4,'Plaza Diamante'),(1484,4,'Chedraui'),(1485,4,'Liverpool'),(1486,4,'City Market'),(1487,4,'Panadería Brötli'),(1488,4,'Walmart Express'),(1489,4,'Urban Center Jurica'),(1490,4,'Mini Super Camino Real'),(1491,4,'Super Selecto Chedraui'),(1492,4,'H-E-B'),(1493,4,'Miscelánea Escobedo'),(1494,4,'Recyclin'),(1495,4,'Alexa'),(1496,4,'Dany'),(1497,4,'La Chiquita'),(1498,4,'Miscelánea Cerrito'),(1499,4,'Aguila'),(1500,4,'Cremería Baguedano'),(1501,4,'Las Gemelas'),(1502,4,'Super Lomas'),(1503,4,'La Estacion de Pan'),(1504,4,'Miscelanea La Cañada'),(1505,4,'Las Delicias'),(1506,4,'Bodega Aurrera Express'),(1507,4,'La Comer'),(1508,4,'ruta'),(1509,4,'Elektra'),(1510,4,'Mrkdito Constituyentes'),(1511,4,'Miscelánea Max'),(1512,4,'Miscelánea El Ángel'),(1513,4,'Materias Primas'),(1514,4,'Plaza Laborcilla'),(1515,4,'El Globo'),(1516,4,'El Puente'),(1517,4,'Antea'),(1518,4,'Farmacias Guadalajara'),(1519,4,'Miscelánea El Amigo'),(1520,4,'Fresko Comercial Mexicana'),(1521,4,'Walmart'),(1522,4,'Miscelánea Paty'),(1523,4,'Super E');
/*!40000 ALTER TABLE `establecimientos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `existencias_interes`
--

DROP TABLE IF EXISTS `existencias_interes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `existencias_interes` (
  `id_existencia_interes` int NOT NULL AUTO_INCREMENT,
  `estado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_existencia_interes`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `existencias_interes`
--

LOCK TABLES `existencias_interes` WRITE;
/*!40000 ALTER TABLE `existencias_interes` DISABLE KEYS */;
INSERT INTO `existencias_interes` VALUES (1,'Sí'),(2,'No');
/*!40000 ALTER TABLE `existencias_interes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favoritos`
--

DROP TABLE IF EXISTS `favoritos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favoritos` (
  `id_favorito` int NOT NULL AUTO_INCREMENT,
  `id_publicacion` int DEFAULT NULL,
  `id_usuario` int DEFAULT NULL,
  PRIMARY KEY (`id_favorito`),
  KEY `publicacion_favoritos_idx` (`id_publicacion`),
  KEY `usuario_favoritos_idx` (`id_usuario`),
  CONSTRAINT `publicacion_favoritos` FOREIGN KEY (`id_publicacion`) REFERENCES `publicaciones` (`id_publicacion`),
  CONSTRAINT `usuario_favoritos` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favoritos`
--

LOCK TABLES `favoritos` WRITE;
/*!40000 ALTER TABLE `favoritos` DISABLE KEYS */;
/*!40000 ALTER TABLE `favoritos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fotos_inmueble`
--

DROP TABLE IF EXISTS `fotos_inmueble`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fotos_inmueble` (
  `id_foto_inmueble` int NOT NULL AUTO_INCREMENT,
  `url` varchar(512) DEFAULT NULL,
  `id_inmueble` int DEFAULT NULL,
  PRIMARY KEY (`id_foto_inmueble`),
  KEY `inmueble_fotos_idx` (`id_inmueble`),
  CONSTRAINT `inmueble_fotos` FOREIGN KEY (`id_inmueble`) REFERENCES `inmuebles` (`id_inmueble`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fotos_inmueble`
--

LOCK TABLES `fotos_inmueble` WRITE;
/*!40000 ALTER TABLE `fotos_inmueble` DISABLE KEYS */;
/*!40000 ALTER TABLE `fotos_inmueble` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inmuebles`
--

DROP TABLE IF EXISTS `inmuebles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inmuebles` (
  `id_inmueble` int NOT NULL AUTO_INCREMENT,
  `precio` decimal(10,2) DEFAULT NULL,
  `coordenadas` varchar(80) DEFAULT NULL,
  `id_colonia` int DEFAULT NULL,
  `id_tipo_inmueble` int DEFAULT NULL,
  PRIMARY KEY (`id_inmueble`),
  KEY `colonia_inmuebles_idx` (`id_colonia`),
  KEY `tipo_inmueble_inmuebles_idx` (`id_tipo_inmueble`),
  CONSTRAINT `colonia_inmuebles` FOREIGN KEY (`id_colonia`) REFERENCES `colonias` (`id_colonia`),
  CONSTRAINT `tipo_inmueble_inmuebles` FOREIGN KEY (`id_tipo_inmueble`) REFERENCES `tipos_inmueble` (`id_tipo_inmueble`)
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inmuebles`
--

LOCK TABLES `inmuebles` WRITE;
/*!40000 ALTER TABLE `inmuebles` DISABLE KEYS */;
INSERT INTO `inmuebles` VALUES (1,9000.00,'20.5905484, -100.3977091',26,1),(2,14000.00,'20.598338, -100.3975191',26,1),(3,15000.00,'20.5905484, -100.3977091',26,1),(4,7500.00,'20.5996859, -100.3860676',26,1),(5,9000.00,'20.5972639, -100.3871589',26,1),(6,9870.00,'20.5925289, -100.3887121',26,1),(7,15000.00,'20.5890337, -100.3924873',26,1),(8,7800.00,'20.5966741, -100.3757573',27,1),(9,8300.00,'20.6008277, -100.3740025',28,1),(10,5500.00,'20.5991594, -100.3721791',28,1),(11,8500.00,'20.6008277, -100.3740025',29,1),(12,16000.00,'20.5295887, -100.3908734',30,1),(13,26000.00,'20.583962, -100.3931977',30,1),(14,12500.00,'20.5965259, -100.4263781',31,1),(15,18500.00,'20.5851258, -100.3810629',32,1),(16,18000.00,'20.5861505, -100.3809345',32,1),(17,16000.00,'20.5850924, -100.3809009',33,1),(18,21500.00,'20.5936071, -100.3661578',34,1),(19,18500.00,'20.5945467, -100.349455',35,1),(20,25000.00,'20.5936563, -100.3680925',35,1),(21,18500.00,'20.5984409, -100.3605573',35,1),(22,34000.00,'20.5992925, -100.3644681',35,1),(23,35000.00,'20.5943225, -100.3659308',35,1),(24,22500.00,'20.5983686, -100.3573435',35,1),(25,24500.00,'20.5988738, -100.3531433',35,1),(26,29500.00,'20.5959166, -100.3573935',35,1),(27,18500.00,'20.5943225, -100.3659308',35,1),(28,16300.00,'20.5957078, -100.3619395',35,1),(29,22500.00,'20.5943225, -100.3659308',35,1),(30,16500.00,'20.5887932, -100.3898881',35,1),(31,16700.00,'20.5938816, -100.349623',35,1),(32,17500.00,'20.5963951, -100.3518113',35,1),(33,19500.00,'20.5979272, -100.3517844',35,1),(34,58000.00,'20.5963764, -100.3674415',35,1),(35,40000.00,'20.5973764, -100.3664415',35,1),(36,18000.00,'20.5951924, -100.3479663',35,1),(37,16500.00,'20.6003557, -100.3615531',35,1),(38,34000.00,'20.5976593, -100.3643916',35,1),(39,18500.00,'20.5947309, -100.3496547',35,1),(40,7000.00,'20.5474235, -100.3855842',36,1),(41,10000.00,'20.5542071, -100.3646838',37,1),(42,10000.00,'20.5556622, -100.363133',37,1),(43,9000.00,'20.557244, -100.3791122',38,1),(44,5500.00,'20.5647176, -100.3807251',39,1),(45,34000.00,'20.5707001, -100.3628798',40,1),(46,24900.00,'20.5725237, -100.3630178',40,1),(47,24900.00,'20.5719535, -100.3627992',40,1),(48,48000.00,'20.5719707, -100.3628381',40,1),(49,33000.00,'20.5639156, -100.3660202',40,1),(50,19000.00,'20.5705002, -100.3582107',40,1),(51,15000.00,'20.5705002, -100.3582107',40,1),(52,17000.00,'20.6729369, -100.4365561',41,1),(53,42000.00,'20.677416, -100.4466712',41,1),(54,18000.00,'20.6755, -100.447',41,1),(55,24000.00,'20.674953, -100.4453289',41,1),(56,33000.00,'20.6528412, -100.432632',41,1),(57,24000.00,'20.6878804, -100.4538886',42,1),(58,25000.00,'20.6878804, -100.4538886',42,1),(59,32000.00,'20.6879, -100.454',42,1),(60,19500.00,'20.6875642, -100.4448943',43,1),(61,24000.00,'20.6905642, -100.4418943',43,1),(62,8700.00,'20.6310625, -100.4893624',44,1),(63,7500.00,'20.6313, -100.49',44,1),(64,8000.00,'20.6342, -100.491',44,1),(65,7600.00,'20.6344544, -100.4893078',44,1),(66,8000.00,'20.6415889, -100.4783738',44,1),(67,10000.00,'20.6318089, -100.4893903',44,1),(68,9500.00,'20.6276506, -100.4727069',45,1),(69,9500.00,'20.6278505, -100.4728041',45,1),(70,14800.00,'20.6623728, -100.4233081',46,1),(71,25000.00,'20.6726, -100.422',46,1),(72,4000.00,'20.5474235, -100.3855842',47,1),(73,25000.00,'20.6189376, -100.3805182',48,1),(74,26000.00,'20.6165602, -100.3780273',48,1),(75,23000.00,'20.6175015, -100.380342',48,1),(76,26000.00,'20.6177425, -100.3812432',48,1),(77,22000.00,'20.6170268, -100.3799691',48,1),(78,22000.00,'20.618, -100.38',48,1),(79,30000.00,'20.6192, -100.381',48,1),(80,22000.00,'20.6191, -100.382',48,1),(81,22000.00,'20.618458, -100.375929',48,1),(82,30300.00,'20.6181172, -100.3787239',48,1),(83,42000.00,'20.6062876, -100.3695458',49,1),(84,68000.00,'20.6116982, -100.36994',50,1),(85,16000.00,'20.6077631, -100.369853',50,1),(86,30000.00,'20.6086082, -100.3702065',50,1),(87,35000.00,'20.6168441, -100.3492959',50,1),(88,17500.00,'20.6085569, -100.33088',50,1),(89,17000.00,'20.6086082, -100.3702065',50,1),(90,23000.00,'20.6064865, -100.3675967',50,1),(91,35000.00,'20.6061955, -100.3685618',50,1),(92,23500.00,'20.6061955, -100.3685618',50,1),(93,75000.00,'20.6168441, -100.3492959',50,1),(94,55000.00,'20.6168441, -100.3492959',50,1),(95,28000.00,'20.6150746, -100.3644447',50,1),(96,48000.00,'20.6234547, -100.3343527',50,1),(97,35000.00,'20.6063236, -100.3686044',50,1),(98,22000.00,'20.6066154, -100.3680991',50,1),(99,25000.00,'20.6086082, -100.3702065',50,1),(100,39000.00,'20.6387135, -100.3483684',51,1),(101,14950.00,'20.6412318, -100.3525595',51,1),(102,16500.00,'20.6064865, -100.3675967',52,1),(103,19000.00,'20.6066996, -100.3590592',53,1),(104,17500.00,'20.6578042, -100.3435194',54,1),(105,18000.00,'20.6435591, -100.3497763',54,1),(106,18000.00,'20.6596069, -100.3522127',54,1),(107,17500.00,'20.6436019, -100.3486102',54,1),(108,17500.00,'20.6437209, -100.3466174',54,1),(109,14500.00,'20.6437209, -100.3466174',54,1),(110,10000.00,'20.6237078, -100.3912012',55,1),(111,12000.00,'20.662525, -100.3858254',56,1),(112,8800.00,'20.6622854, -100.3858807',57,1),(113,16000.00,'20.6623205, -100.38587',57,1),(114,16000.00,'20.6608456, -100.385585',57,1),(115,16000.00,'20.662525, -100.3858254',57,1),(116,10500.00,'20.659484, -100.3823502',57,1),(117,10500.00,'20.659484, -100.3823502',57,1),(118,10500.00,'20.6608948, -100.3936657',58,1),(119,17000.00,'20.6145973, -100.4019392',59,1),(120,38500.00,'20.6026757, -100.3825832',60,1),(121,25000.00,'20.6119032, -100.3876102',61,1),(122,19500.00,'20.6119032, -100.3876102',61,1),(123,20000.00,'20.6144288, -100.3899577',62,1),(124,24000.00,'20.6144288, -100.3899577',62,1),(125,19500.00,'20.6147903, -100.3897727',62,1),(126,20300.00,'20.6895085, -100.4378753',63,1),(127,16500.00,'20.6868336, -100.4652062',63,1),(128,33000.00,'20.6740633, -100.4379163',63,1),(129,25000.00,'20.6878688, -100.4542338',63,1),(130,75000.00,'20.6919946, -100.4451949',63,1),(131,17500.00,'20.6954259, -100.4452328',63,1),(132,23000.00,'20.6740633, -100.4379163',63,1),(133,23000.00,'20.6740633, -100.4379163',63,1),(134,22000.00,'20.6898737, -100.4606196',63,1),(135,15500.00,'20.6903779, -100.4686605',63,1),(136,20000.00,'20.6923206, -100.4693855',63,1),(137,23800.00,'20.7234758, -100.4581637',63,1),(138,45000.00,'20.6888688, -100.4532338',63,1),(139,30000.00,'20.6878804, -100.4538886',63,1),(140,16000.00,'20.689441, -100.4687224',63,1),(141,16000.00,'20.660462, -100.3681849',63,1),(142,19500.00,'20.7019665, -100.4481594',63,1),(143,50000.00,'20.6955691, -100.4657216',63,1),(144,27280.00,'20.6967159, -100.4694284',63,1),(145,36520.00,'20.6967159, -100.4694284',63,1),(146,15000.00,'20.6990975, -100.4705682',63,1),(147,30000.00,'20.6990975, -100.4705682',63,1),(148,29000.00,'20.6878804, -100.4538886',63,1),(149,25500.00,'20.6904709, -100.4646894',63,1),(150,23000.00,'20.6860773, -100.4562842',63,1),(151,16000.00,'20.689441, -100.4687224',63,1),(152,24500.00,'20.6878, -100.454',63,1),(153,24500.00,'20.7233325, -100.4593262',63,1),(154,20000.00,'20.6861, -100.465',63,1),(155,20000.00,'20.7075006, -100.4425316',63,1),(156,22000.00,'20.6879375, -100.4530854',63,1),(157,30000.00,'20.6860773, -100.4562842',63,1),(158,17000.00,'20.6884092, -100.4651402',63,1),(159,16000.00,'20.6916141, -100.4691288',63,1),(160,42000.00,'20.6924528, -100.4716639',63,1),(161,22500.00,'20.700735, -100.4666786',63,1),(162,16000.00,'20.6924528, -100.4716639',63,1),(163,19500.00,'20.6969692, -100.4453327',63,1),(164,24000.00,'20.722357, -100.4544283',64,1),(165,22000.00,'20.7276, -100.461',64,1),(166,13400.00,'20.7343973, -100.4741786',65,1),(167,5500.00,'20.7380718, -100.481323',65,1),(168,5500.00,'20.7380718, -100.481323',65,1),(169,19500.00,'20.7019665, -100.4481594',65,1),(170,17500.00,'20.6978174, -100.4557828',66,1),(171,13000.00,'20.7074636, -100.4434397',67,1),(172,25000.00,'20.7019416, -100.4682784',68,1),(173,42000.00,'20.6990975, -100.4705682',68,1),(174,16000.00,'20.6900344, -100.4685081',68,1),(175,15000.00,'20.6981654, -100.4724329',68,1),(176,36520.00,'20.697734, -100.4716907',68,1),(177,36520.00,'20.697734, -100.4716907',68,1),(178,50000.00,'20.696712, -100.4633408',68,1),(179,23000.00,'20.6990975, -100.4705682',68,1),(180,22150.00,'20.7057, -100.473',68,1),(181,38000.00,'20.6991, -100.471',68,1),(182,23000.00,'20.7038, -100.472',68,1),(183,42000.00,'20.6990975, -100.4705682',68,1),(184,21500.00,'20.6977919, -100.4432915',69,1),(185,26000.00,'20.6920875, -100.4450671',69,1),(186,28000.00,'20.6976833, -100.4432666',69,1),(187,20000.00,'20.6983866, -100.4436313',69,1),(188,26500.00,'20.6959004, -100.4421532',69,1),(189,27800.00,'20.6974051, -100.4438749',69,1),(190,28000.00,'20.6895691, -100.438047',69,1),(191,18000.00,'20.6878804, -100.4538886',69,1),(192,20500.00,'20.6933677, -100.4438707',69,1),(193,25000.00,'20.6868604, -100.4420948',69,1),(194,18500.00,'20.6958242, -100.4422018',69,1),(195,30500.00,'20.6933677, -100.4438707',69,1),(196,18000.00,'20.7131, -100.446',70,1),(197,20000.00,'20.7028307, -100.4576723',71,1),(198,9500.00,'20.6136154, -100.4824483',72,1);
/*!40000 ALTER TABLE `inmuebles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inmuebles_establecimiento`
--

DROP TABLE IF EXISTS `inmuebles_establecimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inmuebles_establecimiento` (
  `id_inmueble_establecimiento` int NOT NULL AUTO_INCREMENT,
  `id_inmueble` int DEFAULT NULL,
  `id_establecimiento` int DEFAULT NULL,
  PRIMARY KEY (`id_inmueble_establecimiento`),
  KEY `inmueble_inmuebles_establecimiento_idx` (`id_inmueble`),
  KEY `establecimiento_inmuebles_establecimiento_idx` (`id_establecimiento`),
  CONSTRAINT `establecimiento_inmuebles_establecimiento` FOREIGN KEY (`id_establecimiento`) REFERENCES `establecimientos` (`id_establecimientos`),
  CONSTRAINT `inmueble_inmuebles_establecimiento` FOREIGN KEY (`id_inmueble`) REFERENCES `inmuebles` (`id_inmueble`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inmuebles_establecimiento`
--

LOCK TABLES `inmuebles_establecimiento` WRITE;
/*!40000 ALTER TABLE `inmuebles_establecimiento` DISABLE KEYS */;
/*!40000 ALTER TABLE `inmuebles_establecimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `intereses_inmueble`
--

DROP TABLE IF EXISTS `intereses_inmueble`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `intereses_inmueble` (
  `id_interes_inmueble` int NOT NULL AUTO_INCREMENT,
  `id_inmueble` int DEFAULT NULL,
  `id_tipo_interes` int DEFAULT NULL,
  `id_existencia_interes` int DEFAULT NULL,
  PRIMARY KEY (`id_interes_inmueble`),
  KEY `inmueble_intereses_inmueble_idx` (`id_inmueble`),
  KEY `tipo_interes_intereses_inmueble_idx` (`id_tipo_interes`),
  KEY `existencia_interes_intereses_inmueble_idx` (`id_existencia_interes`),
  CONSTRAINT `existencia_interes_intereses_inmueble` FOREIGN KEY (`id_existencia_interes`) REFERENCES `existencias_interes` (`id_existencia_interes`),
  CONSTRAINT `inmueble_intereses_inmueble` FOREIGN KEY (`id_inmueble`) REFERENCES `inmuebles` (`id_inmueble`),
  CONSTRAINT `tipo_interes_intereses_inmueble` FOREIGN KEY (`id_tipo_interes`) REFERENCES `tipos_interes` (`id_tipo_interes`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intereses_inmueble`
--

LOCK TABLES `intereses_inmueble` WRITE;
/*!40000 ALTER TABLE `intereses_inmueble` DISABLE KEYS */;
/*!40000 ALTER TABLE `intereses_inmueble` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `intereses_usuario`
--

DROP TABLE IF EXISTS `intereses_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `intereses_usuario` (
  `id_intereses_usuario` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int DEFAULT NULL,
  `id_tipo_interes` int DEFAULT NULL,
  PRIMARY KEY (`id_intereses_usuario`),
  KEY `usuario_interes_usuario_idx` (`id_usuario`),
  KEY `tipos_interes_interes_usuario_idx` (`id_tipo_interes`),
  CONSTRAINT `tipos_interes_interes_usuario` FOREIGN KEY (`id_tipo_interes`) REFERENCES `tipos_interes` (`id_tipo_interes`),
  CONSTRAINT `usuario_interes_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intereses_usuario`
--

LOCK TABLES `intereses_usuario` WRITE;
/*!40000 ALTER TABLE `intereses_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `intereses_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publicaciones`
--

DROP TABLE IF EXISTS `publicaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publicaciones` (
  `id_publicacion` int NOT NULL AUTO_INCREMENT,
  `id_inmueble` int DEFAULT NULL,
  PRIMARY KEY (`id_publicacion`),
  KEY `inmueble_publicaciones_idx` (`id_inmueble`),
  CONSTRAINT `inmueble_publicaciones` FOREIGN KEY (`id_inmueble`) REFERENCES `inmuebles` (`id_inmueble`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publicaciones`
--

LOCK TABLES `publicaciones` WRITE;
/*!40000 ALTER TABLE `publicaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `publicaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publicaciones_usuario`
--

DROP TABLE IF EXISTS `publicaciones_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publicaciones_usuario` (
  `id_publicacion_usuario` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int DEFAULT NULL,
  `id_publicacion` int DEFAULT NULL,
  PRIMARY KEY (`id_publicacion_usuario`),
  KEY `usuario_publicaciones_ususario_idx` (`id_usuario`),
  KEY `publicacion_publicaciones_usuario_idx` (`id_publicacion`),
  CONSTRAINT `publicacion_publicaciones_usuario` FOREIGN KEY (`id_publicacion`) REFERENCES `publicaciones` (`id_publicacion`),
  CONSTRAINT `usuario_publicaciones_ususario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publicaciones_usuario`
--

LOCK TABLES `publicaciones_usuario` WRITE;
/*!40000 ALTER TABLE `publicaciones_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `publicaciones_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_establecimiento`
--

DROP TABLE IF EXISTS `tipos_establecimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_establecimiento` (
  `id_tipo_establecimiento` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_establecimiento`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_establecimiento`
--

LOCK TABLES `tipos_establecimiento` WRITE;
/*!40000 ALTER TABLE `tipos_establecimiento` DISABLE KEYS */;
INSERT INTO `tipos_establecimiento` VALUES (1,'Escuela'),(2,'Area verde'),(3,'Salud'),(4,'Comercio');
/*!40000 ALTER TABLE `tipos_establecimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_inmueble`
--

DROP TABLE IF EXISTS `tipos_inmueble`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_inmueble` (
  `id_tipo_inmueble` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_inmueble`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_inmueble`
--

LOCK TABLES `tipos_inmueble` WRITE;
/*!40000 ALTER TABLE `tipos_inmueble` DISABLE KEYS */;
INSERT INTO `tipos_inmueble` VALUES (1,'Departamento');
/*!40000 ALTER TABLE `tipos_inmueble` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_interes`
--

DROP TABLE IF EXISTS `tipos_interes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_interes` (
  `id_tipo_interes` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_interes`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_interes`
--

LOCK TABLES `tipos_interes` WRITE;
/*!40000 ALTER TABLE `tipos_interes` DISABLE KEYS */;
/*!40000 ALTER TABLE `tipos_interes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_usuario`
--

DROP TABLE IF EXISTS `tipos_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_usuario` (
  `id_tipo_usuario` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_usuario`
--

LOCK TABLES `tipos_usuario` WRITE;
/*!40000 ALTER TABLE `tipos_usuario` DISABLE KEYS */;
INSERT INTO `tipos_usuario` VALUES (1,'Cliente'),(2,'Vendedor'),(3,'Administrador');
/*!40000 ALTER TABLE `tipos_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nombres` varchar(45) DEFAULT NULL,
  `apellidos` varchar(45) DEFAULT NULL,
  `edad` int DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `contraseña` varchar(30) DEFAULT NULL,
  `correo` varchar(60) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `id_tipo_usuario` int DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  KEY `tipo_usuario_usuarios_idx` (`id_tipo_usuario`),
  CONSTRAINT `tipo_usuario_usuarios` FOREIGN KEY (`id_tipo_usuario`) REFERENCES `tipos_usuario` (`id_tipo_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Elí','García Pérez',20,'2006-04-25','esotilin777','125052910@upq.edu.mx','4424746018',3),(2,'Yatzuri Yazmin','Garcidueñas Gonzales',18,NULL,'yatzuri123','',NULL,2),(3,'Aurora','García Zarazua',19,'2007-08-13','aurora123','125053451@upq.edu.mx','4411375845',1),(4,'María Fernanda','Rosales Sanchez',18,NULL,'fer123',NULL,NULL,1);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-27  9:20:08
