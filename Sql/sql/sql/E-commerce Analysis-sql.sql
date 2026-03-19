-- Analysis 1: Monthly Order Volume Trend
-- Objective: Track how order volume changes by month

SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month,
    COUNT(order_id) AS total_orders
FROM orders
WHERE order_purchase_timestamp IS NOT NULL
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY
    order_year,
    order_month;
    
    -- Analysis 2: Monthly Revenue Trend
-- Objective: Track total revenue generated per month

SELECT
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    ROUND(SUM(op.payment_value), 2) AS total_revenue
FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    order_year,
    order_month;
    
    -- Analysis 3: Top Selling Product Categories
-- Objective: Identify product categories with the highest number of items sold

SELECT
    pct.product_category_name_english AS product_category,
    COUNT(oi.order_item_id) AS items_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY
    pct.product_category_name_english
ORDER BY
    items_sold DESC;
    
    -- Analysis 4: Top 10 Sellers by Revenue
-- Objective: Identify sellers generating the highest revenue

SELECT
    oi.seller_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
GROUP BY
    oi.seller_id
ORDER BY
    total_revenue DESC
LIMIT 10;

-- Analysis 5: Average Delivery Time
-- Objective: Measure how long orders take to be delivered

SELECT
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
AND order_purchase_timestamp IS NOT NULL;

-- Analysis 6: Orders by Status
-- Objective: Understand distribution of order statuses

SELECT
    order_status,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Analysis 7: Top 10 Customers by Total Spend
-- Objective: Identify customers generating the highest revenue

SELECT
    c.customer_unique_id,
    ROUND(SUM(op.payment_value), 2) AS total_spent,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY
    c.customer_unique_id
ORDER BY
    total_spent DESC
LIMIT 10;

-- Analysis 8: Average Review Score by Product Category
-- Objective: Measure customer satisfaction by product category

SELECT
    pct.product_category_name_english AS product_category,
    ROUND(AVG(orv.review_score), 2) AS avg_review_score,
    COUNT(orv.review_id) AS total_reviews
FROM order_reviews orv
JOIN orders o
    ON orv.order_id = o.order_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY
    pct.product_category_name_english
ORDER BY
    avg_review_score DESC;
    
    -- Analysis 9: Late Deliveries
-- Objective: Measure how often orders are delivered later than the estimated date

SELECT
    COUNT(*) AS total_delivered_orders,
    SUM(CASE 
            WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 
            ELSE 0 
        END) AS late_deliveries,
    ROUND(
        SUM(CASE 
                WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 
                ELSE 0 
            END) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_percentage
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
AND order_estimated_delivery_date IS NOT NULL;

-- Analysis 10: Customer Repeat Purchase Rate
-- Objective: Measure how many customers place more than one order

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
) AS customer_orders;

-- Analysis 11: Top Products by Revenue
-- Objective: Identify products generating the highest revenue

SELECT
    oi.product_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
GROUP BY
    oi.product_id
ORDER BY
    total_revenue DESC
LIMIT 10;

-- Analysis 12: Revenue by Product Category
-- Objective: Identify which product categories generate the most revenue

SELECT
    pct.product_category_name_english AS product_category,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY
    pct.product_category_name_english
ORDER BY
    total_revenue DESC;
    
    -- Analysis 13: Customer Lifetime Value (CLV)
-- Objective: Measure the total revenue generated by each customer

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(op.payment_value), 2) AS lifetime_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY
    c.customer_unique_id
ORDER BY
    lifetime_value DESC
LIMIT 20;

-- Analysis 14: Top Cities by Order Volume
-- Objective: Identify cities with the highest number of orders

SELECT
    c.customer_city,
    c.customer_state,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY
    c.customer_city,
    c.customer_state
ORDER BY
    total_orders DESC
LIMIT 20;