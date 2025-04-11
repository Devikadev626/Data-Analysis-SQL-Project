CREATE DATABASE SWIGGY;
USE SWIGGY;

SELECT * FROM items;
SELECT * FROM orders;

--------------------Item-Level Analysis-----------------------

--1.•	Find the number of unique food items offered.

select count(distinct name) As Unique_food_items from items;

--2•	Analyze veg vs non-veg item distribution.
select is_veg,count(name) as items from items
group by is_veg;

--3.	Items where is_veg = 2 (possibly invalid data)
select * from items
where is_veg =2;

--4.	Items containing the word "Chicken"
select * from items
where name like '%chicken%';

--5.	Items containing the word "Paratha"
select * from items
where name like '%Paratha%';

--6.	Average number of items per order
select count(name) /count(distinct order_id) as avg_item_PerOrder from items;

--7.	Top ordered items
select top 5 name,count(*)  as count from items
group by name
order by count(*) desc;

---------------Order-Level Analysis---------------
--8.	Distinct rain modes

select distinct rain_mode from orders;

---9.	Number of unique restaurants
select count (distinct(restaurant_name)) as Restaurant_count from orders;

--10	Order count per restaurant
select restaurant_name, count(order_id) as Order_count from orders
group by restaurant_name
order by count(*) desc;

--11.	Monthly order trend (by count)


SELECT 
    FORMAT(order_time, 'yyyy-MM') AS OrderMonth,
    COUNT(DISTINCT order_id) AS TotalOrders
FROM 
    orders
GROUP BY 
    FORMAT(order_time, 'yyyy-MM')
ORDER BY 
    TotalOrders DESC;

--12.	Latest order date
select order_time from orders
order by order_time desc;

SELECT max(order_time) FROM orders;

--13.	Monthly revenue trend
SELECT 
    FORMAT(order_time, 'yyyy-MM') AS OrderMonth,
    sum(order_total) as totalrevenue
FROM 
    orders
GROUP BY 
    FORMAT(order_time, 'yyyy-MM')
ORDER BY 
    totalrevenue DESC;

--14.	Average order value (AOV)
	select sum(order_total) /count(distinct order_id) as aov from orders;

--15.	Year-wise revenue trend
SELECT 
    FORMAT(order_time, 'yyyy') AS OrderMonth,
    sum(order_total) as totalrevenue
FROM 
    orders
GROUP BY 
    FORMAT(order_time, 'yyyy')
ORDER BY 
    totalrevenue DESC;

--16.	Yearly revenue with previous year comparison
WITH YearlyRevenue AS (
    SELECT 
        FORMAT(order_time, 'yyyy') AS OrderYear,
        SUM(order_total) AS TotalRevenue
    FROM 
        orders
    GROUP BY 
        FORMAT(order_time, 'yyyy')
),
RevenueWithComparison AS (
    SELECT 
        yr.OrderYear,
        yr.TotalRevenue,
        LAG(yr.TotalRevenue) OVER (ORDER BY yr.OrderYear) AS PreviousYearRevenue,
        yr.TotalRevenue - LAG(yr.TotalRevenue) OVER (ORDER BY yr.OrderYear) AS RevenueChange
    FROM 
        YearlyRevenue yr
)
SELECT * 
FROM RevenueWithComparison
ORDER BY OrderYear;

--17.	Year-wise revenue ranking
WITH YearlyRevenue AS (
    SELECT 
        FORMAT(order_time, 'yyyy') AS OrderYear,
        SUM(order_total) AS TotalRevenue
    FROM 
        orders
    GROUP BY 
        FORMAT(order_time, 'yyyy')
)
SELECT 
    OrderYear,
    TotalRevenue,
    RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenueRank
FROM 
    YearlyRevenue
ORDER BY 
    RevenueRank;

--18.Top Revenue-Generating Restaurants
	SELECT 
    restaurant_name,
    SUM(order_total) AS TotalRevenue,
    RANK() OVER (ORDER BY SUM(order_total) DESC) AS RevenueRank
FROM 
    orders
GROUP BY 
    restaurant_name
ORDER BY 
    TotalRevenue DESC;

---------Joins and Item Pair Analysis------------

--19.	Join items with order details
SELECT a.name,a.is_veg,b.restaurant_name,b.order_id,b.order_time from 
items a join orders b
on a.order_id =b.order_id;

--20.	Get item pairings in the same order (excluding same names)
select
	a.order_id,
	a.name as name1,
	b.name as name2,
	concat(a.name, '-',b.name) as pair
from
	items a 
join items b
	on a.order_id =b.order_id
where a.name != b.name
and a.name<b.name;



select * from items
select * from orders;