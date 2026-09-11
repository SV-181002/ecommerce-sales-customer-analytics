CREATE DATABASE ecommerce_analysis;
USE ecommerce_analysis;
-- CREAT A TABLE
CREATE TABLE sales (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10,2),
    CustomerID VARCHAR(20),
    Country VARCHAR(100),
    Revenue DECIMAL(12,2)
);
SHOW TABLES;
DESC sales;

-- =========================================
-- PART 1: BASIC DATA EXPLORATION
-- =========================================

SELECT COUNT(*) FROM sales;
SELECT * FROM sales LIMIT 10; -- Tis shows me only the first 10 records

-- Count total records
select count(*) as total_records from sales;

-- count unique orders
select count(distinct InvoiceNo) as total_orders from sales; -- distinct means give unique values only

-- count unique products
SELECT COUNT(DISTINCT StockCode) AS total_products
FROM ecommerce_analysis.sales;

-- count unique customers
select count(distinct CustomerID) as total_customers from sales;

-- Lets combien our KPIs
select
count(*) as total_records,
count(distinct InvoiceNo) as total_orders,
count(Distinct StockCode) as toatal_products,
count(distinct CustomerID) as total_customers,
count(distinct Country) as total_countries
from sales;

-- =========================================
-- PART 2: AGGREGATE FUNCTIONS
-- =========================================

-- sum()
select sum(Revenue) as total_revenue from sales;
-- the above query tells (add all the revenue values from the sales table and call the result as total_revenue)

-- avg()
select avg(UnitPrice) as average_unit_price from sales;
-- the above query says "Calculate the average of the UnitPrice column from the sales table."

-- max()
select max(UnitPrice) as maximum_unit_price from sales;

-- min
select min(UnitPrice) as miniimum_unit_price from sales;

-- combine all the 
select
count(*) as total_records,
sum(Revenue)as total_revenue,
avg(UnitPrice) as average_unit_price,
min(UnitPrice) as minimum_unitprice,
max(UnitPrice) as maximum_unit_price
from sales;

-- =========================================
-- PART 3: GROUP BY
-- =========================================
-- GROUP BY is used to group rows that have the same value and then perform calculations on each group.
-- Total revenue by country
select country,               -- select country
sum(Revenue) as total_revenue -- add all reveneue belong to country.
from sales                    -- take data from sales table
group by Country;             -- create one group foer each country

-- Total quantity by country 
select Country,
sum(Quantity) as total_quantity
from sales
group by Country;

-- number of orders by country
select Country,
count(distinct InvoiceNo) as total_orders -- one invoice can contain multiple products/rows. so count(distinct InvoiceNo) helps to count the actual unique orders
from sales
group by Country;

-- ORDER BY
-- Sort the result from the SQL query
-- sort country Alphabetically
select Country,
sum(Revenue) as total_revenue
from sales
group by country        -- creat one group for each country
order by country asc;   -- "ASC" low to high / a-z

-- Higest revenue by country ***
select country,
sum(Revenue) as total_revenue
from sales
group by Country
order by total_revenue desc;  -- "DESC" high to low / z-a
-- similarlry for lowest revenue countries we need to replace (desc --> asc)
select country,
sum(Revenue) as total_revenue
from sales
group by Country
order by total_revenue asc; -- "ASC" low to high

-- Order + limit
-- by using limit we can dispalu how much data we want 
-- Top 10 Countries by Revenue  ***
select country,
sum(Revenue) as total_revenue
from sales
group by Country
order by total_revenue desc
limit 10;

-- Top 10 products by revenue
select StockCode,
sum(Revenue) as total_revenue
from sales
group by StockCode
order by total_revenue desc
limit 10;

-- Top 10 customers by revenue
select CustomerID,
sum(Revenue) as total_revenue
from sales
group by CustomerID
order by total_revenue desc
limit 10;

-- =========================================
-- PART 4: WHERE
-- =========================================
-- Filter rows based on "condition"
-- where with text
-- Transactions of UK
select * from sales
where country = 'United Kingdom'; -- this query gives all transactions that belong to the UK

-- where with numbers
-- Transactions where quantity is greater than 100
select * from sales
where Quantity > 100;  -- means show rows where Quantity is more than 100

