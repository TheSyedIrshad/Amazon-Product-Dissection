CREATE DATABASE amazon_analytics;

\c amazon_analytics;

-- ======================================================
-- File: 01_schema.sql
-- Project: Amazon-Style E-Commerce Analytics
-- Purpose: Define core tables (structure only)
-- ======================================================

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    email      VARCHAR(100) UNIQUE NOT NULL,
    signup_date DATE NOT NULL
);

SELECT * FROM customers;


-- ======================================================
-- Table: categories
-- Purpose: Product grouping for analytics
-- Grain: 1 row per category
-- ======================================================

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

SELECT * FROM categories;

-- ======================================================
-- Table: products
-- Purpose: Product master data
-- Grain: 1 row per product
-- ======================================================

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    price NUMERIC(10,2) NOT NULL
);

SELECT * FROM products;

-- ======================================================
-- Table: orders
-- Purpose: Customer checkout transactions
-- Grain: 1 row per order
-- ======================================================

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP NOT NULL,
    order_status VARCHAR(20) NOT NULL
);

SELECT * FROM orders;

-- ======================================================
-- Table: order_items
-- Purpose: Line-level items within an order
-- Grain: 1 row per product per order
-- ======================================================

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL
);

SELECT * FROM order_items;

-- ======================================================
-- Table: payments
-- Purpose: Financial transactions for orders
-- Grain: 1 row per payment attempt
-- ======================================================

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date TIMESTAMP NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    amount NUMERIC(10,2) NOT NULL
);

SELECT * FROM payments;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

