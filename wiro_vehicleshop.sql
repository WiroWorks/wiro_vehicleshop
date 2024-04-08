-- --------------------------------------------------------
-- Sunucu:                       127.0.0.1
-- Sunucu sürümü:                10.4.24-MariaDB - mariadb.org binary distribution
-- Sunucu İşletim Sistemi:       Win64
-- HeidiSQL Sürüm:               12.0.0.6468
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- gameflix için veritabanı yapısı dökülüyor
CREATE DATABASE IF NOT EXISTS `gameflix` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;
USE `gameflix`;

-- tablo yapısı dökülüyor gameflix.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `name` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `model` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) COLLATE utf8mb4_bin DEFAULT NULL,
  `stock` int(3) DEFAULT 10,
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- gameflix.vehicles: ~221 rows (yaklaşık) tablosu için veriler indiriliyor
DELETE FROM `vehicles`;
INSERT INTO `vehicles` (`name`, `model`, `price`, `category`, `stock`) VALUES
	('Akuma', 'AKUMA', 13000, 'motorcycles', 9),
	('Adder', 'adder', 900000, 'super', 9),
	('Alpha', 'alpha', 60000, 'sports', 10),
	('Asea', 'asea', 5500, 'sedans', 8),
	('Autarch', 'autarch', 1955000, 'super', 10),
	('Avarus', 'avarus', 60000, 'motorcycles', 10),
	('Baller', 'baller2', 500000, 'suvs', 10),
	('Baller Sport', 'baller3', 580000, 'suvs', 10),
	('Banshee', 'banshee', 70000, 'sports', 10),
	('Banshee 900R', 'banshee2', 255000, 'super', 8),
	('Bati 801', 'bati', 80000, 'motorcycles', 9),
	('Bestia GTS', 'bestiagts', 55000, 'sports', 10),
	('BF400', 'bf400', 25000, 'motorcycles', 10),
	('Bf Injection', 'bfinjection', 16000, 'offroad', 10),
	('Bifta', 'bifta', 45000, 'offroad', 10),
	('Bison', 'bison', 45000, 'vans', 10),
	('Blade', 'blade', 120000, 'muscle', 8),
	('Blazer', 'blazer', 6500, 'offroad', 10),
	('Blazer Sport', 'blazer4', 8500, 'offroad', 10),
	('blazer5', 'blazer5', 1755600, 'offroad', 10),
	('Blista', 'blista', 8000, 'compacts', 0),
	('BMW M5', 'bmci', 999999999, 'a', 10),
	('BMX (velo)', 'bmx', 5000, 'motorcycles', 10),
	('Bobcat XL', 'bobcatxl', 32000, 'vans', 10),
	('Brawler', 'brawler', 450000, 'offroad', 10),
	('Brioso R/A', 'brioso', 18000, 'compacts', 8),
	('Btype', 'btype', 62000, 'sportsclassics', 9),
	('Btype Hotroad', 'btype2', 450000, 'sportsclassics', 10),
	('Btype Luxe', 'btype3', 85000, 'sportsclassics', 10),
	('Buccaneer', 'buccaneer', 180000, 'muscle', 10),
	('Buccaneer Rider', 'buccaneer2', 175000, 'muscle', 10),
	('Buffalo', 'buffalo', 12000, 'sports', 10),
	('Buffalo S', 'buffalo2', 20000, 'sports', 10),
	('Bullet', 'bullet', 375000, 'super', 10),
	('Burrito', 'burrito3', 19000, 'vans', 10),
	('Camper', 'camper', 42000, 'vans', 10),
	('Carbonizzare', 'carbonizzare', 75000, 'sports', 10),
	('Carbon RS', 'carbonrs', 95000, 'motorcycles', 10),
	('Casco', 'casco', 30000, 'sportsclassics', 10),
	('Cavalcade', 'cavalcade2', 55000, 'suvs', 10),
	('Cheetah', 'cheetah', 375000, 'super', 10),
	('Chimera', 'chimera', 66, 'motorcycles', 10),
	('Chino', 'chino', 80000, 'muscle', 10),
	('Chino Luxe', 'chino2', 100000, 'muscle', 10),
	('Bugatti Chiron', 'chiron17', 999999999, 'a', 10),
	('Cliffhanger', 'cliffhanger', 45000, 'motorcycles', 10),
	('Cognoscenti Cabrio', 'cogcabrio', 55000, 'coupes', 3),
	('Cognoscenti', 'cognoscenti', 55000, 'sedans', 10),
	('Comet', 'comet2', 65000, 'sports', 10),
	('Comet 5', 'comet5', 1145000, 'sports', 10),
	('Contender', 'contender', 70000, 'suvs', 10),
	('Coquette', 'coquette', 65000, 'sportsclassics', 10),
	('Coquette Classic', 'coquette2', 40000, 'sportsclassics', 10),
	('Coquette BlackFin', 'coquette3', 55000, 'muscle', 10),
	('Cruiser (velo)', 'cruiser', 7500, 'motorcycles', 10),
	('Daemon', 'daemon', 100000, 'motorcycles', 10),
	('Daemon High', 'daemon2', 95000, 'motorcycles', 10),
	('Dominator', 'dominator', 55000, 'muscle', 10),
	('Double T', 'double', 28000, 'motorcycles', 10),
	('F8 Drafter', 'drafter', 450000, 'sports', 10),
	('Dubsta', 'dubsta', 850000, 'suvs', 10),
	('Dubsta Luxuary', 'dubsta2', 1000000, 'suvs', 10),
	('Bubsta 6x6', 'dubsta3', 1250000, 'offroad', 10),
	('Dukes', 'dukes', 28000, 'muscle', 10),
	('Dune Buggy', 'dune', 8000, 'offroad', 10),
	('Mercedes Benzo', 'e63amg', 999999999, 'a', 10),
	('Elegy', 'elegy2', 38500, 'sports', 10),
	('Emperor', 'emperor', 8500, 'sedans', 10),
	('Enduro', 'enduro', 5500, 'motorcycles', 10),
	('Entity XF', 'entityxf', 1000000, 'super', 10),
	('Esskey', 'esskey', 10000, 'motorcycles', 10),
	('Exemplar', 'exemplar', 32000, 'coupes', 10),
	('F620', 'f620', 65000, 'coupes', 10),
	('Faction', 'faction', 20000, 'muscle', 10),
	('Faction Rider', 'faction2', 30000, 'muscle', 10),
	('Faction XL', 'faction3', 75000, 'muscle', 10),
	('Faggio', 'faggio', 1900, 'motorcycles', 10),
	('Vespa', 'faggio2', 2800, 'motorcycles', 10),
	('Felon', 'felon', 42000, 'coupes', 10),
	('Felon GT', 'felon2', 70000, 'coupes', 10),
	('Feltzer', 'feltzer2', 55000, 'sports', 10),
	('Stirling GT', 'feltzer3', 65000, 'sportsclassics', 10),
	('Fixter (velo)', 'fixter', 225, 'motorcycles', 10),
	('FMJ', 'fmj', 1250000, 'super', 10),
	('Fhantom', 'fq2', 80000, 'suvs', 10),
	('Fugitive', 'fugitive', 12000, 'sedans', 10),
	('Furore GT', 'furoregt', 45000, 'sports', 10),
	('Fusilade', 'fusilade', 40000, 'sports', 10),
	('Gargoyle', 'gargoyle', 120000, 'motorcycles', 10),
	('Gauntlet', 'gauntlet', 30000, 'muscle', 10),
	('Gang Burrito', 'gburrito', 45000, 'vans', 10),
	('Burrito', 'gburrito2', 29000, 'vans', 10),
	('Glendale', 'glendale', 6500, 'sedans', 10),
	('Grabger', 'granger', 120000, 'suvs', 10),
	('Gresley', 'gresley', 47500, 'suvs', 10),
	('GT 500', 'gt500', 785000, 'sportsclassics', 10),
	('Guardian', 'guardian', 250000, 'offroad', 10),
	('Hakuchou', 'hakuchou', 150000, 'motorcycles', 9),
	('Hakuchou Sport', 'hakuchou2', 350000, 'motorcycles', 10),
	('Hermes', 'hermes', 950000, 'muscle', 10),
	('Hexer', 'hexer', 125000, 'motorcycles', 10),
	('Hotknife', 'hotknife', 125000, 'muscle', 10),
	('Huntley S', 'huntley', 40000, 'suvs', 10),
	('Hustler', 'hustler', 625000, 'muscle', 10),
	('Infernus', 'infernus', 180000, 'super', 10),
	('Innovation', 'innovation', 130750, 'motorcycles', 10),
	('Intruder', 'intruder', 7500, 'sedans', 10),
	('Issi', 'issi2', 10000, 'compacts', 9),
	('İssi7', 'issi7', 220000, 'sports', 10),
	('Jester', 'jester', 950000, 'sports', 10),
	('Journey', 'journey', 6500, 'vans', 10),
	('Kamacho', 'kamacho', 345000, 'offroad', 10),
	('Khamelion', 'khamelion', 38000, 'sports', 10),
	('Krieger', 'krieger', 2000000, 'super', 8),
	('Kuruma', 'kuruma', 240750, 'sports', 10),
	('Landstalker', 'landstalker', 35000, 'suvs', 10),
	('Lynx', 'lynx', 180000, 'sports', 10),
	('Mamba', 'mamba', 70000, 'sports', 10),
	('Manana', 'manana', 12800, 'sportsclassics', 10),
	('Massacro', 'massacro', 65000, 'sports', 10),
	('Massacro(Racecar)', 'massacro2', 130000, 'sports', 10),
	('Mesa', 'mesa', 16000, 'suvs', 10),
	('Mesa Trail', 'mesa3', 40000, 'suvs', 10),
	('Minivan', 'minivan', 13000, 'vans', 10),
	('Monroe', 'monroe', 55000, 'sportsclassics', 10),
	('Moonbeam', 'moonbeam', 18000, 'vans', 10),
	('Moonbeam Rider', 'moonbeam2', 35000, 'vans', 10),
	('Nemesis', 'nemesis', 35000, 'motorcycles', 10),
	('Neon', 'neon', 1500000, 'sports', 10),
	('Nightblade', 'nightblade', 400000, 'motorcycles', 10),
	('Nightshade', 'nightshade', 65000, 'muscle', 10),
	('9F', 'ninef', 250000, 'sports', 10),
	('9F Cabrio', 'ninef2', 350000, 'sports', 10),
	('Omnis', 'omnis', 70500, 'sports', 10),
	('Oracle XS', 'oracle2', 35000, 'coupes', 10),
	('Osiris', 'osiris', 1850750, 'super', 9),
	('Panto', 'panto', 10000, 'compacts', 8),
	('Paradise', 'paradise', 19000, 'vans', 10),
	('Pariah', 'pariah', 1420000, 'sports', 10),
	('Patriot', 'patriot', 350000, 'suvs', 10),
	('Penumbra', 'penumbra', 28000, 'sports', 10),
	('Pfister', 'pfister811', 285500, 'super', 10),
	('Phoenix', 'phoenix', 250000, 'muscle', 10),
	('Picador', 'picador', 18000, 'muscle', 10),
	('Pigalle', 'pigalle', 20000, 'sportsclassics', 10),
	('Prairie', 'prairie', 12000, 'compacts', 10),
	('Premier', 'premier', 8000, 'sedans', 10),
	('Primo Custom', 'primo2', 14000, 'sedans', 10),
	('X80 Proto', 'prototipo', 7000000, 'super', 10),
	('Radius', 'radi', 29000, 'suvs', 10),
	('raiden', 'raiden', 1375000, 'sports', 10),
	('Rapid GT', 'rapidgt', 35000, 'sports', 10),
	('Rapid GT Convertible', 'rapidgt2', 45000, 'sports', 10),
	('Rapid GT3', 'rapidgt3', 885000, 'sportsclassics', 10),
	('Reaper', 'reaper', 680750, 'super', 10),
	('Rebel', 'rebel2', 35000, 'offroad', 10),
	('Regina', 'regina', 5000, 'sedans', 10),
	('Retinue', 'retinue', 615000, 'sportsclassics', 10),
	('Revolter', 'revolter', 1610000, 'sports', 10),
	('riata', 'riata', 380000, 'offroad', 10),
	('Rumpo', 'rumpo', 15000, 'vans', 10),
	('Rumpo Trail', 'rumpo3', 19500, 'vans', 10),
	('Sabre Turbo', 'sabregt', 20000, 'muscle', 10),
	('Sabre GT', 'sabregt2', 25000, 'muscle', 10),
	('Sanchez', 'sanchez', 35000, 'motorcycles', 10),
	('Sanchez Sport', 'sanchez2', 40000, 'motorcycles', 10),
	('Sanctus', 'sanctus', 650000, 'motorcycles', 10),
	('Sandking', 'sandking', 150000, 'offroad', 10),
	('Savestra', 'savestra', 990000, 'sportsclassics', 10),
	('Lamborghini Aventador', 'sc18', 999999999, 'a', 10),
	('Schafter', 'schafter2', 25000, 'sedans', 10),
	('Schafter V12', 'schafter3', 50000, 'sports', 10),
	('Seminole', 'seminole', 25000, 'suvs', 10),
	('Sentinel', 'sentinel', 32000, 'coupes', 10),
	('Sentinel XS', 'sentinel2', 40000, 'coupes', 10),
	('Sentinel3', 'sentinel3', 650000, 'sports', 10),
	('Seven 70', 'seven70', 39500, 'sports', 10),
	('Slam Van', 'slamvan3', 55000, 'muscle', 10),
	('Stinger', 'stinger', 80000, 'sportsclassics', 10),
	('Stinger GT', 'stingergt', 75000, 'sportsclassics', 10),
	('Streiter', 'streiter', 500000, 'sports', 10),
	('Stretch', 'stretch', 90000, 'sedans', 10),
	('Stromberg', 'stromberg', 3185350, 'sports', 10),
	('Sultan', 'sultan', 15000, 'sports', 10),
	('Sultan RS', 'sultanrs', 85000, 'super', 10),
	('Super Diamond', 'superd', 130000, 'sedans', 10),
	('Surano', 'surano', 50000, 'sports', 10),
	('Surfer', 'surfer', 12000, 'vans', 10),
	('T20', 't20', 3000000, 'super', 10),
	('Tailgater', 'tailgater', 30000, 'sedans', 10),
	('Tampa', 'tampa', 16000, 'muscle', 10),
	('Drift Tampa', 'tampa2', 3750750, 'sports', 10),
	('Thrust', 'thrust', 125000, 'motorcycles', 10),
	('Tri bike (velo)', 'tribike3', 4500, 'motorcycles', 10),
	('Turismo R', 'turismor', 350000, 'super', 10),
	('Tyrus', 'tyrus', 600000, 'super', 10),
	('Vacca', 'vacca', 120000, 'super', 10),
	('Vader', 'vader', 40000, 'motorcycles', 10),
	('Verlierer', 'verlierer2', 70000, 'sports', 10),
	('Vigero', 'vigero', 12500, 'muscle', 10),
	('Virgo', 'virgo', 14000, 'muscle', 10),
	('Viseris', 'viseris', 875000, 'sportsclassics', 10),
	('Visione', 'visione', 2250000, 'super', 10),
	('Voltic', 'voltic', 190000, 'super', 10),
	('Voodoo', 'voodoo', 25750, 'muscle', 10),
	('Warrener', 'warrener', 4000, 'sedans', 10),
	('Washington', 'washington', 9000, 'sedans', 10),
	('Windsor', 'windsor', 95000, 'coupes', 10),
	('Windsor Drop', 'windsor2', 125000, 'coupes', 10),
	('Woflsbane', 'wolfsbane', 220000, 'motorcycles', 10),
	('XLS', 'xls', 32000, 'suvs', 10),
	('Yosemite', 'yosemite', 1250000, 'muscle', 10),
	('Youga', 'youga', 10800, 'vans', 10),
	('Youga Luxuary', 'youga2', 14500, 'vans', 10),
	('Z190', 'z190', 900000, 'sportsclassics', 10),
	('Zentorno', 'zentorno', 1500000, 'super', 9),
	('Zion', 'zion', 36000, 'coupes', 10),
	('Zion Cabrio', 'zion2', 45000, 'coupes', 10),
	('Zombie', 'zombiea', 220000, 'motorcycles', 10),
	('Zombie Luxuary', 'zombieb', 230000, 'motorcycles', 10),
	('Z-Type', 'ztype', 220000, 'sportsclassics', 10);