-- High-vlaue transactions
select
InvoiceNo,
StockCode,
Quantity,
Revenue
from sales
where Revenue > 100;

-- Large Quantity transactions
-- Show transaction where more than 100 items were purchase
select
InvoiceNo, StockCode, Quantity from sales
where Quantity > 100;

-- Expencive products
-- Show product with the unit price 10
select StockCode, Description, UnitPrice
from sales where UnitPrice > 10;

-- Show UK transactions with revenue greater than 100
select InvoiceNo, Country, Revenue
from sales where Revenue > 100;

-- Show transactions from UK or France
select InvoiceNo, Country, Revenue
from sales where Country in ('United Kingdom', 'France');

 -- Quantity range: show transactions where quantity is between 10 and 50
 select InvoiceNo, StockCode, Quantity
 from sales where Quantity between 10 and 50;
 
 -- Find products whose description containing word BAG
 Select StockCode, description
 from sales where Description like '%BAG%';
 
 -- How many transactions don't have a customer ID?
 select count(*) as missing_customer_records
 from sales where CustomerID is null;
 
 -- Show transaction wher customer id is available
 select * from sales
 where CustomerID is not null;
 
-- =========================================
-- PART 5: HAVING
-- =========================================
 -- where filter individual rows 
 -- having filters groups
 
 -- Which countries generated more than 1,000,000 in total revenue?
 select Country,
 sum(Revenue) as total_revenue
 from sales
 group by Country
 having sum(Revenue) > 1000000;
 
 -- Countries with many orders
 -- Which country have 1000+ orders?
 select Country,
 count(distinct InvoiceNo) as total_orders
 from sales
 group by Country
 having count(distinct InvoiceNo) > 1000
 order by total_orders desc;
 
 -- High-Value customers ***
 -- Which customer has spent 5000+?
 select CustomerId,
 sum(Revenue) as total_spent
 from sales
 where CustomerID is not null
 group by CustomerID
 having sum(Revenue) > 5000
 order by total_spent desc;
 
 -- High-Revenue Products ***
 -- Which product generate 10000+ revenue?
 select StockCode, Description,
 sum(Revenue) as total_revenue
 from sales
 group by StockCode, Description
 having sum(Revenue) > 10000
 order by total_revenue desc;
 
 -- Product with high sales Quantity
 -- which product sold more than 10000+ units?
 select StockCode, Description,
 sum(Quantity) as total_quantity
 from sales 
 group by StockCode, Description
 having sum(Quantity) > 10000
 order by total_quantity desc;
 
 -- Among Uk sales which product generates 10000+ revenue?
 select StockCode, Description, Country,
 sum(Revenue) as total_revenue
 from sales
 where Country = 'United Kingdom'
 group by StockCode, Description, Country
 having sum(Revenue) > 10000
 order by total_revenue desc;
 
 -- =========================================
-- PART 6: JOINS
-- =========================================
 -- join is used to combain data from two or more tables using a related column
 
 -- Create a table costumers
 create table customers as      -- create new table customers
 select distinct                -- Take unique combinations
 CustomerID, Country            -- we are taking this two columns
 from sales                     -- from sales table (we are taking the informatiom from existing sales table)
 where CustomerID is not null;  -- we are removing where customerId is missing
 
 select * from customers limit 10;
 select count(*) as total_customers from customers;
 
 -- Create table products
 create table products as
 select distinct StockCode, Description
 from sales 
 where StockCode is not null;
 
 select * from products limit 10;
 select count(*) as total_products from products;
 show tables;
 
 -- Inner join ---> combain rows from two tables when they have a matching value
-- Give only the matching data from both tables

-- Inner join with customers
select                -- tell me what columns
sales.InvoiceNo,      -- take invoiceNO from sales
sales.CustomerID,     -- take customerID from sales
customers.Country,    -- take country from customers
Sales.Revenue         -- take revenue from sales
from sales            -- we start with the sales table
inner join customers  -- connect the sales with customers
on sales.CustomerID = customers.CustomerID  -- Match the CustomerID from sales with the CustomerID from customers
limit 10;             -- show only 10 rows

-- Inner join with products
select
sales.InvoiceNo,
sales.StockCode,
products.Description,
sales.Quantity,
sales.Revenue
from sales
inner join products
on sales.StockCode = products.StockCode
limit 10;

