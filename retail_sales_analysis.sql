-- ============================================
-- Superstore Sales Analysis
-- Author: Alicia Meyer
-- ============================================


-- ============================================
-- SECTION 1: DATA EXPLORATION
-- ============================================

-- First, I want to look at each table and get a feel for the data
-- before starting any cleaning or analysis.

SELECT * FROM order_items LIMIT 10;
SELECT * FROM customers LIMIT 10;
SELECT * FROM geography LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM products LIMIT 10;

-- Checking how many rows are in each table.

SELECT COUNT(*) AS total_order_items FROM order_items;
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_locations FROM geography;


-- ============================================
-- SECTION 2: DATA CLEANING
-- ============================================
-- Before analysing the data, I want to clean and validate it
-- to make sure the results are based on consistent data.

-- Trimming whitespace from text columns.
-- Extra spaces can cause joins and filtering to behave
-- unexpectedly, so it's worth cleaning them up first.

UPDATE customers
SET
    customer_id   = TRIM(customer_id),
    customer_name = TRIM(customer_name),
    segment       = TRIM(segment);

UPDATE geography
SET
    city        = TRIM(city),
    state       = TRIM(state),
    country     = TRIM(country),
    postal_code = TRIM(postal_code),
    region      = TRIM(region);

UPDATE orders
SET
    order_id  = TRIM(order_id),
    ship_mode = TRIM(ship_mode),
    city      = TRIM(city),
    state     = TRIM(state);

UPDATE products
SET
    product_id   = TRIM(product_id),
    product_name = TRIM(product_name),
    category     = TRIM(category),
    subcategory  = TRIM(subcategory);

-- The imported sales values contained floating point precision
-- differences, so I'm rounding them to two decimal places
-- since the values represent currency.

UPDATE order_items
SET sales = ROUND(sales::numeric, 2);

-- Checking it looks right after the update.
SELECT sales FROM order_items LIMIT 10;


-- ============================================
-- SECTION 3: REMOVING DUPLICATES
-- ============================================

-- Checking if row_id is truly unique in order_items.
-- Each row should represent one transaction line.

SELECT row_id, COUNT(*)
FROM order_items
GROUP BY row_id
HAVING COUNT(*) > 1;

-- Same check for order_id in orders table.

SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- No duplicate records were found, so no further cleaning was needed.


-- ============================================
-- SECTION 4: FILTERING & VALIDATION
-- ============================================

-- Are there any sales values that are zero or negative?
-- There shouldn't be since every row should be an actual sale.

SELECT * FROM order_items
WHERE sales <= 0;

-- Checking if any orders have a ship date before the order date.
-- Any records returned here would indicate a data quality issue.

SELECT * FROM orders
WHERE ship_date < order_date;

-- Making sure every customer has a segment assigned.

SELECT * FROM customers
WHERE segment IS NULL
OR segment = '';

-- Checking geography for any missing regions.

SELECT * FROM geography
WHERE region IS NULL
OR region = '';

-- Making sure no products are missing a category.

SELECT * FROM products
WHERE category IS NULL
OR category = '';

-- This checks if there are any order_ids in order_items
-- that don't exist in the orders table.
-- Used a LEFT JOIN here to catch anything that doesn't match.

SELECT oi.order_id
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- ============================================
-- SECTION 5: JOINS
-- ============================================

-- JOIN 1: Orders and Customers
-- Bringing all the tables together to view the complete
-- transaction from customer to product to location.

SELECT 
    o.order_id,
    o.order_date,
    o.ship_mode,
    c.customer_name,
    c.segment
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LIMIT 10;


-- JOIN 2: Orders and Geography
-- Pulling in location details for each order.
-- Joining on both city and state because city names
-- repeat across different states.

SELECT 
    o.order_id,
    o.order_date,
    g.city,
    g.state,
    g.region,
    g.country
FROM orders o
JOIN geography g ON o.city = g.city AND o.state = g.state
LIMIT 10;


-- JOIN 3: Order Items and Orders
-- Linking the sales value back to the actual order.

SELECT 
    o.order_id,
    o.order_date,
    oi.sales
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
LIMIT 10;


-- JOIN 4: Order Items and Products
-- Finding out what product was in each transaction.

SELECT 
    oi.order_id,
    p.product_name,
    p.category,
    p.subcategory,
    oi.sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LIMIT 10;


-- JOIN 5: All Tables Together
-- This pulls everything into one view.
-- Wanted to see the full picture of a transaction
-- from customer to product to location.

SELECT
    o.order_id,
    o.order_date,
    o.ship_mode,
    c.customer_name,
    c.segment,
    g.city,
    g.state,
    g.region,
    p.category,
    p.subcategory,
    p.product_name,
    oi.sales
FROM orders o
JOIN customers c    ON o.customer_id = c.customer_id
JOIN geography g    ON o.city = g.city AND o.state = g.state
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
LIMIT 10;


-- ============================================
-- SECTION 6: AGGREGATION ANALYSIS
-- ============================================

-- Which category brings in the most sales?

SELECT 
    p.category,
    ROUND(SUM(oi.sales)::numeric, 2) AS total_sales,
    COUNT(oi.order_id)               AS total_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;


