# 1. Create a database called credit_card_classification.

CREATE DATABASE credit_card_classification;
USE credit_card_classification;

# 2. Create a table credit_card_data with the same columns as given in the csv file. Please make sure you use the correct data types for each of the columns.

DROP TABLE credit_card_data2;

CREATE TABLE credit_card_data (
	customer_number int NULL, 
    offer_accepted varchar(255) NULL, 
    reward varchar(255) NULL,
    mailer_type varchar(255) NULL,
    income_level varchar(255) NULL,
    bank_accounts_open int NULL, 
    overdraft_protection varchar(255) NULL,
    credit_rating varchar(255) NULL, 
    credit_cards_held int NULL, 
    homes_owned int NULL,
    household_size int NULL, 
    own_your_home varchar(255) NULL,
    average_balance decimal NULL, 
    balance_q1 decimal NULL, 
    balance_q2 decimal NULL, 
    balance_q3 decimal NULL, 
    balance_q4 decimal NULL
);

CREATE TABLE null_data (
	customer_number int NULL, 
    offer_accepted varchar(255) NULL, 
    reward varchar(255) NULL,
    mailer_type varchar(255) NULL,
    income_level varchar(255) NULL,
    bank_accounts_open int NULL, 
    overdraft_protection varchar(255) NULL,
    credit_rating varchar(255) NULL, 
    credit_cards_held int NULL, 
    homes_owned int NULL,
    household_size int NULL, 
    own_your_home varchar(255) NULL,
    average_balance decimal NULL, 
    balance_q1 decimal NULL, 
    balance_q2 decimal NULL, 
    balance_q3 decimal NULL, 
    balance_q4 decimal NULL
);

SELECT * FROM null_data;

Create Table credit_card_data1(
(SELECT 
  * 
   FROM credit_card_data
)
UNION
(
 SELECT 
  * 
   FROM null_data));
   SELECT * FROM credit_card_data1;

drop table credit_card_data;
drop table null_data;


# 3. Import the data from the csv file into the table. 
### Done with the import wizzard.

# 4. Select all the data from table credit_card_data to check if the data was imported correctly.

SELECT * FROM credit_card_data;

# 5. Use the alter table command to drop the column q4_balance from the database, as we would not use it in the analysis with SQL. 
# Select all the data from the table to verify if the command worked. Limit your returned results to 10.

ALTER TABLE credit_card_data
DROP COLUMN balance_q4;

SELECT * FROM credit_card_data
LIMIT 10;

# 6. Use sql query to find how many rows of data you have.

SELECT COUNT(*) FROM credit_card_data;
### 17976 rows

# 7. Now we will try to find the unique values in some of the categorical columns:

## What are the unique values in the column Offer_accepted?

SELECT DISTINCT(offer_accepted) FROM credit_card_data;
### Yes, No

## What are the unique values in the column Reward?

SELECT DISTINCT(reward) FROM credit_card_data;
### Air Miles, Cash Back, Points

## What are the unique values in the column mailer_type?

SELECT DISTINCT(mailer_type) FROM credit_card_data;
### Letter, Postcard

## What are the unique values in the column credit_cards_held?

SELECT DISTINCT(credit_cards_held) FROM credit_card_data;
### 1, 2, 3, 4

## What are the unique values in the column household_size?

SELECT DISTINCT(household_size) FROM credit_card_data
ORDER BY household_size;
### 1, 2, 3, 4, 5, 6, 8, 9

# 8. Arrange the data in a decreasing order by the average_balance of the customer. 
# Return only the customer_number of the top 10 customers with the highest average_balances in your data.

SELECT customer_number FROM credit_card_data
ORDER BY average_balance DESC
LIMIT 10;
### 2297, 12636, 8888, 10577, 14004, 10476, 2656, 15260, 15609, 8778

# 9. What is the average balance of all the customers in your data?

SELECT ROUND(AVG(average_balance), 2) FROM credit_card_data;
### 940.64

# 10. In this exercise we will use simple group_by to check the properties of some of the categorical variables in our data. 
# Note wherever average_balance is asked, please take the average of the column average_balance:

## What is the average balance of the customers grouped by Income Level? 
## The returned result should have only two columns, income level and Average balance of the customers. Use an alias to change the name of the second column.

SELECT income_level, ROUND(AVG(average_balance), 2) AS income_avg_balance
FROM credit_card_data
GROUP BY income_level
ORDER BY income_avg_balance DESC;
### High: 942.70, Medium: 941.01, Low: 937.79

