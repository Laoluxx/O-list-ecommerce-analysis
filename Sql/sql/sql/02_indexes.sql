-- Project 5: SQL E-commerce Analysis (Olist)
-- File: 02_create_indexes.sql
-- Purpose: Create indexes for performance

USE olist_portfolio;

CREATE INDEX idx_customers_unique_id ON customers(customer_unique_id);
CREATE INDEX idx_customers_zip ON customers(customer_zip_code_prefix);

CREATE INDEX idx_sellers_zip ON sellers(seller_zip_code_prefix);

CREATE INDEX idx_products_category ON products(product_category_name);

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_purchase_ts ON orders(order_purchase_timestamp);
CREATE INDEX idx_orders_status ON orders(order_status);

CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_order_items_seller_id ON order_items(seller_id);
CREATE INDEX idx_order_items_shipping_limit_date ON order_items(shipping_limit_date);

CREATE INDEX idx_order_payments_type ON order_payments(payment_type);

CREATE INDEX idx_order_reviews_score ON order_reviews(review_score);
CREATE INDEX idx_order_reviews_review_id ON order_reviews(review_id);

CREATE INDEX idx_translation_english
ON product_category_name_translation(product_category_name_english);

CREATE INDEX idx_geolocation_zip ON geolocation(geolocation_zip_code_prefix);
CREATE INDEX idx_geolocation_state ON geolocation(geolocation_state);