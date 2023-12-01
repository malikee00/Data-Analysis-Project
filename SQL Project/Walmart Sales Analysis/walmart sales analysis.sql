select * from saleswalmart_analysis.sales;

-------------------- FEATURE ENGINEERING --------------------
---- TIME OF DAY ---- 	 	

SELECT
	time,
    (case
		when `time`	between "00:00:00" and "12:00:00" then "Morning"
        when `time`	between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end) as time_of_date
FROM saleswalmart_analysis.sales;

alter table sales
drop column time_of_date;

alter table sales add column time_of_day varchar(20);
update sales
set time_of_day = (
	case
		when `time`	between "00:00:00" and "12:00:00" then "Morning"
        when `time`	between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end
);


---- DAY NAME ---- 

select
	date,
    dayname(date) as day_name
from saleswalmart_analysis.sales;

alter table sales add column day_name varchar(10);
update sales
set day_name = dayname(date);

---- MONTH NAME ---- 

select
	date,
    monthname(date) as month_name
from saleswalmart_analysis.sales;

alter table sales add column month_name varchar(10);
update sales
set month_name = monthname(date);


-------------------- EXPLORATORY DATA ANALYS (EDA) --------------------
---------------------- GENERIC QUESTION -----------------------
# 1. How many unique cities does the data have?
select 
	distinct city
from saleswalmart_analysis.sales;

# 2. In which city is each branch?
select 
	distinct city,
    branch
from saleswalmart_analysis.sales;


---------------------- PRODUCT -----------------------
# 1. How many unique product lines does the data have? 3
select
	count(distinct product_line)
from saleswalmart_analysis.sales;

# 2. What is the most selling product line? Electronic Accesories
select
	product_line,
    sum(quantity) as total_quantity
from saleswalmart_analysis.sales
group by product_line
order by total_quantity desc;

# 3. What is the most common payment method?
select 
	payment,
    count(payment) as total_payment
from saleswalmart_analysis.sales
group by payment
order by total_payment desc;

# 4. What is the total revenue by month?
select
	month_name as month,
    sum(total) as total_revenue
from saleswalmart_analysis.sales
group by month_name
order by total_revenue desc;

# 5. What month had the largest COGS? January
select
	month_name as month,
    sum(cogs) as cogs
from saleswalmart_analysis.sales
group by month_name
order by cogs desc;

# 6. What product line had the largest revenue? food and beverages
select
	product_line,
    sum(total) as total_revenue
from saleswalmart_analysis.sales
group by product_line
order by total_revenue desc;

# 7. What is the city with the largest revenue? Naypyitaw
select
	branch,
	city,
    sum(total) as total_revenue
from saleswalmart_analysis.sales
group by city, branch
order by total_revenue desc;

# 8. What product line had the largest VAT?
select
	product_line, 
    avg(tax_pct) as avg_tax
from saleswalmart_analysis.sales
group by product_line
order by avg_tax desc;

# 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select
	product_line,
    avg(quantity) as average_total
from saleswalmart_analysis.sales
group by product_line
order by average_total desc;

select
	avg(quantity) as avg_qty
from saleswalmart_analysis.sales;

select
	product_line,
    case
		when avg(quantity) > 6 then "Good"
        else "Bad"
	end as remark
from saleswalmart_analysis.sales
group by product_line;

# 10. Which branch sold more products than average product sold?
select 
	branch, 
    sum(quantity) as qty
from saleswalmart_analysis.sales
group by branch
having sum(quantity) > (select avg(quantity) from saleswalmart_analysis.sales);

# 11. What is the most common product line by gender?
select
	gender,
    product_line,
    count(gender) as total_cnt
from saleswalmart_analysis.sales
group by gender, product_line
order by total_cnt desc;

# 12. What is the average rating of each product line?
select
	product_line,
	round(avg(rating), 2) as avg_rating
from saleswalmart_analysis.sales
group by product_line
order by avg_rating desc;

---------------------- SALES -----------------------
# 1. Number of sales made in each time of the day per weekday
select 
	day_name,
    time_of_day,
    count(*) as total_sales
from saleswalmart_analysis.sales
where day_name in ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')
group by day_name, time_of_day
order by total_sales desc;

# 2. Which of the customer types brings the most revenue?
SELECT
	customer_type,
    sum(total) as total_revenue
FROM saleswalmart_analysis.sales
group by customer_type
order by total_revenue;

# 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
	city,
	round(avg(tax_pct), 2) as avg_tax_pct
from saleswalmart_analysis.sales
group by city
order by avg_tax_pct desc;

# 4. Which customer type pays the most in VAT?
SELECT
	customer_type,
    round(avg(tax_pct),2) as total_tax
FROM saleswalmart_analysis.sales
group by customer_type
order by total_tax;

---------------------- CUSTOMER -----------------------
# 1. How many unique customer types does the data have?
select
	distinct customer_type
from saleswalmart_analysis.sales;

# 2. How many unique payment methods does the data have?
select
	distinct payment
from saleswalmart_analysis.sales;

# 3. What is the most common customer type?
select 
	customer_type,
    count(*) as count
from saleswalmart_analysis.sales
group by customer_type
order by count desc;

# 4. Which customer type buys the most?
select
	customer_type,
    count(*)
from saleswalmart_analysis.sales
group by customer_type;

# 5. What is the gender of most of the customers?
select 
	gender,
    count(*) as count
from saleswalmart_analysis.sales
group by gender
order by count desc;

# 6. What is the gender distribution per branch?
select 
	branch,
	gender,
    count(*) as gender_cnt
from saleswalmart_analysis.sales
where branch in ('A', 'B', 'C')
group by branch, gender
order by gender_cnt desc;

# 7. Which time of the day do customers give most ratings?
select 
	time_of_day,
    round(avg(rating),2) as avg_rating
from saleswalmart_analysis.sales
group by time_of_day
order by avg_rating desc;

# 8. Which time of the day do customers give most ratings per branch?
select 
	branch,
	time_of_day,
    round(avg(rating),2) as avg_rating
from saleswalmart_analysis.sales
where branch in ('A', 'B', 'C')
group by branch, time_of_day
order by avg_rating desc;

# 9. Which day of the week has the best avg ratings?
SELECT
	day_name,
    round( avg(rating), 2) as avg_rating
FROM saleswalmart_analysis.sales
group by day_name
order by avg_rating desc;

# 10. Which day of the week has the best average ratings per branch?
select 
	day_name,
	branch,
    round(avg(rating),2) as avg_rating
from saleswalmart_analysis.sales
where branch in ('A', 'B', 'C')
group by branch, day_name
order by avg_rating desc;