-- Breaking it down further by subcategory.
-- Wanted to see which subcategories are carrying
-- each category and which ones are underperforming.

SELECT 
    p.category,
    p.subcategory,
    ROUND(SUM(oi.sales)::numeric, 2) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category, p.subcategory
ORDER BY total_sales DESC;


-- Sales by region.
-- Curious to see if there is a big gap between regions.

SELECT 
    g.region,
    ROUND(SUM(oi.sales)::numeric, 2) AS total_sales,
    COUNT(oi.order_id)               AS total_orders
FROM order_items oi
JOIN orders o    ON oi.order_id = o.order_id
JOIN geography g ON o.city = g.city AND o.state = g.state
GROUP BY g.region
ORDER BY total_sales DESC;


-- Sales by customer segment.

SELECT 
    c.segment,
    ROUND(SUM(oi.sales)::numeric, 2) AS total_sales,
    COUNT(DISTINCT o.order_id)        AS total_orders
FROM order_items oi
JOIN orders o    ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_sales DESC;


-- Top 10 customers by total sales.

SELECT 
    c.customer_name,
    c.segment,
    ROUND(SUM(oi.sales)::numeric, 2) AS total_sales
FROM order_items oi
JOIN orders o    ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name, c.segment
ORDER BY total_sales DESC
LIMIT 10;


-- Average order value by shipping method.
-- Checking whether average order value differs
-- across shipping methods.

SELECT 
    o.ship_mode,
    ROUND(AVG(oi.sales)::numeric, 2)  AS avg_sales,
    COUNT(DISTINCT o.order_id)         AS total_orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
GROUP BY o.ship_mode
ORDER BY avg_sales DESC;


-- ============================================
-- SECTION 7: WINDOW FUNCTIONS
-- ============================================

-- Ranking customers by total sales.
-- Used RANK() so that tied values get the same position.

SELECT 
    c.customer_name,
    c.segment,
    ROUND(SUM(oi.sales)::numeric, 2)          AS total_sales,
    RANK() OVER (ORDER BY SUM(oi.sales) DESC) AS sales_rank
FROM order_items oi
JOIN orders o    ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name, c.segment
ORDER BY sales_rank
LIMIT 20;


-- Ranking products within each category.
-- PARTITION BY means the ranking resets for each category
-- so I can see the number one product per category.

SELECT 
    p.category,
    p.product_name,
    ROUND(SUM(oi.sales)::numeric, 2)                      AS total_sales,
    RANK() OVER (PARTITION BY p.category 
                 ORDER BY SUM(oi.sales) DESC)             AS rank_in_category
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category, p.product_name
ORDER BY p.category, rank_in_category;


-- Running total of sales over time.
-- This shows how revenue accumulates day by day.

SELECT
    o.order_date,
    ROUND(SUM(oi.sales)::numeric, 2)                      AS daily_sales,
    ROUND(SUM(SUM(oi.sales)) 
          OVER (ORDER BY o.order_date)::numeric, 2)       AS running_total
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
GROUP BY o.order_date
ORDER BY o.order_date;


-- Comparing each customer's total sales to the overall average.
-- Helps spot who is significantly above or below average.

SELECT
    c.customer_name,
    ROUND(SUM(oi.sales)::numeric, 2)               AS total_sales,
    ROUND(AVG(SUM(oi.sales)) OVER ()::numeric, 2)  AS avg_customer_sales
FROM order_items oi
JOIN orders o    ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_sales DESC;


-- ============================================
-- SECTION 8: TIME ANALYSIS
-- ============================================

-- Total sales per year.
-- Checking how sales change from one year to the next.

SELECT
    EXTRACT(YEAR FROM o.order_date)   AS year,
    ROUND(SUM(oi.sales)::numeric, 2)  AS total_sales,
    COUNT(DISTINCT o.order_id)        AS total_orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
GROUP BY year
ORDER BY year;


-- Sales broken down by month and year.
-- Looking for seasonal patterns.

SELECT
    EXTRACT(YEAR FROM o.order_date)   AS year,
    EXTRACT(MONTH FROM o.order_date)  AS month,
    ROUND(SUM(oi.sales)::numeric, 2)  AS total_sales
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
GROUP BY year, month
ORDER BY year, month;


-- Which month performs best overall across all years?

SELECT
    EXTRACT(MONTH FROM o.order_date)  AS month,
    ROUND(SUM(oi.sales)::numeric, 2)  AS total_sales
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
GROUP BY month
ORDER BY total_sales DESC;


-- Month on month comparison using LAG().
-- LAG() lets me pull the previous month's sales
-- so I can see whether sales went up or down each month.

SELECT
    EXTRACT(YEAR FROM o.order_date)                        AS year,
    EXTRACT(MONTH FROM o.order_date)                       AS month,
    ROUND(SUM(oi.sales)::numeric, 2)                       AS total_sales,
    ROUND(LAG(SUM(oi.sales)) 
          OVER (ORDER BY EXTRACT(YEAR FROM o.order_date), 
                         EXTRACT(MONTH FROM o.order_date))
          ::numeric, 2)                                    AS prev_month_sales
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
GROUP BY year, month
ORDER BY year, month;