-- Inner Join + gropu by
-- Revenue by Product
-- which products generate most revenue
select
p.StockCode, p.Description,
sum(s.Revenue) as total_revenue
from sales s
inner join products p 
on s.StockCode = p.StockCode
group by p.StockCode, p.Description
order by total_Revenue desc
limit 10;

-- Number of products by revenue
-- Which products apper in the higest number of orders
select
p.StockCode, p.Description,
count(distinct s.InvoiceNo) as total_orders
from sales s
inner join products p
on s.StockCode = p.StockCode
group by p.StockCode, p.Description
order by total_orders desc
limit 10;
-- tells which products are frequently purchased

-- Rvenue by customers
-- Which customer generate the more reveneu
select 
c.CustomerID, c.Country,
sum(s.Revenue) as total_revenue
from sales s
inner join customers c
on s.CustomerID = c.CustomerID
group by c.CustomerID, c.Country
order by total_revenue desc
limit 10;
-- This identifies our highest-value customers.

-- Left join
-- Find Sales Records With Missing Customer Information ⭐⭐⭐
select s.InvoiceNo, s.CustomerID, s.Revenue, c.Country -- iwant this 4 columns in my result
from sales s                                          -- start with sales table because sales was written first
left join customers c                                 -- Take the sales table and try to find the corresponding customer in the customers table.
on s.CustomerID = c.CustomerID                        -- This tells MySQL how to match the two tables.
where c.CustomerID is null;                           -- After doing the LEFT JOIN, show me only the rows where no customer was found.

-- Count Unmatched Customer Records ⭐⭐⭐
select 
count(*) as unmatched_customer_records
from sales s
left join customers c
on s.CustomerID = c.CustomerID
where c.CustomerID is null;
-- Instead of looking at thousands of rows, we get one KPI showing how many sales records don't have matching customer information.

-- Revenue From Customers With Matching Customer Information ⭐⭐
select c.Country,
sum(s.Revenue) as total_revenue
from sales s
left join customers c
on s.CustomerID = c.CustomerID
where c.CustomerID is not null
group by c.country
order by total_revenue;
-- Calculates revenue only for sales where customer information is available.

-- Customer Purchase Summary Including Customers With No Sales ⭐⭐⭐
select c.CustomerID, c.Country,
count(distinct s.InvoiceNo) as total_orders,
coalesce(sum(s.Revenue),0) as total_revenue
from customers c
inner join sales s
on c.CustomerID = s.CustomerID
group by c.CustomerID, c.Country
order by total_revenue desc;
-- We start with all customers and then look for their sales. If a customer has no matching sale, they still appear.

-- Find Customers With No Purchases ⭐⭐⭐
select c.CustomerID, c.Country
from customers c
inner join sales s
on c.CustomerID = s.CustomerID
where s.CustomerID is null;
-- Finds customers who exist in the customers table but have no matching sales records

-- =========================================
-- PART 7: CASE WHEN
-- =========================================
-- Transaction-useful Query
select InvoiceNo, StockCode, Revenue,
case
when Revenue < 100 then 'Low Value'
when Revenue between 100 and 500 then 'Medium Value'
when Revenue > 500 then 'High value'
else 'Unknown'
end as revenue_category
from sales;

-- Count Transactions by Revenue Category ⭐⭐⭐
select
case
when Revenue < 100 then 'Low Value'
when Revenue between 100 and 500 then 'Medium Value'
when Revenue > 500 then 'High Value'
else 'Unknown'
end as revenue_category,
count(*) as total_transactions
from sales
group by revenue_category
order by total_transactions desc;

-- Revenue by Transaction Category ⭐⭐⭐
-- How much total revenue comes from Low, Medium, and High-value transactions?
select
case
when Revenue < 100 then 'Low Value'
when Revenue between 100 and 500 then 'Medium Value'
when Revenue > 500 then 'High Value'
else 'Unknown'
end as revenue_category,
sum(Revenue) as total_revenue
from sales
group by revenue_category
order by total_revenue desc;
-- This tells us which transaction category contributes the most revenue.

-- Customer value classification
-- Which customer's are low, medium and high value customers

