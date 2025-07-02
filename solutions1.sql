USE magist123; 


-- 1. How many orders are there in the dataset?
SELECT COUNT(*) AS orders_count FROM orders; 
-- 99441


-- 2. Are orders actually delivered?

SELECT COUNT(*)
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL; -- 97658

SELECT COUNT(*), order_status
FROM orders
WHERE order_status = "delivered"; -- 96478

-- 3. Is Magist having user growth?
SELECT YEAR(order_purchase_timestamp) AS year, 
       MONTH(order_purchase_timestamp) AS month, 
       COUNT(*) AS order_count
FROM orders
GROUP BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp) ASC, MONTH(order_purchase_timestamp) ASC;

SELECT YEAR(order_purchase_timestamp) AS year,
       COUNT(*) AS total_orders,
       ROUND(
           (COUNT(*) - 
            LAG(COUNT(*)) OVER (ORDER BY YEAR(order_purchase_timestamp))) 
           / LAG(COUNT(*)) OVER (ORDER BY YEAR(order_purchase_timestamp)) * 100, 2) AS growth_percentage
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY year ASC;

-- acutal solution
SELECT
	COUNT(DISTINCT customer_id) AS customers, 
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_
FROM orders
GROUP BY year_, month_
ORDER BY year_, month_ ASC;

-- 4. How many products are there in the products table?
SELECT COUNT(DISTINCT product_id) AS products_total
FROM products;  -- 32951

-- 5. Which are the categories with most products?
SELECT product_category_name_english,
	COUNT(DISTINCT product_id) AS num_products
FROM products p
JOIN product_category_name_translation pc USING (product_category_name)
GROUP BY pc.product_category_name_english
ORDER BY num_products DESC;

-- 6. How many of those products were present in actual transactions?
SELECT * from order_items; 

SELECT COUNT(DISTINCT product_id) AS n_products
from order_items; 

-- 7. What’s the price for the most expensive and cheapest products?
SELECT * FROM order_items;
SELECT
MAX(price) AS expensive,
MIN(price) AS cheap
FROM order_items;

-- 8. What are the highest and lowest payment values?
SELECT * FROM order_payments; 
SELECT order_id, payment_value AS max_payval
FROM order_payments
ORDER BY payment_value DESC
LIMIT 1; 