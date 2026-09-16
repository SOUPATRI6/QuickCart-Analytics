CREATE TABLE quickcart (
    order_id VARCHAR(20),
    order_date DATE,
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    city VARCHAR(50),
    category VARCHAR(50),
    product VARCHAR(100),
    quantity NUMERIC,
    unit_price NUMERIC,
    discount_pct NUMERIC,
    payment_method VARCHAR(50),
    delivery_time_min NUMERIC,
    order_status VARCHAR(50),
    rating NUMERIC
);

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'quickcart'
ORDER BY ordinal_position;

SELECT COUNT(*)
FROM quickcart;

SELECT *
FROM quickcart
LIMIT 10;

--Q1. Which payment method is most commonly used?
SELECT payment_method, COUNT(payment_method) AS order_count
FROM quickcart
GROUP BY payment_method
ORDER BY order_count DESC;

--Q2. Which category has the highest average products ordered?
SELECT category, ROUND(AVG(quantity), 2) AS avg_products_ordered
FROM quickcart
GROUP BY category ORDER BY avg_products_ordered DESC; 

--Q3. Which product has the highest average discount percentage?
SELECT product, ROUND(AVG(discount_pct), 2) 
AS avg_discount_percentage
FROM quickcart
GROUP BY product 
ORDER BY avg_discount_percentage DESC;

--Q4. What is the total revenue by city?
SELECT city,
       ROUND(
           SUM(quantity * unit_price * (1 - discount_pct / 100)),
           2
       ) AS total_revenue
FROM quickcart
WHERE city <> 'Missing'
GROUP BY city
ORDER BY total_revenue DESC;

--Q5. Are any city values stored as the text "Missing" rather than NULL?
SELECT city, COUNT(*) AS order_count
FROM quickcart
GROUP BY city
ORDER BY order_count DESC;

--Q6. What is the relationship between order status and rating?
SELECT order_status, ROUND(AVG(rating), 2) AS avg_rating,
COUNT(rating) AS rated_orders
FROM quickcart
GROUP BY order_status;

--Q7. How is QuickCart's order volume changing over time/monthly?
SELECT DATE_TRUNC('month', order_date) AS month,
       COUNT(order_id) AS order_count
FROM quickcart
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

--Q8. How does revenue change month by month?
SELECT DATE_TRUNC('month', order_date) AS month,
       ROUND(
           SUM(quantity * unit_price * (1 - discount_pct / 100)),
           2
       ) AS total_revenue
FROM quickcart
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

--Q9. What percentage of QuickCart's orders are Delivered, Returned, Cancelled, and Pending?
SELECT COUNT(order_id),
ROUND(
    SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END)
    * 100.0 / COUNT(order_id),
    2
) AS delivered_percentage,
ROUND(
    SUM(CASE WHEN order_status = 'Pending' THEN 1 ELSE 0 END)
    * 100.0 / COUNT(order_id),
    2
) AS pending_percentage,
ROUND(
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
    * 100.0 / COUNT(order_id),
    2
) AS cancelled_percentage,
ROUND(
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)
    * 100.0 / COUNT(order_id),
    2
) AS returned_percentage
FROM quickcart;

--Q10.  Which products generate the most revenue?
SELECT product,
ROUND(
       SUM(quantity * unit_price * (1 - discount_pct / 100)),
       2
     ) AS total_revenue
FROM quickcart
GROUP BY product
ORDER BY total_revenue DESC;

--Q11. Average orders per customer for each month?
SELECT DATE_TRUNC('month', order_date) AS month, 
COUNT(order_id) AS total_order,
COUNT(DISTINCT customer_id) AS unique_customer
FROM quickcart
GROUP BY month;

--Q12. Average discount percentage for February and June?
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    ROUND(AVG(discount_pct), 2) AS avg_discount
FROM quickcart
GROUP BY month
ORDER BY month;

--Q13. WHY “Unknown” is currently the highest-revenue product?
SELECT 
    ROUND(
        SUM(quantity * unit_price * (1 - discount_pct / 100)),
        2
    ) AS unknown_revenue
FROM quickcart
WHERE product = 'Unknown';

SELECT
    COUNT(*) AS unknown_orders,
    COUNT(quantity) AS orders_with_quantity,
    COUNT(discount_pct) AS orders_with_discount,
    COUNT(delivery_time_min) AS orders_with_delivery_time
FROM quickcart
WHERE product = 'Unknown';

--Q14. What would you investigate next about returned orders?
SELECT 
    order_status,
    ROUND(AVG(delivery_time_min), 2) AS avg_delivery_time
FROM quickcart
GROUP BY order_status
ORDER BY avg_delivery_time DESC;


SELECT city,
       COUNT(*) AS total_orders,
       SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) AS returned_orders
FROM quickcart
WHERE city <> 'Missing'
GROUP BY city
ORDER BY returned_orders DESC;


SELECT 
    order_status,
    ROUND(AVG(delivery_time_min), 2) AS avg_delivery_time
FROM quickcart
WHERE city = 'Kolkata'
GROUP BY order_status;


SELECT category,
       COUNT(*) AS returned_orders
FROM quickcart
WHERE city = 'Kolkata'
  AND order_status = 'Returned'
GROUP BY category
ORDER BY returned_orders DESC;

SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) AS returned_orders
FROM quickcart
WHERE city = 'Kolkata'
  AND category = 'Electronics';


SELECT 
    ROUND(AVG(rating), 2) AS avg_rating
FROM quickcart
WHERE city = 'Kolkata'
  AND category = 'Electronics'
  AND order_status = 'Returned';