select
CustomerID, Country,
sum(Revenue) as total_spent,
case
when sum(Revenue) < 1000 then 'Low value Cstomer'
when sum(Revenue) between 1000 and 5000 then 'Medium Value Customer'
when sum(Revenue) > 5000 then 'High Value Customer'
else 'Unknown'
end as customer_category
from sales
where CustomerID is not null
group by CustomerID, Country
order by total_spent desc;
-- We classified customers based on their total spending ⭐⭐⭐

-- Count customers by customer category
-- How many low, medium, high value customers do we have
select
customer_category,
count(*) as total_customers
from(
select CustomerID,
case
when sum(Revenue) < 1000 then 'Low Value Customer'
when sum(Revenue) between 1000 and 5000 then 'Medium Value Customer'
when sum(Revenue) > 5000 then 'High Value Customer'
else 'Unknown'
end as customer_category
from sales
where CustomerID is not null
group by CustomerID
) as customer_segments
group by customer_category
order by total_customers desc;
-- it converts customer classification into a customer segments

-- order size classification
-- which orders are small, medium, large based on quantity
select
InvoiceNo, Description, 
sum(Quantity) as total_quantity,
case
when sum(Quantity) < 100 then 'Small orders'
when sum(Quantity) between 100 and 500 then 'Medium Orders'
when sum(Quantity) > 500 then 'large Orders'
else 'Unknown'
end as order_category
from sales
group by InvoiceNo, Description
order by total_quantity desc;
-- Insted of looking at the individual products with in an order, we classify the entair orders based on quantity

-- Count orders by size
-- how many small, medium, high orders do we have
select
order_category,
Count(*) as total_orders
from (
select InvoiceNo, 
case
when sum(Quantity) < 1000 then 'Small order'
when sum(Quantity) between 1000 and 5000 then 'Medium order'
when sum(Quantity) > 5000 then 'Large Order'
else 'unknown'
end as order_category
from sales
group by InvoiceNo
)
as order_segments
group by order_category
order by total_orders desc;
-- shows the distribution of order sizes.

-- Return / normal sale classification
select
InvoiceNo, Quantity, Revenue,
case
when InvoiceNo like 'c%' then 'Cancelled'
else 'Normal Sale'
end as transaction_status
from sales;
-- Creats a clear business-friendly status insted of making someone intepret incoicw numbers.

-- Count cancelled vs normal sale
select
case
when InvoiceNo like 'C%' then 'Cancelled'
else 'Normal Sale'
end as transaction_status,
count(*) as total_records
from sales
group by transaction_status;
-- Gives us quick comparison between normal sales vs cancelled sales

-- =========================================
-- PART 8: SUBQUERIES
-- =========================================
-- A subquery is a SQL query written inside another SQL query, simply SubQuery = Query inside a Query
-- Customer who spent mofre than the average customer
-- Which customer have spent more money than the average customer?
select CustomerID, sum(Revenue) as total_spent  -- customerID and total amount spent by customer
from sales                                      -- From sales table
where CustomerID is not Null                    -- Some rows having missing customerID's we dont want those records
group by CustomerID                             -- This put all the sales belong to the same customer togeather
having sum(Revenue) > (                         -- Show only customers whose total spending is greater than something.
-- from here innerquery/subquery starts
-- the outer part of sub query
select avg(customer_total)                      --  It calculates the average of those customer totals.       
from (                                          
select CustomerID,
sum(Revenue) as customer_total
from sales
where CustomerID is not null
group by CustomerID
) as Customer_sales
)
order by total_spent desc;

-- prodct with above average reveneue
-- which product generate more revenue than the average product
select StockCode, Description, total_revenue
from (
select p.StockCode, p.Description,
sum(Revenue) as total_revenue
from sales s
inner join products p
on s.StockCode = p.StockCode
group by p.StockCode, p.Description
) as product_sales
where total_revenue > (
select avg(total_revenue)
from ( 
select StockCode,
sum(Revenue) as total_revenue
from sales
group by StockCode
) as average_products
)
order by total_revenue desc;
-- Identify products performing better than the average product

-- Countries with above average revenue
-- which countries generate more revenue than the average country
select Country, total_revenue
from(
select Country, 
sum(Revenue) as total_revenue
from sales
group by Country
) as country_sales
where total_revenue > (
select avg(total_revenue)
from (
select Country,
sum(Revenue) as total_revenue
from sales
group by Country
) as average_countries
)
order by total_revenue desc;
-- Identify above average markets

