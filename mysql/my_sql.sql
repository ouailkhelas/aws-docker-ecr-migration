-- MySQL dump pour application Coffee Inventory
-- Base de données: COFFEE

CREATE DATABASE IF NOT EXISTS COFFEE;
USE COFFEE;

-- Structure de la table suppliers
DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE `suppliers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Données d'exemple (modifiées selon le TP - adresse "Container")
INSERT INTO `suppliers` VALUES 
(1,'Cafe Import','123 Main St','Seattle','WA','contact@cafeimport.com','555-0101'),
(2,'Bean Traders','456 Oak Ave','Portland','OR','info@beantraders.com','555-0102'),
(3,'Global Coffee Co','789 Pine Rd','San Francisco','CA','sales@globalcoffee.com','555-0103');

-- Mise à jour de l'adresse comme demandé dans le TP (étape 17)
UPDATE `suppliers` SET `address` = 'Container' WHERE `id` = 1;
EOF