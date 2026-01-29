-- ============================================
-- Amazon E-Commerce Database Schema
-- Schema Name: new
-- PostgreSQL Script for pgAdmin4
-- ============================================

-- Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS new;

-- Set search path to use the 'new' schema
SET search_path TO new;

-- ============================================
-- Drop tables if they exist (for clean setup)
-- ============================================
DROP TABLE IF EXISTS new.Shipment CASCADE;
DROP TABLE IF EXISTS new.Payment CASCADE;
DROP TABLE IF EXISTS new.Order_Item CASCADE;
DROP TABLE IF EXISTS new."Order" CASCADE;
DROP TABLE IF EXISTS new.Wishlist CASCADE;
DROP TABLE IF EXISTS new.Cart CASCADE;
DROP TABLE IF EXISTS new.Product CASCADE;
DROP TABLE IF EXISTS new.Category CASCADE;
DROP TABLE IF EXISTS new.Customer CASCADE;

-- ============================================
-- 1. Customer Table
-- ============================================
CREATE TABLE new.Customer (
    Customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    address TEXT,
    ph_number VARCHAR(15)
);

COMMENT ON TABLE new.Customer IS 'Stores customer information and account details';
COMMENT ON COLUMN new.Customer.Customer_id IS 'Unique identifier for each customer';
COMMENT ON COLUMN new.Customer.email IS 'Customer email address for login';

-- ============================================
-- 2. Category Table
-- ============================================
CREATE TABLE new.Category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

COMMENT ON TABLE new.Category IS 'Product categories for organizing items';
COMMENT ON COLUMN new.Category.name IS 'Category name (e.g., Electronics, Books, Clothing)';

-- ============================================
-- 3. Product Table
-- ============================================
CREATE TABLE new.Product (
    Product_id SERIAL PRIMARY KEY,
    SKU VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    category_id INTEGER,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) 
        REFERENCES new.Category(category_id) ON DELETE SET NULL
);

COMMENT ON TABLE new.Product IS 'Product catalog with pricing and inventory';
COMMENT ON COLUMN new.Product.SKU IS 'Stock Keeping Unit - unique product identifier';
COMMENT ON COLUMN new.Product.stock IS 'Available quantity in inventory';

-- ============================================
-- 4. Cart Table
-- ============================================
CREATE TABLE new.Cart (
    Cart_id SERIAL PRIMARY KEY,
    Customer_customer_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    CONSTRAINT fk_cart_customer FOREIGN KEY (Customer_customer_id) 
        REFERENCES new.Customer(Customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_product FOREIGN KEY (product_id) 
        REFERENCES new.Product(Product_id) ON DELETE CASCADE,
    CONSTRAINT unique_cart_item UNIQUE (Customer_customer_id, product_id)
);

COMMENT ON TABLE new.Cart IS 'Shopping cart items for customers';
COMMENT ON COLUMN new.Cart.quantity IS 'Number of units in cart';

-- ============================================
-- 5. Wishlist Table
-- ============================================
CREATE TABLE new.Wishlist (
    wishlist_id SERIAL PRIMARY KEY,
    Customer_id INTEGER NOT NULL,
    Product_id INTEGER NOT NULL,
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_wishlist_customer FOREIGN KEY (Customer_id) 
        REFERENCES new.Customer(Customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_wishlist_product FOREIGN KEY (Product_id) 
        REFERENCES new.Product(Product_id) ON DELETE CASCADE,
    CONSTRAINT unique_wishlist_item UNIQUE (Customer_id, Product_id)
);

COMMENT ON TABLE new.Wishlist IS 'Customer wishlist for saved items';
COMMENT ON COLUMN new.Wishlist.added_date IS 'When item was added to wishlist';

-- ============================================
-- 6. Order Table
-- ============================================
CREATE TABLE new."Order" (
    Order_id SERIAL PRIMARY KEY,
    Order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10, 2) NOT NULL CHECK (total_price >= 0),
    customer_id INTEGER NOT NULL,
    payment_id INTEGER,
    shipment_id INTEGER,
    order_status VARCHAR(50) DEFAULT 'Pending',
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) 
        REFERENCES new.Customer(Customer_id) ON DELETE CASCADE
);