-- orders larger than average orders
-- Which orders have a quantity greater than the average order quantity
select InvoiceNo, total_quantity
from ( select InvoiceNo,
sum(Quantity) as total_quantity
from sales
group by InvoiceNo
) as order_sales
where total_quantity > (
select avg(total_quantity)
from ( select InvoiceNo,
sum(Quantity) as total_quantity
from sales
group by InvoiceNo
) as average_orders
)
order by total_quantity desc;

-- Products with revenu above a certain benchmark
-- which product generate more than 10000 revenue?
select StockCode, Description, total_revenue
from ( select p.StockCode, p.Description,
sum(Revenue) as total_revenue
from sales s
inner join products p
on s.StockCode = p.StockCode
group by p.StockCode, p.Description
) as product_sales
where total_revenue > 10000
order by total_revenue desc;
-- Create a high-performing product list based on a business threshold

-- Customer with more than the average number of orders
-- Which customer place more orders than the average customer
select CustomerID, total_orders
from(
select CustomerID,
count(distinct InvoiceNo) as total_orders
from sales
where CustomerID is not null
group by CustomerID
) as customer_orders
where total_orders > (
select avg(total_orders)
from( select CustomerID,
Count(distinct InvoiceNo) as total_orders
from slaes
where CustomerID is not null
group by CustomerID
) as average_customer_orders
)
order by total_orders desc;
-- Identifies repeat/loyal customers based on order frequency

-- =========================================
-- PART 9: CTEs
-- =========================================
-- CTEs ---> comman table expressions
-- it is a temporary result set that we creat at the buginning of a SQL query and then used inside the same query
-- customer revenue analysis
-- which customer have spent more than the average customer?
with customer_sales as           -- creates a CTE
( select CustomerID,             
sum(Revenue) as total_spent      -- we collect the customer id and then calculates the customers total spending as total_spent
from sales                       -- From sales table
where CustomerID is not null     -- removes the records where customerID is missing
group by CustomerID              -- calculate the total revenue saperately for each customer
)                                -- here the temporary query finishes
select CustomerID,               
total_spent
from customer_sales              -- here we are creating CTE almost like a table
where total_spent >
(
select avg(total_spent)          -- average spending across all customers
from customer_sales
) 
order by total_spent desc;        -- higest-spending customers apper first

-- Customers orders + revenue + total spent
-- Shows each customers total rders, quantity purchased, and revenue.
with customer_summary as
(
select CustomerID, Country,
count(Distinct InvoiceNo) as total_orders,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue
from sales
where CustomerID is not null
group by CustomerID, Country
)
select CustomerID, Country, total_orders, total_quantity, total_revenue
from customer_summary
order by total_revenue desc;
-- This creat a clean customer summary table

-- Product performance
-- which product generate the most revenue?
with product_sales as
(
select StockCode, Description,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue
from sales
group by StockCode, Description
)
select StockCode, Description, total_Quantity, total_revenue
from product_sales
order by total_revenue desc
limit 10;
-- it creats a reusable product_level summary

-- Country performance
-- Which country generate most revenue and orders
with country_summary as
(
select Country,
count(distinct InvoiceNo) as total_orders,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue
from sales
group by country
)
select Country, total_orders, total_quantity, total_revenue
from country_summary
order by total_revenue desc;
-- It creates a country level business summary

-- MOnthly sales Analysis
-- How much revenue did wwe generate by month
with monthly_sales as
(
select
year(InvoiceDate) as sales_year,
month(InvoiceDate) as sales_month,
sum(Revenue) as total_revenue
from sales
group by year(InvoiceDate), month(InvoiceDate)
)
select sales_year, sales_month, total_revenue
from monthly_sales
order by sales_year, sales_month;
-- it creates monthyly sales summary

-- Monthly orders and revenue
-- we can make the monthaly analysis more usseful by combining orders and revenue
with monthly_sales as
(
select
year(InvoiceDate) as sales_year,
month(InvoiceDate) as sales_month,
Count(distinct InvoiceNo) as total_orders,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue
from sales
group by year(InvoiceDate), month(InvoiceDate)
)
select sales_year, sales_month, total_orders, total_quantity, total_revenue
from monthly_sales
order by sales_year, sales_month;
-- now we can compare month , orders, quantity, revenue

