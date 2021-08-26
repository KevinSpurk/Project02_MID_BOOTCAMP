-- disable safe mode in workbench
SET SQL_SAFE_UPDATES = 0;

-- Q1 - DB creation
CREATE DATABASE IF NOT EXISTS credit_card_classification;
USE credit_card_classification;

-- Q2 - table creation
CREATE TABLE credit_card_data (
  `Customer_Number` SMALLINT(6) UNIQUE NOT NULL,
  `Offer_Accepted` VARCHAR(4) DEFAULT NULL,
  `Reward` VARCHAR(12) DEFAULT NULL,
  `Mailer_Type` VARCHAR(12) DEFAULT NULL,
  `Income_Level` VARCHAR(12) DEFAULT NULL,
  `Bank_Accounts_Open` TINYINT(2) DEFAULT NULL,
  `Overdraft_Protection` VARCHAR(4) DEFAULT NULL,
  `Credit_Rating` VARCHAR(12) DEFAULT NULL,
  `Credit_Cards_Held` TINYINT(2) DEFAULT NULL,
  `#_Homes_Owned` TINYINT(2) DEFAULT NULL,
  `Household_Size` TINYINT(2) DEFAULT NULL,
  `Own_Your_Home` VARCHAR(4) DEFAULT NULL,
  `Average_Balance` FLOAT DEFAULT NULL,
  `Q1_Balance` INT(11) DEFAULT NULL,
  `Q2_Balance` INT(11) DEFAULT NULL,
  `Q3_Balance` INT(11) DEFAULT NULL,
  `Q4_Balance` INT(11) DEFAULT NULL,
  CONSTRAINT PRIMARY KEY (Customer_Number)
);

-- Q3 - enable bulk inserts, import via import wizard
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

--  Q4 
SELECT * FROM credit_card_data
LIMIT 100;

-- Q5 
ALTER TABLE credit_card_data
DROP COLUMN Q4_Balance;

-- Q6 
SELECT COUNT(*) FROM credit_card_data;

drop table if exists credit_card_data;

