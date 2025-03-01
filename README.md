# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Date**: 2025-03-01  
**Database**: `retail_sales_db`  

This project demonstrates SQL skills typically used by data analysts to explore, clean, and analyze retail sales data. It includes database setup, data cleaning, exploratory data analysis (EDA), and business insights using SQL queries.

---

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database.
2. **Data Cleaning**: Identify and handle missing or incorrect values.
3. **Exploratory Data Analysis (EDA)**: Understand the dataset through SQL queries.
4. **Business Analysis**: Use SQL to generate insights about customer behavior and sales performance.

---

## Project Structure

### **1. Database Setup**

```sql
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
```

---

### **2. Data Cleaning & Exploration**

#### **Check for Missing Values**
```sql
SELECT * FROM RETAIL_SALES
WHERE customer_id IS NULL OR gender IS NULL OR age IS NULL OR
      category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

#### **Fill Missing Age with Average Age**
```sql
SET @avg_age = (SELECT AVG(age) FROM RETAIL_SALES WHERE age IS NOT NULL);
UPDATE RETAIL_SALES SET age = @avg_age WHERE age IS NULL;
```

#### **Check Unique Customers and Categories**
```sql
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM RETAIL_SALES;
SELECT DISTINCT category FROM RETAIL_SALES;
```

---

### **3. Sales Analysis & Business Insights**

#### **1. Total Sales by Category**
```sql
SELECT category, SUM(total_sale) AS total_revenue
FROM RETAIL_SALES
GROUP BY category
ORDER BY total_revenue DESC;
```

#### **2. Total Transactions by Gender**
```sql
SELECT gender, COUNT(*) AS total_transactions
FROM RETAIL_SALES
GROUP BY gender;
```

#### **3. Monthly Sales Trend**
```sql
SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month, SUM(total_sale) AS monthly_sales
FROM RETAIL_SALES
GROUP BY month
ORDER BY month;
```

#### **4. Top 5 Best-Selling Categories**
```sql
SELECT category, COUNT(*) AS sales_count
FROM RETAIL_SALES
GROUP BY category
ORDER BY sales_count DESC
LIMIT 5;
```

#### **5. Customer Purchase Behavior (Avg Spending per Customer)**
```sql
SELECT customer_id, AVG(total_sale) AS avg_spending
FROM RETAIL_SALES
GROUP BY customer_id
ORDER BY avg_spending DESC;
```

#### **6. Identify High-Value Transactions (Above $1000)**
```sql
SELECT * FROM RETAIL_SALES
WHERE total_sale > 1000;
```

#### **7. Best-Selling Month Each Year**
```sql
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
```

#### **8. Top 5 Customers Based on Sales**
```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM RETAIL_SALES
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

#### **9. Customer Count Per Category**
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM RETAIL_SALES
GROUP BY category;
```

#### **10. Sales by Shift (Morning, Afternoon, Evening)**
```sql
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
```

---

## **Findings & Insights**

- **Customer Demographics**: Sales are distributed across different age groups and categories.
- **High-Value Transactions**: Some sales exceed $1000, indicating premium purchases.
- **Sales Trends**: Certain months and time shifts (morning/evening) show peak sales.
- **Top Customers**: Identifying top buyers helps in targeted marketing.

---

## **How to Use This Project**

1. **Clone the Repository**: If this is on GitHub, clone or download the SQL file.
2. **Set Up the Database**: Run the database setup and table creation queries.
3. **Import Data**: Load your retail sales dataset into the `RETAIL_SALES` table.
4. **Run Queries**: Use the provided SQL queries to analyze sales performance.

---

## **Author & Portfolio**

This project is part of my portfolio to demonstrate SQL proficiency for data analysis roles. If you have questions or feedback, feel free to connect with me!

### 📌 Stay Connected:
- **LinkedIn**: [www.linkedin.com/in/joshua-n-a28005216](#)
- **GitHub**: [https://github.com/AlmigthyPushCode](#)
- **Email**: [joshuajos999@gmail.com](#)

🚀 **Thank you for exploring my SQL project!** 🚀
