use study;
select * from ecom_sales;
Describe ecom_sales;
-- or 
SHOW columns from ecom_sales;

/*update ecom_sales
SET Order_Date = STR_TO_DATE(Order_date,"%d-%m-%Y");
*/
UPDATE ecom_sales
SET Order_Date = NULL
WHERE STR_TO_DATE(Order_Date, '%d-%m-%Y') IS NULL;

Describe ecom_sales;
ALTER table ecom_sales
modify Order_Date date;
Describe ecom_sales;
-- Total Sales & Profit
select sum(Sales) as total_sales,
sum(Profit) as total_Profit
from ecom_sales;
-- Top 10 Customers
select customer_name,sum("Sales") as revenue
from ecom_Sales
group by customer_name
order by revenue Desc
limit 5;
-- loss making products
select product_name,sum("Profit") as total_profit
from ecom_sales
group by product_name
having total_profit<0;
-- total orders
select count(*) as total_orders from ecom_sales;
-- check null values
SELECT 
    COUNT(*) - COUNT(Order_ID) AS order_id_nulls,
    COUNT(*) - COUNT(Customer_ID) AS customer_id_nulls,
    COUNT(*) - COUNT(Sales) AS sales_nulls,
    COUNT(*) - COUNT(Profit) AS profit_nulls
FROM ecom_sales;
-- Sales and profit by category

select * from ecom_sales;
select Category,sum(Sales) as total_sales ,sum(Profit) as total_profit
from ecom_sales
group by Category
order by total_sales desc;
select round(sum(sales)/sum(profit)*100,2) as profit_margin
from ecom_sales;
-- TIME BASED ANALYSIS
-- best sale month
select month(Order_date) AS MONTH,
SUM(SALES) AS TOTAL_SALES
FROM ecom_sales
group by month
order by total_sales  desc
limit 1;
-- best sales year
Select year(Order_Date) as year,
month(order_date) as month
from ecom_sales
group by year,month
order by year,month;
-- Customer Analysis
-- top 5 customer by sales
select customer_name,
sum(sales) as total_sales
from ecom_sales
group by customer_name
order by total_sales Desc
limit 5;
select customer_id,
count(order_id) as order_count
from ecom_sales
group by Customer_id
Having order_count >1;
-- product analysis
-- top selling product by quantity
select product_name,sum(quantity) as total_quantity
from ecom_sales
group by product_name
order by total_quantity Desc;
-- loss making company
select product_name,
sum(profit) as total_profit
from ecom_sales
group by product_name
having total_profit < 0;
-- Discount impact analysis
-- AVG DISCOUNT BY CATEGORY
select category,
round(avg(Discount)*100,2) as avg_discount
from ecom_sales
group by category;
--  Discount VS Profit
select discount,sum(profit) as total_profit
from ecom_sales
group by Discount	
order by Discount;
-- Location Analysis
-- Sales by States
select state, sum(sales) as total_sales
from ecom_sales
group by state
order by total_sales desc;
-- Top 3 Cities by Revenue
select City,
sum(sales) as total_sales
from ecom_sales
group by City
order by total_sales Desc
LIMIT 3;
select* from ecom_sales;
-- Payment mode analysis
select payment_mode,
count(order_id) as total_count,
sum(sales) as total_sales
from ecom_sales
group by payment_mode
order by total_sales desc;
WITH product_sales AS (
    SELECT 
        Product_Name,
        SUM(Sales) AS total_sales
    FROM ecom_sales
    GROUP BY Product_Name
),
running_sales AS (
    SELECT 
        Product_Name,
        total_sales,
        SUM(total_sales) OVER (ORDER BY total_sales DESC) AS cumulative_sales,
        SUM(total_sales) OVER () AS overall_sales
    FROM product_sales
)
SELECT *
FROM running_sales
WHERE cumulative_sales <= 0.8 * overall_sales;
-- Data QUALITY checks
SELECT * FROM ecom_sales
WHERE PROFIT < 0;
-- Outliers in sales
	select * from ecom_sales
    where sales >(select avg(sales)+3*stddev(sales)
    from ecom_sales);
