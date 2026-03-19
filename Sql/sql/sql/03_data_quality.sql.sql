-- Project 5: SQL E-commerce Analysis (Olist)
-- File: 03_data_quality_checks.sql
-- Purpose: Validate loaded data

USE olist_portfolio;

-- Row counts
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'product_category_name_translation', COUNT(*) FROM product_category_name_translation
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation;

-- Null / blank key checks
SELECT 'customers.customer_id' AS check_name, COUNT(*) AS issue_count
FROM customers
WHERE customer_id IS NULL OR TRIM(customer_id) = ''
UNION ALL
SELECT 'orders.order_id', COUNT(*) FROM orders
WHERE order_id IS NULL OR TRIM(order_id) = ''
UNION ALL
SELECT 'orders.customer_id', COUNT(*) FROM orders
WHERE customer_id IS NULL OR TRIM(customer_id) = ''
UNION ALL
SELECT 'order_items.order_id', COUNT(*) FROM order_items
WHERE order_id IS NULL OR TRIM(order_id) = ''
UNION ALL
SELECT 'order_items.product_id', COUNT(*) FROM order_items
WHERE product_id IS NULL OR TRIM(product_id) = ''
UNION ALL
SELECT 'order_items.seller_id', COUNT(*) FROM order_items
WHERE seller_id IS NULL OR TRIM(seller_id) = ''
UNION ALL
SELECT 'order_payments.order_id', COUNT(*) FROM order_payments
WHERE order_id IS NULL OR TRIM(order_id) = ''
UNION ALL
SELECT 'order_reviews.order_id', COUNT(*) FROM order_reviews
WHERE order_id IS NULL OR TRIM(order_id) = '';

-- Duplicate primary key checks
SELECT 'customers PK duplicates' AS check_name, COUNT(*) AS issue_count
FROM (
    SELECT customer_id
    FROM customers
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) x
UNION ALL
SELECT 'orders PK duplicates', COUNT(*)
FROM (
    SELECT order_id
    FROM orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
) x
UNION ALL
SELECT 'products PK duplicates', COUNT(*)
FROM (
    SELECT product_id
    FROM products
    GROUP BY product_id
    HAVING COUNT(*) > 1
) x
UNION ALL
SELECT 'sellers PK duplicates', COUNT(*)
FROM (
    SELECT seller_id
    FROM sellers
    GROUP BY seller_id
    HAVING COUNT(*) > 1
) x;

-- Orphan checks
SELECT 'orders -> customers' AS check_name, COUNT(*) AS issue_count
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL
UNION ALL
SELECT 'order_items -> orders', COUNT(*)
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL
UNION ALL
SELECT 'order_items -> products', COUNT(*)
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL
UNION ALL
SELECT 'order_items -> sellers', COUNT(*)
FROM order_items oi
LEFT JOIN sellers s ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL
UNION ALL
SELECT 'order_payments -> orders', COUNT(*)
FROM order_payments op
LEFT JOIN orders o ON op.order_id = o.order_id
WHERE o.order_id IS NULL
UNION ALL
SELECT 'order_reviews -> orders', COUNT(*)
FROM order_reviews r
LEFT JOIN orders o ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Date sanity check
SELECT COUNT(*) AS bad_delivery_sequence
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp;

-- Geolocation sanity check
SELECT 
    MIN(geolocation_lat) AS min_lat,
    MAX(geolocation_lat) AS max_lat,
    MIN(geolocation_lng) AS min_lng,
    MAX(geolocation_lng) AS max_lng
FROM geolocation;