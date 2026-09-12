-- =========================================
-- E-COMMERCE SALES & CUSTOMER ANALYTICS
-- FINAL SQL ANALYSIS
-- =========================================
use ecommerce_analysis;
show tables;
select count(*) from sales;


-- =========================================
-- 1. OVERALL BUSINESS KPIs
-- =========================================
-- This gives the main business numbers for the project
select
count(*) as total_records,
count(distinct InvoiceNo) as total_orders,
count(distinct StockCode) as total_products,
count(distinct CustomerID) as total_customers,
count(distinct Country) as total_countries,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue,
round(
sum(Revenue) / count(Distinct InvoiceNo), 2
) as average_order_value
from sales;



-- =========================================
-- 2. MONTHLY SALES PERFORMANCE
-- =========================================
select
year(InvoiceDate) as sales_year,
month(InvoiceDate) as sales_month,
count(Distinct InvoiceNo) as total_orders,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue,
round(sum(Revenue) / count(Distinct InvoiceNo), 2
) as average_order_value
from sales
group by sales_year, sales_month
order by sales_year, sales_month;


-- =========================================
-- 3. TOP CUSTOMERS
-- =========================================
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

-- =========================================
-- 4. CUSTOMER SEGMENTATION
-- =========================================
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


-- =========================================
-- 5. TOP PRODUCTS
-- =========================================
with product_sales as
(
select
StockCode, Description,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue
from sales
group by StockCode, Description
)
select StockCode, Description, total_quantity, total_revenue
from product_sales
order by total_revenue desc
limit 10;




-- =========================================
-- 6. TOP PRODUCTS BY COUNTRY
-- =========================================
-- Top 3 products in each country
with product_country_sales as
(select
Country, StockCode, Description,
sum(Revenue) as total_revenue
from sales
group by Country, StockCode, Description
),
ranked_products as
(
select Country, StockCode, Description, total_revenue,
row_number() over (
partition by country
order by total_revenue desc
) as product_rank
from product_country_sales
)
select
Country, StockCode, Description, total_revenue, product_rank
from ranked_products
where product_rank <= 3
order by Country, product_rank;


-- =========================================
-- 7. COUNTRY PERFORMANCE
-- =========================================
select Country,
count(distinct InvoiceNo) as total_orders,
count(Distinct CustomerID) as total_customers,
sum(Quantity) as total_quantity,
sum(Revenue) as total_revenue
from sales
group by Country
order by total_revenue desc;
-- This compares countries based on orders, customers, quantity, revenue


-- =========================================
-- 8. MONTHLY REVENUE GROWTH
-- =========================================
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
select sales_year, sales_month, monthly_revenue,
lag(monthly_revenue) over (
order by sales_year, sales_month
) as previous_month_revenue
from monthly_sales
)
select
sales_year, sales_month, monthly_revenue, previous_month_revenue,
monthly_revenue - previous_month_revenue as revenue_change,
round(
((monthly_revenue - previous_month_revenue) / nullif(previous_month_revenue, 0)) * 100, 2
) as growth_percentage
from monthly_comparison
order by sales_year, sales_month;
-- The first month will show NULL for the previous month because there is no earlier month for comparison.


-- =========================================
-- 9. CANCELLATION ANALYSIS
-- =========================================
select
case
when InvoiceNo like 'C%' then 'Cancelled'
else 'Normal Sale'
end as transaction_status,
count(distinct InvoiceNo) as total_quantity,
sum(Revenue) as total_revenue
from sales
group by transaction_status;


-- =====================================================
-- 10. Cancellation Rate
-- =====================================================
with order_status as
(
select InvoiceNo,
case
when InvoiceNo like 'C%' then 'Cancelled'
else 'Normal Sale'
end as transaction_status
from sales
group by
InvoiceNo,
transaction_status
)
select
count(*) as total_orders,
sum(transaction_status = 'Cancelled') as cancelled_orders,
round(
sum(transaction_status = 'Cancelled') / count(*) *100, 2
) as cancellation_rate_percentage
from order_status;