COMMENT ON TABLE new."Order" IS 'Customer orders and purchase records';
COMMENT ON COLUMN new."Order".order_status IS 'Current status: Pending, Processing, Shipped, Delivered';

-- ============================================
-- 7. Payment Table
-- ============================================
CREATE TABLE new.Payment (
    Payment_id SERIAL PRIMARY KEY,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0),
    customer_id INTEGER NOT NULL,
    order_id INTEGER UNIQUE,
    CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) 
        REFERENCES new.Customer(Customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_payment_order FOREIGN KEY (order_id) 
        REFERENCES new."Order"(Order_id) ON DELETE CASCADE
);

COMMENT ON TABLE new.Payment IS 'Payment transactions for orders';
COMMENT ON COLUMN new.Payment.payment_method IS 'Payment type: Credit Card, Debit Card, Cash on Delivery, etc.';

-- ============================================
-- 8. Shipment Table
-- ============================================
CREATE TABLE new.Shipment (
    Shipment_id SERIAL PRIMARY KEY,
    Order_id INTEGER UNIQUE NOT NULL,
    Shipment_date TIMESTAMP,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    tracking_number VARCHAR(100),
    CONSTRAINT fk_shipment_order FOREIGN KEY (Order_id) 
        REFERENCES new."Order"(Order_id) ON DELETE CASCADE
);

COMMENT ON TABLE new.Shipment IS 'Shipping information and delivery tracking';
COMMENT ON COLUMN new.Shipment.tracking_number IS 'Courier tracking number for package';

-- ============================================
-- 9. Order_Item Table
-- ============================================
CREATE TABLE new.Order_Item (
    Order_item_id SERIAL PRIMARY KEY,
    Order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    CONSTRAINT fk_orderitem_order FOREIGN KEY (Order_id) 
        REFERENCES new."Order"(Order_id) ON DELETE CASCADE,
    CONSTRAINT fk_orderitem_product FOREIGN KEY (product_id) 
        REFERENCES new.Product(Product_id) ON DELETE CASCADE
);

COMMENT ON TABLE new.Order_Item IS 'Individual items within each order';
COMMENT ON COLUMN new.Order_Item.price IS 'Price of product at time of purchase';

-- ============================================
-- Add foreign key constraints to Order table
-- (Must be added after Payment and Shipment tables exist)
-- ============================================
ALTER TABLE new."Order" 
    ADD CONSTRAINT fk_order_payment 
    FOREIGN KEY (payment_id) REFERENCES new.Payment(Payment_id) ON DELETE SET NULL;

ALTER TABLE new."Order" 
    ADD CONSTRAINT fk_order_shipment 
    FOREIGN KEY (shipment_id) REFERENCES new.Shipment(Shipment_id) ON DELETE SET NULL;

-- ============================================
-- Create Indexes for Better Performance
-- ============================================
CREATE INDEX idx_customer_email ON new.Customer(email);
CREATE INDEX idx_product_sku ON new.Product(SKU);
CREATE INDEX idx_product_category ON new.Product(category_id);
CREATE INDEX idx_order_customer ON new."Order"(customer_id);
CREATE INDEX idx_order_date ON new."Order"(Order_date);
CREATE INDEX idx_orderitem_order ON new.Order_Item(Order_id);
CREATE INDEX idx_orderitem_product ON new.Order_Item(product_id);
CREATE INDEX idx_cart_customer ON new.Cart(Customer_customer_id);
CREATE INDEX idx_wishlist_customer ON new.Wishlist(Customer_id);
CREATE INDEX idx_payment_order ON new.Payment(order_id);
CREATE INDEX idx_shipment_order ON new.Shipment(Order_id);

-- ============================================
-- Insert Sample Data (Optional)
-- ============================================

-- Sample Categories
INSERT INTO new.Category (name) VALUES 
    ('Electronics'),
    ('Books'),
    ('Clothing'),
    ('Home & Kitchen'),
    ('Sports & Outdoors');