-- =========================================
-- PART 10: WINDOW FUNCTIONS
-- =========================================
-- Window Function performs a calculation across a group of related rows without combining those rows into one row.
-- Customer ranking
with customer_sales as
(
select CustomerID,
sum(Revenue) as total_revenue
from sales
where CustomerID is not null
group by CustomerID
)
select CustomerID, total_revenue,
row_number() over(                   -- means give each row a number
order by total_revenue desc
) as Customer_rank
from customer_sales;
-- It gives every customer a ranking

-- Top 10 Customers
with customer_sales as
(
select CustomerID, 
sum(Revenue) as total_revenue
from sales
where CustomerID is not null
group by CustomerID
),
ranked_customers as
(
select CustomerID, total_revenue,
row_number() over (
order by total_revenue desc
) as customer_rank
from customer_sales
)
select CustomerID, total_revenue, customer_rank
from ranked_customers
where customer_rank <= 10
order by customer_rank;  
-- this give top 10 customers by revenue

--  Products in each country
-- what are the top 3 products in each country
with product_country_sales as
(
select Country, StockCode, Description,
Sum(Revenue) as total_revenue
from sales
group by Country, StockCode, Description
),
ranked_products as
(
select Country, StockCode, Description, total_revenue,
row_number() over(
partition by Country           -- Start the ranking saperately for every country
order by total_revenue desc
) as product_rank
from product_country_sales
)
select Country, StockCode, Description, total_revenue, product_rank
from ranked_products
where product_rank <= 3
order by Country, product_rank;

-- Running or cumulative Revenue
-- How much Revenue have accumulated over time?
with monthly_sales as
(
select 
year(InvoiceDate) as sales_year,
month(InvoiceDate) as sales_month,
sum(Revenue) as monthly_revenue
from sales
group by sales_year, sales_month
)
select
sales_year, sales_month, monthly_revenue,
sum(monthly_revenue) over(
order by sales_year, sales_month
) as cummlative_revenue
from monthly_sales
order by sales_year, sales_month;

-- Previous month revenue
-- what was the previous months revnue?
with monthly_sales as
(
select
year(InvoiceDate) as sales_year,
month(InvoiceDate) as sales_month,
sum(Revenue) as monthly_revenue
from sales
group by sales_year, sales_month
)
select
sales_year, sales_month, monthly_revenue,
lag(monthly_revenue) over (             -- gives value from the previous row here february looks at january, march looks at february
order by sales_year, sales_month
) as previous_month_revenue
from monthly_sales
order by sales_year, sales_month;

-- Month over month revenue change
-- how much did revenue increase or decrease compared with previous month
with monthly_sales as
(
select
year(InvoiceDate) as sales_year,
month(InvoiceDate) as sales_month,
sum(Revenue) as monthly_revenue
from sales
group by sales_year, sales_month
),
monthly_comparison as
(
select
sales_year, sales_month, monthly_revenue,
lag(monthly_revenue) over(
order by sales_year, sales_month
) as previous_month_revenue
from monthly_sales
)
select sales_year, sales_month, monthly_revenue, previous_month_revenue,
monthly_revenue - previous_month_revenue as revenue_change
from monthly_comparison
order by sales_year, sales_month;

-- =========================================
-- PART 11: DATE & TIME ANALYSIS
-- =========================================
-- Reveneue by month
select 
year(InvoiceDate) as sales_year,
month(InvoiceDate) as sales_month,
sum(Revenue) as total_revenue
from sales
group by sales_year, sales_month
order by sales_year, sales_month;

-- Monthly orders
select 
year(InvoiceDate) as sales_year,
month(InvoiceDate) as sales_month,
count(distinct InvoiceNo) as total_orders
from sales
group by sales_year, sales_month
order by sales_year, sales_month;

-- monthly sales summary
select 
year(InvoiceDate) as sales_year,
month(InvoiceDate) as sales_month,
count(distinct InvoiceNo) as total_orders,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue,
sum(Revenue) / count(distinct InvoiceNo) as average_order_values
from sales
group by sales_year, sales_month
order by sales_year, sales_month;

