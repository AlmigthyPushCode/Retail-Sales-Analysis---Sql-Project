-- Retail Sales Analysis SQL Queries

-- Database Setup
CREATE DATABASE IF NOT EXISTS retail_sales_db;
USE retail_sales_db;

DROP TABLE IF EXISTS RETAIL_SALES;
CREATE TABLE RETAIL_SALES (
    transactions_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_date DATE NOT NULL,
    sale_time TIME NOT NULL,
    customer_id INT NOT NULL,
    gender VARCHAR(20) NOT NULL,
    age INT,
    category VARCHAR(50) NOT NULL,
    quantity INT,
    price_per_unit DECIMAL(10,2) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    total_sale DECIMAL(10,2)
);

-- Data Cleaning Queries
SELECT * FROM RETAIL_SALES
WHERE customer_id IS NULL OR gender IS NULL OR age IS NULL OR 
      category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

SET @avg_age = (SELECT AVG(age) FROM RETAIL_SALES WHERE age IS NOT NULL);
UPDATE RETAIL_SALES SET age = @avg_age WHERE age IS NULL;

SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM RETAIL_SALES;
SELECT DISTINCT category FROM RETAIL_SALES;

-- Sales Analysis Queries
SELECT category, SUM(total_sale) AS total_revenue
FROM RETAIL_SALES
GROUP BY category
ORDER BY total_revenue DESC;

SELECT gender, COUNT(*) AS total_transactions
FROM RETAIL_SALES
GROUP BY gender;

SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month, SUM(total_sale) AS monthly_sales
FROM RETAIL_SALES
GROUP BY month
ORDER BY month;

SELECT category, COUNT(*) AS sales_count
FROM RETAIL_SALES
GROUP BY category
ORDER BY sales_count DESC
LIMIT 5;

SELECT customer_id, AVG(total_sale) AS avg_spending
FROM RETAIL_SALES
GROUP BY customer_id
ORDER BY avg_spending DESC;

SELECT * FROM RETAIL_SALES
WHERE total_sale > 1000;

SELECT year, month, avg_sale
FROM (
    SELECT EXTRACT(YEAR FROM sale_date) AS year,
           EXTRACT(MONTH FROM sale_date) AS month,
           AVG(total_sale) AS avg_sale,
           RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM RETAIL_SALES
    GROUP BY 1, 2
) AS sales_ranked
WHERE rank = 1;

SELECT customer_id, SUM(total_sale) AS total_sales
FROM RETAIL_SALES
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM RETAIL_SALES
GROUP BY category;

WITH hourly_sales AS (
    SELECT *,
           CASE 
               WHEN HOUR(sale_time) < 12 THEN 'Morning'
               WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM RETAIL_SALES
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;
