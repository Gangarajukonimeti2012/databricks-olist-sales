-- Dashboard "Olist Sales": one dataset per query

-- 1. KPI totals
SELECT SUM(price)                  AS revenue,
       COUNT(DISTINCT order_id)    AS orders,
       COUNT(DISTINCT customer_id) AS customers
FROM olist.gold.fact_orders;

-- 2. Revenue by month
SELECT d.month_start, SUM(f.price) AS revenue
FROM olist.gold.fact_orders f
JOIN olist.gold.dim_date d ON f.order_date = d.order_date
GROUP BY d.month_start
ORDER BY d.month_start;

-- 3. Top 10 product categories
SELECT p.product_category, SUM(f.price) AS revenue
FROM olist.gold.fact_orders f
JOIN olist.gold.dim_product p ON f.product_id = p.product_id
GROUP BY p.product_category
ORDER BY revenue DESC
LIMIT 10;

-- 4. Orders by customer state
SELECT c.customer_state, COUNT(DISTINCT f.order_id) AS orders
FROM olist.gold.fact_orders f
JOIN olist.gold.dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY orders DESC;

-- 5. Payment type split
SELECT payment_type, SUM(payment_value) AS total_paid
FROM olist.gold.payments
GROUP BY payment_type;

-- 6. Average delivery days by month
SELECT d.month_start, AVG(f.delivery_days) AS avg_delivery_days
FROM olist.gold.fact_orders f
JOIN olist.gold.dim_date d ON f.order_date = d.order_date
GROUP BY d.month_start
ORDER BY d.month_start;
