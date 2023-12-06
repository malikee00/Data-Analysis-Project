-- ------------------ KPI -------------------
-- 1. Total revenue: 
select 
	sum(total_price) as Total_Revenue
from pizza_sales;

-- 2. Average Order Value
select 
	(sum(total_price) / count(distinct order_id)) as Avg_order_value
from pizza_sales;

-- 3. Total pizza sold
select sum(quantity) as Total_pizza_sold 
from pizza_sales;

-- 4. Total orders
select count(distinct order_id) as Total_orders
from pizza_sales; 

-- 5. Average pizza order
select cast(cast(sum(quantity) as decimal(10, 2)) /
cast(count(distinct order_id) as decimal(10, 2)) as decimal (10, 2)) as Avg_Pizzas_per_order
from pizza_sales;

-- ------------------ Hourly trend for pizzas sold -------------------
SELECT EXTRACT(HOUR FROM order_time) AS order_hours, 
       SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY EXTRACT(HOUR FROM order_time);

-- ------------------ Weekly trends for orders -------------------
SELECT 
    WEEK(STR_TO_DATE(order_date, '%d-%m-%Y'), 3) AS WeekNumber,
    YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')) AS Year,
    COUNT(DISTINCT order_id) AS Total_orders
FROM 
    pizza_sales
GROUP BY 
    WeekNumber,
    Year
ORDER BY 
    Year, WeekNumber;
    
-- ------------------ % of sales pizza category -------------------
select pizza_category,
	cast(sum(total_price) as decimal (10, 2)) as total_revenue,
	cast(sum(total_price) * 100 / (select sum(total_price) from pizza_sales) as decimal (10, 2)) as pct
from pizza_sales
group by pizza_category;

-- ------------------ % of sales by pizza size -------------------
select pizza_size,
	cast(sum(total_price) as decimal (10, 2)) as total_revenue,
	cast(sum(total_price) * 100 / (select sum(total_price) from pizza_sales) as decimal (10, 2)) as pct
from pizza_sales
group by pizza_size
order by pizza_size;

-- ------------------ Total pizzas sold by Pizza Category -------------------
SELECT 
    pizza_category, 
    SUM(quantity) as Total_Quantity_Sold
FROM 
    pizza_sales
GROUP BY 
    pizza_category
ORDER BY 
    Total_Quantity_Sold DESC;

-- ------------------ Top 5 Pizza by Revenue -------------------
select 
	pizza_name,
    sum(total_price) as Total_revenue
from pizza_sales
group by pizza_name
order by Total_revenue desc
limit 5;

-- ------------------ Bottom 5 Pizza by Revenue -------------------
select 
	pizza_name,
    sum(total_price) as Total_revenue
from pizza_sales
group by pizza_name
order by Total_revenue asc
limit 5;

-- ------------------ Top 5 Pizza by Quantity -------------------
select 
	pizza_name,
    sum(quantity) as Total_pizza_sold
from pizza_sales
group by pizza_name
order by Total_pizza_sold desc
limit 5;

-- ------------------ Bottom 5 Pizza by Quantity -------------------
select 
	pizza_name,
    sum(quantity) as Total_pizza_sold
from pizza_sales
group by pizza_name
order by Total_pizza_sold asc
limit 5;

-- ------------------ Top 5 Pizza by Total orders -------------------
select 
	pizza_name,
    count(distinct order_id) as Total_orders
from pizza_sales
group by pizza_name
order by Total_orders desc
limit 5;

-- ------------------ Bottom 5 Pizza by Total orders -------------------
select 
	pizza_name,
    count(distinct order_id) as Total_orders
from pizza_sales
group by pizza_name
order by Total_orders asc
limit 5;

SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
WHERE pizza_category = 'Classic' -- optional can be change
GROUP BY pizza_name
ORDER BY Total_Orders ASC
limit 5;