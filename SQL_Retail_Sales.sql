
-- SQL Retail Sales Analysis -
CREATE DATABASE Sql_Project_Retail_Sales

-- create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit DECIMAL(10,2),
	cogs DECIMAL(10,2),
	total_sale DECIMAL(10,2)

)


-- INSERT DATA INTO RETAIL SALES TABLE
BULK INSERT dbo.retail_sales
FROM 'C:\Users\sahil\Downloads\SQL - Retail Sales Analysis_utf .csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    TABLOCK
);
GO

-- DATA CLEANING AND ANALYSIS

select  *
from retail_sales
WHERE customer_id IS NULL
OR transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR quantity IS NULL
OR gender IS NULL
OR category IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale is null;

-- DELETE DATA

DELETE FROM retail_sales 
WHERE customer_id IS NULL
OR transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR quantity IS NULL
OR gender IS NULL
OR category IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale is null;

-- DATA EXPLORATION 

-- HOW MANY SALES WE HAVE

SELECT 
COUNT(*) AS TOTAL_SALE
FROM retail_sales

-- HOW MANY UNIQUE CUSTOMER WE HAVE
SELECT 
COUNT(DISTINCT customer_id) AS TOTAL_CUSTOMER
FROM retail_sales

-- HOW MANY CATEGORY WE HAVE
SELECT 
DISTINCT category AS TOTAL_CATEGORY
FROM retail_sales

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWER

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT 
*
FROM retail_sales
WHERE category = 'clothing'
AND quantity >= 4
AND sale_date > '2022-11-01'
AND sale_date < '2022-12-01'

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
category,
SUM(total_sale) AS TOTAL_SALES,
COUNT(*) AS TOTAL_ORDERS
FROM retail_sales
GROUP BY category


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
AVG(AGE) AS AVERAGE_AGE
FROM retail_sales
WHERE category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT 
*
FROM retail_sales
WHERE total_sale > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
category,
gender,
COUNT(transactions_id) TOTAL_TRANSACTION
FROM retail_sales
GROUP BY gender,category
ORDER BY 1

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT TOP 2
DATENAME(MONTH,sale_date) MONTH,
DATENAME(YEAR,sale_date) YEAR,
AVG(total_sale) AVERAGE_SALE
FROM retail_sales
GROUP BY DATENAME(MONTH,sale_date),DATENAME(YEAR,sale_date)
ORDER BY AVG(total_sale) DESC

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT TOP 5
customer_id,
SUM(total_sale) TOTAL_SALES
FROM retail_sales
GROUP BY customer_id
ORDER BY TOTAL_SALES DESC

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
category,
COUNT(DISTINCT customer_id) UNIQUE_NUMBER_OF_CUSTOMER
FROM retail_sales
GROUP BY category


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


WITH HOURLY_SALE AS
(
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'MORNING'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
            ELSE 'EVENING'
        END AS SHIFT
    FROM retail_sales
)

SELECT 
SHIFT,
COUNT(*) AS TOTAL_ORDERS
FROM HOURLY_SALE
GROUP BY SHIFT

-- END OF PROJECT