-- Revenue by day of week
select
dayname(InvoiceDate) as day_name,
count(Distinct InvoiceNo) as total_orders,
sum(Revenue) as total_revenue
from sales
group by day_name
order by total_revenue desc;

-- Revenue by hour
select
hour(InvoiceDate) as sales_hour,
count(distinct InvoiceNo) as total_orders,
sum(Revenue) as total_revenue
from sales
group by sales_hour
order by total_orders desc;

-- =========================================
-- PART 12: ADVANCED BUSINESS ANALYSIS
-- =========================================
-- Top Customers by Revenue ⭐⭐⭐
with customer_sales as
(
select 
CustomerID, Country,
count(distinct InvoiceNo) as total_orders,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue
from sales
where CustomerID is not null
group by CustomerID, Country
)
select
CustomerID, Country, total_orders, total_quantity, total_revenue
from customer_sales
order by total_revenue desc
limit 10;

-- Customer Purchase Frequency ⭐⭐⭐
with customer_orders as
(
select CustomerID,
count(InvoiceNo) as total_orders,
sum(Revenue) as total_revenue
from sales
where CustomerID is not null
group by CustomerID
)
select
CustomerID, total_orders, total_revenue
from customer_orders
order by total_orders desc
limit 10;

-- High-Value Customer Segmentation ⭐⭐⭐
with customer_sales as
(
select
CustomerID,
sum(Revenue) as total_revenue
from sales
where CustomerID is not null
group by CustomerID
),
customer_segments as
(
select CustomerID, total_revenue,
case
when total_revenue < 1000 then 'Low Value'
when total_revenue <= 5000 then 'Medium Value'
else 'High Value'
end as customer_segment
from customer_sales
)
select
customer_segment,
count(*) as total_customers,
sum(total_revenue) as segment_revenue
from customer_segments
group by customer_segment
order by segment_revenue desc;

-- Top Products by Revenue ⭐⭐⭐
with product_sales as
(
select StockCode,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue
from sales
group by StockCode
)
select
StockCode, total_quantity, total_revenue
from product_sales
order by total_revenue desc
limit 10;

-- High-Volume but Lower-Revenue Products ⭐⭐
with product_sales as
(
select StockCode,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue
from sales
group by StockCode
)
select
StockCode, total_quantity, total_revenue
from Product_sales
where total_quantity > 1000
order by total_revenue asc;

-- Country Performance ⭐⭐⭐
with country_sales as
(
select Country,
count(distinct InvoiceNo) as total_orders,
count(distinct CustomerID) as total_customers,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue
from sales
group by Country
)
select Country, total_orders, total_customers, total_quantity, total_revenue
from country_sales
order by total_revenue desc;


-- Monthly Revenue Growth ⭐⭐⭐
with monthly_sales as
(
select 
year(InvoiceDate) as sales_year,
month(InvoiceDate) as sales_month,
sum(Revenue) as monthly_revenue
from sales
group by sales_year, sales_month
),
monthly_comaprison as
(
select sales_year, sales_month, monthly_revenue,
lag(monthly_revenue) over(
order by sales_year, sales_month
) as previous_month_revenue
from monthly_sales
)
select
sales_year, sales_month, monthly_revenue,
monthly_revenue - previous_month_revenue as revenue_chsnge,
round(
((monthly_revenue - previous_month_revenue)/ nullif(previous_month_revenue, 0)) * 100, 2
) as growth_percentage
from monthly_comaprison
order by sales_year, sales_month; 

-- Return / Cancellation Analysis ⭐⭐⭐
select
case 
when InvoiceNo like 'C%' then 'Cancelled'
else 'Normal Sale'
end as transaction_status,
count(distinct InvoiceNo) as total_orders,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue
from sales
group by transaction_status;

-- Cancellation Rate ⭐⭐⭐
with order_status as
(
select InvoiceNo,
case
when InvoiceNo like 'C%' then 'Cancelled'
else 'Normal Sale'
end as transaction_status
from sales
group by InvoiceNo, transaction_status
)
select
count(*) as total_orders,
sum(transaction_status = 'Cancelled') as cancelled_orders,
round(
sum(transaction_status = 'Cancelled')/ count(*) * 100,2
) as cancellation_rate_percentage
from order_status;