## What is the average balance of the customers grouped by number_of_bank_accounts_open? 
## The returned result should have only two columns, number_of_bank_accounts_open and Average balance of the customers. Use an alias to change the name of the second column.

SELECT bank_accounts_open, ROUND(AVG(average_balance), 2) AS accounts_avg_balance
FROM credit_card_data
GROUP BY bank_accounts_open
ORDER BY bank_accounts_open;
### 1: 941.66, 2: 936.59, 3: 948.43

## What is the average number of credit cards held by customers for each of the credit card ratings? 
## The returned result should have only two columns, rating and average number of credit cards held. Use an alias to change the name of the second column.

SELECT credit_rating, ROUND(AVG(credit_cards_held), 2) as avg_num_cards
FROM credit_card_data
GROUP BY credit_rating
ORDER BY avg_num_cards;
### High and Low: 1.90, Medium: 1.91

## Is there any correlation between the columns credit_cards_held and number_of_bank_accounts_open? 
## You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. 
## Visually check if there is a positive correlation or negative correlation or no correlation between the variables.

SELECT bank_accounts_open, AVG(credit_cards_held) AS avg_num_cards
FROM credit_card_data
GROUP BY bank_accounts_open;

SELECT credit_cards_held, AVG(bank_accounts_open) AS avg_num_accounts
FROM credit_card_data
GROUP BY credit_cards_held
ORDER BY credit_cards_held;

### No correlation between these two variables.

# 11. Your managers are only interested in the customers with the following properties:
## Credit rating medium or high
## Credit cards held 2 or less
## Owns their own home
## Household size 3 or more
# For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them? 

SELECT * FROM credit_card_data
WHERE	credit_rating = ("Medium" OR "High") AND 
		credit_cards_held <= 2 AND
        own_your_home = "Yes" AND
        household_size >= 3;

# Can you filter the customers who accepted the offers here?
        
SELECT * FROM credit_card_data
WHERE	credit_rating = ("Medium" OR "High") AND 
		credit_cards_held <= 2 AND
        own_your_home = "Yes" AND
        household_size >= 3 AND
        offer_accepted = "Yes";
        
# 12. Your managers want to find out the list of customers whose average balance is less than the average balance of all the customers in the database. 
# Write a query to show them the list of such customers. You might need to use a subquery for this problem.

SELECT * FROM credit_card_data
WHERE average_balance < (SELECT AVG(average_balance) FROM credit_card_data);

# 13. Since this is something that the senior management is regularly interested in, create a view of the same query.

CREATE VIEW low_avg_balance AS
SELECT * FROM credit_card_data
WHERE average_balance < (SELECT AVG(average_balance) FROM credit_card_data);

# 14. What is the number of people who accepted the offer vs number of people who did not?

SELECT offer_accepted, COUNT(*) as customer_count
FROM credit_card_data 
GROUP BY offer_accepted 
ORDER BY customer_count DESC;
### No: 16955, Yes: 1021

# 15. Your managers are more interested in customers with a credit rating of high or medium. 
# What is the difference in average balances of the customers with high credit card rating and low credit card rating?

SELECT 	credit_rating, AVG(average_balance) AS avg_balance
FROM credit_card_data
WHERE credit_rating = "Low" OR credit_rating = "High"
GROUP BY credit_rating
ORDER BY avg_balance DESC;

WITH rating_balance AS (SELECT credit_rating, AVG(average_balance) AS avg_balance
FROM credit_card_data
GROUP BY credit_rating)
SELECT (SELECT avg_balance FROM rating_balance
WHERE credit_rating = "High") - 
(SELECT avg_balance FROM rating_balance
WHERE credit_rating = "Low") 
AS high_low_difference
FROM rating_balance
GROUP BY high_low_difference;

### The difference is 4.04

# 16. In the database, which all types of communication (mailer_type) were used and with how many customers?

SELECT DISTINCT(mailer_type), COUNT(*) as customer_count
FROM credit_card_data
GROUP BY mailer_type
ORDER BY customer_count DESC;
### Postcard: 9134, Letter: 8842

# 17. Provide the details of the customer that is the 11th least Q1_balance in your database.

WITH ranking_table AS 
(SELECT *, DENSE_RANK() OVER (ORDER BY balance_q1 ASC) AS ranking
FROM credit_card_data)
SELECT * FROM ranking_table
WHERE ranking = 11;
### 3 customers with the 11th rank: '12905', '3542', '16031'.