-- Sample Customers
INSERT INTO new.Customer (first_name, last_name, email, password, address, ph_number) VALUES 
    ('John', 'Doe', 'john.doe@email.com', 'hashed_password_1', '123 Main St, New York, NY 10001', '+1234567890'),
    ('Jane', 'Smith', 'jane.smith@email.com', 'hashed_password_2', '456 Oak Ave, Los Angeles, CA 90001', '+1234567891'),
    ('Mike', 'Johnson', 'mike.j@email.com', 'hashed_password_3', '789 Pine Rd, Chicago, IL 60601', '+1234567892');

-- Sample Products
INSERT INTO new.Product (SKU, description, price, stock, category_id) VALUES 
    ('ELEC-001', 'Wireless Bluetooth Headphones', 79.99, 150, 1),
    ('ELEC-002', 'Smartphone 128GB', 699.99, 50, 1),
    ('BOOK-001', 'The Great Gatsby - Classic Novel', 12.99, 200, 2),
    ('BOOK-002', 'Database Design Fundamentals', 45.50, 75, 2),
    ('CLOTH-001', 'Cotton T-Shirt - Blue', 19.99, 300, 3),
    ('HOME-001', 'Stainless Steel Water Bottle', 24.99, 120, 4);

-- Sample Cart Items
INSERT INTO new.Cart (Customer_customer_id, product_id, quantity) VALUES 
    (1, 1, 2),
    (1, 3, 1),
    (2, 2, 1);

-- Sample Wishlist Items
INSERT INTO new.Wishlist (Customer_id, Product_id) VALUES 
    (1, 2),
    (1, 4),
    (2, 5),
    (3, 1);

-- Sample Orders
INSERT INTO new."Order" (customer_id, total_price, order_status) VALUES 
    (1, 149.99, 'Delivered'),
    (2, 699.99, 'Shipped'),
    (3, 44.98, 'Processing');

-- Sample Payments
INSERT INTO new.Payment (payment_method, amount, customer_id, order_id) VALUES 
    ('Credit Card', 149.99, 1, 1),
    ('Debit Card', 699.99, 2, 2),
    ('Cash on Delivery', 44.98, 3, 3);

-- Sample Shipments
INSERT INTO new.Shipment (Order_id, address, city, state, country, zip_code, tracking_number) VALUES 
    (1, '123 Main St', 'New York', 'NY', 'USA', '10001', 'TRACK001'),
    (2, '456 Oak Ave', 'Los Angeles', 'CA', 'USA', '90001', 'TRACK002'),
    (3, '789 Pine Rd', 'Chicago', 'IL', 'USA', '60601', 'TRACK003');

-- Update Order table with payment and shipment references
UPDATE new."Order" SET payment_id = 1, shipment_id = 1 WHERE Order_id = 1;
UPDATE new."Order" SET payment_id = 2, shipment_id = 2 WHERE Order_id = 2;
UPDATE new."Order" SET payment_id = 3, shipment_id = 3 WHERE Order_id = 3;

-- Sample Order Items
INSERT INTO new.Order_Item (Order_id, product_id, quantity, price) VALUES 
    (1, 1, 1, 79.99),
    (1, 3, 1, 12.99),
    (2, 2, 1, 699.99),
    (3, 5, 2, 19.99);

-- ============================================
-- Verify Table Creation
-- ============================================
SELECT 
    table_name,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = 'new' AND table_name = t.table_name) as column_count
FROM information_schema.tables t
WHERE table_schema = 'new'
ORDER BY table_name;

-- ============================================
-- Display Relationships
-- ============================================
SELECT
    tc.table_name AS table_name,
    kcu.column_name AS column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_schema = 'new'
ORDER BY tc.table_name, kcu.column_name;

-- ============================================
-- Success Message
-- ============================================
DO $$
BEGIN
    RAISE NOTICE 'Amazon E-Commerce Schema Created Successfully in "new" schema!';
    RAISE NOTICE 'Total Tables: 9';
    RAISE NOTICE 'Schema: new';
    RAISE NOTICE 'You can now view the ER Diagram in pgAdmin4: Right-click on schema "new" > Generate ERD';
END $$;
