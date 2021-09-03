-- disable safe mode in workbench

SET SQL_SAFE_UPDATES = 0;

-- Q1 - DB creation

CREATE DATABASE IF NOT EXISTS credit_card_classification;
USE credit_card_classification;


-- Q2 - Create a table credit_card_data with the same columns as given in the csv file.

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


--  Q4 - Select all the data from table credit_card_data to check if the data was imported correctly

SELECT * FROM credit_card_data;


-- Q5  - Use the alter table command to drop the column q4_balance from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.

ALTER TABLE credit_card_data
DROP COLUMN Q4_Balance;


-- Q6 - Use sql query to find how many rows of data you have

SELECT COUNT(*) FROM credit_card_data;


-- Q7 - Now we will try to find the unique values in some of the categorical columns

SELECT DISTINCT offer_accepted
FROM credit_card_data;

SELECT DISTINCT reward
FROM credit_card_data;

SELECT DISTINCT mailer_type
FROM credit_card_data;

SELECT DISTINCT credit_cards_held
FROM credit_card_data;

SELECT DISTINCT household_size
FROM credit_card_data;


-- Q8 - Arrange the data in a decreasing order by the average_balance of the house.
-- Return only the customer_number of the top 10 customers with the highest average_balances in your data.

SELECT customer_number, average_balance 
FROM (
	SELECT *, RANK() OVER(ORDER BY average_balance DESC) AS avg_balance_ranking
	FROM credit_card_data
	ORDER BY average_balance DESC
    ) sub_rank
WHERE avg_balance_ranking <= 10;


-- Q9 - What is the average balance of all the customers in your data?

SELECT ROUND(SUM(average_balance)/COUNT(*), 2) AS total_avg_balance
FROM credit_card_data;


-- Q10 - In this exercise we will use group by to check the properties of some of the categorical variables in our data. Note wherever average_balance is asked in the questions below, please take the average of the column average_balance

-- average balance of the customers grouped by `Income Level` 

SELECT income_level, ROUND(SUM(average_balance)/COUNT(*), 2) AS avg_balance -- SUM(average_balance)/COUNT(*) = AVG(average_balance)
FROM credit_card_data
GROUP BY income_level;

-- average balance of the customers grouped by `number_of_bank_accounts_open`

SELECT bank_accounts_open, ROUND(AVG(average_balance), 2) AS avg_balance
FROM credit_card_data
GROUP BY bank_accounts_open;

-- average number of credit cards held by customers for each of the credit card ratings

SELECT credit_rating, ROUND(AVG(credit_cards_held), 3) AS avg_no_creditcards
FROM credit_card_data
GROUP BY credit_rating;

-- Is there any correlation between the columns `credit_cards_held` and `number_of_bank_accounts_open`? 

SELECT bank_accounts_open, AVG(credit_cards_held) AS avg_no_creditcards, COUNT(*) AS customer_count
FROM credit_card_data
GROUP BY bank_accounts_open
ORDER BY 1;

SELECT credit_cards_held, AVG(bank_accounts_open) AS avg_no_accounts, COUNT(*) AS customer_count
FROM credit_card_data
GROUP BY credit_cards_held
ORDER BY 1;

-- there seems to be no simple correlation between the 2 variables that you can discern by a query


-- Q11 - Your managers are only interested in the customers with the following properties: Credit rating medium or high, Credit cards held 2 or less, Owns their own home, Household size 3 or more

SELECT *
FROM credit_card_data
WHERE credit_rating IN ('Medium', 'High')
AND credit_cards_held <= 2
AND own_your_home = 'Yes'
AND household_size >= 3;

-- Can you filter the customers who accepted the offers here?

SELECT * FROM (
	SELECT *
	FROM credit_card_data
	WHERE credit_rating IN ('Medium', 'High')
	AND credit_cards_held <= 2
	AND own_your_home = 'Yes'
	AND household_size >= 3) s1
WHERE offer_accepted = 'Yes';


-- Q12 - Your managers want to find out the list of customers whose average balance is less than the average balance of all the customers in the database.

SELECT *
FROM credit_card_data
WHERE average_balance < (
	SELECT ROUND(AVG(average_balance), 2) AS total_avg_balance 
    FROM credit_card_data
    );


-- Q13 - Since this is something that the senior management is regularly interested in, create a view called Customers__Balance_View1 of the same query.

CREATE VIEW Customers__Balance_View1 AS 
SELECT *
FROM credit_card_data
WHERE average_balance < (
	SELECT ROUND(AVG(average_balance), 2) AS avg_balance_total 
    FROM credit_card_data
    );


-- Q14 - What is the number of people who accepted the offer vs number of people who did not?

SELECT offer_accepted, COUNT(*) AS customer_count
FROM credit_card_data
GROUP BY offer_accepted;


-- Q15 - Your managers are more interested in customers with a credit rating of high or medium. What is the difference in average balances of the customers with high credit card rating and low credit card rating?

SELECT credit_rating, ROUND(AVG(average_balance), 2) AS avg_balance
FROM credit_card_data
GROUP BY credit_rating;


-- Q16 - In the database, which all types of communication (mailer_type) were used and with how many customers?

SELECT mailer_type, COUNT(*) AS customer_count
FROM credit_card_data
GROUP BY mailer_type;


-- Q17 - Provide the details of the customer that is the 11th least Q1_balance in your database.

SELECT *
FROM (
	SELECT *, DENSE_RANK() OVER(ORDER BY q1_balance) AS q1_ranking
	FROM credit_card_data
    ) sub_rank
WHERE q1_ranking = 11;

