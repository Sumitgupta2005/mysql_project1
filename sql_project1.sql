create database sql_project_p2;
use sql_project_p2;
drop table if exists reatil_sales;
create table retail_sales
(
	transactions_id int primary key,
    sales_date date,
    sales_time time,
    customer_id int,
    gender varchar(15),
    age int,
    category varchar(15),
    quantity int,
    price_per_unit float,
    cogs float,
    total_sales float
);
select * from retail_sales;
USE sql_project_p2;

SELECT *
FROM retail_sales;

select count(*) from retail_sales;

-- extracting null data rows
select * from retail_sales
where transactions_id is null
	or
    sales_date is null
	or
    sales_time is null
	or
    customer_id is null
	or
    gender is null
	or
    age is null
	or
    category is null
	or
    quantity is null
	or
    price_per_unit is null
	or
    cogs is null
	or
    total_sales is null;
    
-- if found any null records we will delete that rows

delete from retail_sales
where transactions_id is null
	or
    sales_date is null
	or
    sales_time is null
	or
    customer_id is null
	or
    gender is null
	or
    age is null
	or
    category is null
	or
    quantity is null
	or
    price_per_unit is null
	or
    cogs is null
	or
    total_sales is null;
    
-- data exploration
    
-- how many sales we have
select count(*) from retail_sales;

-- how many unique customer we have
select count(distinct customer_id) from retail_sales;

-- how many unique category we have
select distinct category from retail_sales;

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales where sales_date = "2022-11-05";

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
and date_format(sales_date, '%Y-%m') = '2022-11'
  AND quantity >= 4;

-- Write a SQL query to calculate the total sales (total_sale) for each category.:
select category, sum(total_sales)
from retail_sales
group by category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select avg(age) from retail_sales where category = "Beauty";

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * from retail_sales where total_sales > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT
    category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT
    YEAR(sales_date) AS year,
    MONTH(sales_date) AS month,
    MONTHNAME(sales_date) AS month_name,
    ROUND(AVG(total_sales), 2) AS average_sales
FROM retail_sales
WHERE sales_date IS NOT NULL
GROUP BY
    YEAR(sales_date),
    MONTH(sales_date),
    MONTHNAME(sales_date)
ORDER BY
    year,
    month;

-- **Write a SQL query to find the top 5 customers based on the highest total sales **:
select * from retail_sales;
select customer_id, sum(total_sales) as total_purchase from retail_sales group by 1 order by 2 desc limit 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.:
select count(distinct customer_id), category from retail_sales group by category;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
select 
	case 
		when hour(sales_time) < 12 then 'Morning'
		when hour(sales_time) between 12 and 16 then 'Afternoon'
		else 'Evening'
	end as shift,
count(transactions_id) as no_of_orders
from retail_sales
group by shift;

















