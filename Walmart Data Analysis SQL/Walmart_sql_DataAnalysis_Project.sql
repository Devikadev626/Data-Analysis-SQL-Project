create Database walmart;

USE walmart;

select * from Sales_table

-------Feature Engineering-------
1. Time_of_day

SELECT time,
	(case
		WHEN time between '00:00:00' and '12:00:00' then 'Morning'
		WHEN time between '12:01:00' and '16:00:00' then 'Afternoon'
		Else 'Evening'
	end) as time_of_day
	from Sales_table 

Alter table sales_table 
add  time_of_day varchar(20);

update sales_table
set time_of_day =(
	case
		WHEN time between '00:00:00' and '12:00:00' then 'Morning'
		WHEN time between '12:01:00' and '16:00:00' then 'Afternoon'
		Else 'Evening'
	end);

2.Day_name

select date,datename(weekday,date) as day_name
from sales_table;

alter table sales_table
add day_name varchar(10);

update sales_table
set day_name =datename(weekday,date);

3.Month_name

select date,datename(month,date) as month_name
from sales_table;

alter table sales_table
add month_name varchar(10);

update sales_table
set month_name =datename(month,date) ;


----------EXPLORATORY DATA ANALYSIS (EDA)----------
--Generic Questions------

---1. How many distinct cities are present in dataset
select distinct(City) from sales_table;

---2. In which city is each brach situated.

select distinct branch,City from sales_table;

--Product Analysis--------

---1. How many distinct product lines are there in the dataset?
select count(distinct Product_line) As distinct_product_line_count from sales_table;

---2. What is most common payment?

select top 1 Payment,count(Payment) as common_payment_method from sales_table
group by Payment
order by common_payment_method desc;

---3. What is the most selling product line?
select top 1 Product_line, count(Product_line) as top_product_line from sales_table
group by Product_line 
order by  top_product_line;

---4. What is total revenue by month?


select  month_name, sum(total) as total_revenue from sales_table
group by month_name
order by total_revenue desc;

---5.Which month recorded the highest Cost of Goods Sold (COGS)?
select top 1 month_name ,sum(cogs) as total_cogs from sales_table
group by month_name
order by total_cogs desc;

---6. Which Product line generated the highest revenue?

select top 1 Product_line,  sum(total) as total_revenue from sales_table
group by Product_line
order by total_revenue desc;

---7. Which City has the highest revenue?
select top 1 City, sum(total) as total_revenue from sales_table
group by city
order by total_revenue desc;


-- 8.Which product line incurred the highest VAT?

select top 1 Product_line, sum(Tax_5) as TAX from sales_table
group by Product_line
order by TAX desc;

-- 9.Retrieve each product line and add a column product_category, indicating 'Good' or 'Bad,'based on whether its sales are above the average.

alter table sales_table
add Product_category varchar(20);


update sales_table
set Product_category=
(case 
	when total>= (select avg(total) from Sales_table) then 'Good'
	else 'Bad'
	end) from sales_table;

---which branch sold more products than average product sold?
select top 1 branch , sum(quantity) as quantity from sales_table
group by branch 
having sum(quantity)> avg(quantity)
order by quantity;


-- 11.What is the most common product line by gender?

select gender,Product_line,count(gender) as total_count from Sales_table
group by gender,Product_line 
order by  count(gender) desc;

----- 12.What is the average rating of each product line?
select Product_line, round(avg(Rating),2) as Avg_rating from Sales_table
group by Product_line
order by Avg_rating desc;

---Sales Analysis---

---1. Number of sales made in each time of day per weekday

select day_name,time_of_day,count(Invoice_ID) as sales from Sales_table
group by day_name,time_of_day
having day_name not in('Sunday','Saturday');

SELECT day_name, time_of_day, COUNT(*) AS total_sales
FROM Sales_table WHERE day_name NOT IN ('Saturday','Sunday') GROUP BY day_name, time_of_day;


--- 2.Identify the customer type that generates the highest revenue.

select top 1 Customer_type,sum(total) As revenue from Sales_table
group by Customer_type
order by revenue desc;

----- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?
select top 1 City,sum(Tax_5) as total_tax from Sales_table
group by City
order by total_tax desc;

----- 4.Which customer type pays the most in VAT?

select top 1 Customer_type,sum(Tax_5) as Tax from Sales_table
group by Customer_type
order by Tax desc;

--Customer Analysis------

-- 1.How many unique customer types does the data have?
select count(distinct(Customer_type)) from Sales_table

-- 2.How many unique payment methods does the data have?
select count(distinct Payment)  from Sales_table;

---- 3.Which is the most common customer type?
select top 1 Customer_type, count(Customer_type) as common_customer from Sales_table
group by Customer_type
order by count(Customer_type) desc;

-- 4.Which customer type buys the most?
select top 1 Customer_type, sum(total) as total_sales from Sales_table
group by Customer_type 
order by total_sales;

select top 1 Customer_type ,count(*) as most_buyer
from Sales_table
group by Customer_type
order by most_buyer desc;

-- 5.What is the gender of most of the customers?
select top 1 Gender,count(*) as all_genders from Sales_table
group by Gender
order by all_genders desc;

-- 6.What is the gender distribution per branch?
select Branch,Gender,count(Gender) as gender_distribution from Sales_table
group by Branch,Gender
order by Branch;


-- 7.Which time of the day do customers give most ratings?
select top 1 time_of_day, avg(Rating) as Average_rating  from Sales_table
group by time_of_day
order by average_rating desc;


-- 8.Which time of the day do customers give most ratings per branch?

select Branch,time_of_day,avg(rating) as average_rating from Sales_table
group by time_of_day,Branch
order by average_rating desc;

-- 9.Which day of the week has the best avg ratings?

select top 1 day_name, avg(Rating) as Average_rating from Sales_table
group by day_name
order by Average_rating desc;

---- 10.Which day of the week has the best average ratings per branch?
select Branch,day_name, avg(Rating) as Average_rating from Sales_table
group by day_name,Branch
order by Average_rating desc;