-- tablo yapısı dökülüyor gameflix.vehicleshopcars
CREATE TABLE IF NOT EXISTS `vehicleshopcars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicleShopId` int(11) DEFAULT NULL,
  `carName` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `carPlate` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `carColor` int(11) DEFAULT NULL,
  `carColor2` int(11) DEFAULT NULL,
  `carTakeableDate` datetime DEFAULT NULL,
  `isCarTaken` int(1) DEFAULT 0,
  `factoryPrice` int(11) DEFAULT NULL,
  `billPayerName` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `billAmount` int(11) DEFAULT NULL,
  `billText` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL,
  `billDate` datetime DEFAULT NULL,
  `billCreatorName` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- gameflix.vehicleshopcars: ~0 rows (yaklaşık) tablosu için veriler indiriliyor
DELETE FROM `vehicleshopcars`;

-- tablo yapısı dökülüyor gameflix.vehicleshops
CREATE TABLE IF NOT EXISTS `vehicleshops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jobName` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `name` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `ownerIdentifier` varchar(80) COLLATE utf8mb4_bin DEFAULT '{}',
  `employees` longtext COLLATE utf8mb4_bin DEFAULT '{}',
  `IBAN` varchar(6) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- gameflix.vehicleshops: ~1 rows (yaklaşık) tablosu için veriler indiriliyor
DELETE FROM `vehicleshops`;
INSERT INTO `vehicleshops` (`id`, `jobName`, `name`, `ownerIdentifier`, `employees`, `IBAN`) VALUES
	(2, 'dealer1', 'Vehicle Shop 1', '', '{}', 'WRVS11');

-- tablo yapısı dökülüyor gameflix.vehicle_categories
CREATE TABLE IF NOT EXISTS `vehicle_categories` (
  `name` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- gameflix.vehicle_categories: ~12 rows (yaklaşık) tablosu için veriler indiriliyor
DELETE FROM `vehicle_categories`;
INSERT INTO `vehicle_categories` (`name`, `label`) VALUES
	('a', 'Bağışçı Araçları'),
	('compacts', 'Compacts'),
	('coupes', 'Coupés'),
	('motorcycles', 'Motos'),
	('muscle', 'Muscle'),
	('offroad', 'Off Road'),
	('sedans', 'Sedans'),
	('sports', 'Sports'),
	('sportsclassics', 'Sports Classics'),
	('super', 'Super'),
	('suvs', 'SUVs'),
	('vans', 'Vans');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
