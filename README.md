# Retail Sales Analysis – SQL Project

**Level:** Beginner | **Database:** `p1_retail_db` | **Tool:** MySQL (MySQL Workbench)

## Project Overview

This project applies core SQL skills to a retail sales dataset. I set up a MySQL database, cleaned the data, explored it, and answered ten business questions using SQL. It is part of my journey to become a Java developer and showcases the fundamentals: DDL/DML, filtering, aggregation, grouping, CTEs, CASE statements and window functions.

## Objectives

1. Set up a retail sales database and load the sales data.
2. Clean the data by finding and removing records with null values.
3. Run exploratory data analysis (EDA) to understand the dataset.
4. Answer business questions with SQL to uncover sales patterns and customer behaviour.

## Dataset

The `retail_sales` table contains one row per transaction:

- **transactions_id** – unique transaction ID (primary key)
- **sales_date, sales_time** – when the sale happened
- **customer_id, gender, age** – customer details
- **category** – product category (e.g. Clothing, Beauty, Electronics)
- **quantity, price_per_unit** – units sold and price of each unit
- **cogs** – cost of goods sold
- **total_sales** – total sale amount

## 1. Database Setup

```sql
CREATE DATABASE p1_retail_db;
USE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sales_date      DATE,
    sales_time      TIME,
    customer_id     INT,
    gender          VARCHAR(10),
    age             INT,
    category        VARCHAR(35),
    quantity        INT,
    price_per_unit  FLOAT,
    cogs            FLOAT,
    total_sales     FLOAT
);
```

## 2. Data Exploration & Cleaning

- **Record count:** total rows in the dataset
- **Customer count:** number of unique customers
- **Category list:** all distinct product categories
- **Null check:** find rows with missing values and delete them

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

-- Check for NULLs
SELECT * FROM retail_sales
WHERE sales_date IS NULL OR sales_time IS NULL OR customer_id IS NULL
   OR gender IS NULL OR age IS NULL OR category IS NULL
   OR quantity IS NULL OR price_per_unit IS NULL
   OR cogs IS NULL OR total_sales IS NULL;

-- Remove them
DELETE FROM retail_sales
WHERE sales_date IS NULL OR sales_time IS NULL OR customer_id IS NULL
   OR gender IS NULL OR age IS NULL OR category IS NULL
   OR quantity IS NULL OR price_per_unit IS NULL
   OR cogs IS NULL OR total_sales IS NULL;
```

## 3. Data Analysis & Findings

Each question below was answered with a MySQL query.

### Q1. Retrieve all columns for sales made on 2022-11-05

```sql
SELECT *
FROM retail_sales
WHERE sales_date = '2022-11-05';
```

### Q2. Transactions in Clothing with quantity of 4 or more in November 2022

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sales_date, '%Y-%m') = '2022-11'
  AND quantity >= 4;
```

### Q3. Total sales and order count for each category

```sql
SELECT
    category,
    SUM(total_sales) AS net_sales,
    COUNT(*)         AS total_orders
FROM retail_sales
GROUP BY category;
```

### Q4. Average age of customers who bought from the Beauty category

```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

### Q5. All transactions where total_sales is greater than 1000

```sql
SELECT *
FROM retail_sales
WHERE total_sales > 1000;
```

### Q6. Number of transactions by each gender in each category

```sql
SELECT
    category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender;
```

### Q7. Average sale for each month, and the best month in each year

```sql
-- Average sale for each month
SELECT
    YEAR(sales_date)       AS year,
    MONTH(sales_date)      AS month,
    MONTHNAME(sales_date)  AS month_name,
    ROUND(AVG(total_sales), 2) AS average_sales
FROM retail_sales
WHERE sales_date IS NOT NULL
GROUP BY YEAR(sales_date), MONTH(sales_date), MONTHNAME(sales_date)
ORDER BY year, month;

-- Best month in each year (requires MySQL 8.0+)
SELECT year, month, month_name, average_sales
FROM (
    SELECT
        YEAR(sales_date)      AS year,
        MONTH(sales_date)     AS month,
        MONTHNAME(sales_date) AS month_name,
        ROUND(AVG(total_sales), 2) AS average_sales,
        RANK() OVER (
            PARTITION BY YEAR(sales_date)
            ORDER BY AVG(total_sales) DESC
        ) AS sale_rank
    FROM retail_sales
    GROUP BY YEAR(sales_date), MONTH(sales_date), MONTHNAME(sales_date)
) AS t
WHERE sale_rank = 1;
```

### Q8. Top 5 customers by total sales

```sql
SELECT
    customer_id,
    SUM(total_sales) AS total_purchase
FROM retail_sales
GROUP BY customer_id
ORDER BY total_purchase DESC
LIMIT 5;
```

### Q9. Unique customers per category

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

### Q10. Orders per shift (Morning < 12, Afternoon 12–17, Evening > 17)

```sql
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN HOUR(sales_time) < 12 THEN 'Morning'
            WHEN HOUR(sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

## Key Insights

- **Customer demographics:** customers who bought from the Beauty category are 40.41 years old on average.
- **Top customers:** customer 3 spent the most (38,440), followed by customer 1 (30,750), customer 5 (30,405), customer 2 (25,295) and customer 4 (23,580).
- **Shifts:** most orders were placed in the evening shift.

## Conclusion

This project covered the full beginner analyst workflow: database setup, cleaning, EDA and business-driven analysis. The results show how SQL can reveal sales patterns, customer behaviour and product performance to support better business decisions.

## How to Use

1. **Clone the repository:** `git clone https://github.com/Sumitgupta2005/mysql_project1.git`
2. **Set up the database:** run the table creation script in MySQL Workbench and load the sales data.
3. **Run the queries:** execute the analysis queries one by one to reproduce the results.
4. **Explore:** modify the queries to answer your own questions.

## Author

**Sumit Gupta**

Learning MySQL to become a Java developer. This project is part of my portfolio and shows the SQL skills I have built so far. Feedback and suggestions are welcome!

- **LinkedIn:** [linkedin.com/in/sumit-gupta005](https://www.linkedin.com/in/sumit-gupta005)
- **GitHub:** [github.com/Sumitgupta2005](https://github.com/Sumitgupta2005)
- **Reddit:** [u/sumiitCodes](https://www.reddit.com/user/sumiitCodes/)
- **Email:** [sumit.gupta260373@gmail.com](mailto:sumit.gupta260373@gmail.com)

*Acknowledgement: project guided by the Zero Analyst SQL playlist on YouTube.*
