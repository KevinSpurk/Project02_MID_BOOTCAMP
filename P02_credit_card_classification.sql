-- disable safe mode in workbench
SET SQL_SAFE_UPDATES = 0;

-- enable bulk inserts
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

-- DB creation
CREATE DATABASE IF NOT EXISTS credit_card_classification;
USE credit_card_classification;

-- table creation
CREATE TABLE credit_card_data (
  `A1` int(11) UNIQUE NOT NULL,
  `A2` char(20) DEFAULT NULL,
  `A3` varchar(20) DEFAULT NULL,
  `A4` int(11) DEFAULT NULL,
  `A5` int(11) DEFAULT NULL,
  `A6` int(11) DEFAULT NULL,
  `A7` int(11) DEFAULT NULL,
  `A8` int(11) DEFAULT NULL,
  `A9` int(11) DEFAULT NULL,
  `A10` float DEFAULT NULL,
  `A11` int(11) DEFAULT NULL,
  `A12` float DEFAULT NULL,
  `A13` float DEFAULT NULL,
  `A14` int(11) DEFAULT NULL,
  `A15` int(11) DEFAULT NULL,
  `A16` int(11) DEFAULT NULL,
  CONSTRAINT PRIMARY KEY (A1)  -- constraint keyword is optional but its a good practice
);