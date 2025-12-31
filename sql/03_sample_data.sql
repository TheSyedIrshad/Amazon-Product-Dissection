-- ======================================================
-- File: 03_sample_data.sql
-- Project: Amazon-Style E-Commerce Analytics
-- Purpose: Insert realistic sample data for analysis
-- ======================================================

-- 1. Insert Categories (6 rows)

INSERT INTO categories (category_name) VALUES
('Electronics'),
('Books'),
('Home & Kitchen'),
('Clothing'),
('Sports'),
('Health');

-- 2. Insert Customers (20 rows)

INSERT INTO customers (first_name, last_name, email, signup_date) VALUES
('John','Doe','john.doe@email.com','2023-01-10'),
('Jane','Smith','jane.smith@email.com','2023-01-12'),
('Amit','Sharma','amit.sharma@email.com','2023-01-15'),
('Priya','Verma','priya.verma@email.com','2023-01-18'),
('Rahul','Mehta','rahul.mehta@email.com','2023-01-20'),
('Neha','Kapoor','neha.k@email.com','2023-01-25'),
('Arjun','Singh','arjun.s@email.com','2023-02-01'),
('Karan','Malhotra','karan.m@email.com','2023-02-05'),
('Pooja','Nair','pooja.n@email.com','2023-02-08'),
('Rohit','Patel','rohit.p@email.com','2023-02-10'),
('Sneha','Iyer','sneha.i@email.com','2023-02-12'),
('Vikram','Joshi','vikram.j@email.com','2023-02-15'),
('Ananya','Gupta','ananya.g@email.com','2023-02-18'),
('Suresh','Rao','suresh.r@email.com','2023-02-20'),
('Mehul','Jain','mehul.j@email.com','2023-02-22'),
('Nikita','Bansal','nikita.b@email.com','2023-02-25'),
('Deepak','Yadav','deepak.y@email.com','2023-03-01'),
('Riya','Chopra','riya.c@email.com','2023-03-03'),
('Manish','Agarwal','manish.a@email.com','2023-03-05'),
('Kavya','Menon','kavya.m@email.com','2023-03-07');

-- 3. Insert Products (20 rows)

INSERT INTO products (product_name, category_id, price) VALUES
('Wireless Mouse',1,25.99),
('Bluetooth Headphones',1,79.99),
('Smartphone Charger',1,19.99),
('Laptop Stand',1,39.99),

('Fiction Novel',2,14.99),
('Business Strategy Book',2,24.99),
('SQL Fundamentals',2,29.99),
('Notebook',2,6.99),

('Cookware Set',3,89.99),
('Vacuum Cleaner',3,129.99),
('Table Lamp',3,34.99),
('Water Bottle',3,12.99),

('Men T-Shirt',4,15.99),
('Women Jeans',4,49.99),
('Jacket',4,89.99),
('Sneakers',4,69.99),

('Yoga Mat',5,24.99),
('Dumbbells',5,59.99),
('Football',5,29.99),
('Running Shoes',5,99.99);

-- 4 Insert Orders (30 rows)

INSERT INTO orders (customer_id, order_date, order_status) VALUES
(1,'2023-03-01 10:15','Completed'),
(2,'2023-03-02 11:20','Completed'),
(3,'2023-03-03 12:30','Completed'),
(1,'2023-03-10 09:45','Completed'),
(4,'2023-03-11 14:10','Completed'),
(5,'2023-03-12 16:00','Completed'),
(2,'2023-03-15 18:25','Completed'),
(6,'2023-03-16 13:40','Completed'),
(7,'2023-03-18 10:05','Completed'),
(8,'2023-03-19 17:30','Completed'),

(1,'2023-03-20 19:15','Completed'),
(9,'2023-03-21 11:00','Completed'),
(10,'2023-03-22 12:30','Completed'),
(11,'2023-03-23 09:50','Completed'),
(12,'2023-03-24 15:20','Completed'),
(13,'2023-03-25 16:45','Completed'),
(14,'2023-03-26 14:00','Completed'),
(15,'2023-03-27 18:10','Completed'),
(16,'2023-03-28 19:40','Completed'),
(17,'2023-03-29 20:15','Completed'),

(18,'2023-03-30 10:10','Completed'),
(19,'2023-03-31 11:25','Completed'),
(20,'2023-04-01 12:55','Completed'),
(3,'2023-04-02 13:15','Completed'),
(4,'2023-04-03 14:35','Completed'),
(5,'2023-04-04 15:45','Completed'),
(6,'2023-04-05 16:50','Completed'),
(7,'2023-04-06 17:30','Completed'),
(8,'2023-04-07 18:20','Completed'),
(9,'2023-04-08 19:10','Completed');

-- 5. (≈48 rows)

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1,1,1,25.99),(1,5,2,14.99),
(2,2,1,79.99),(2,8,3,6.99),
(3,3,2,19.99),
(4,4,1,39.99),(4,6,1,24.99),
(5,9,1,89.99),(5,12,2,12.99),
(6,13,2,15.99),
(7,14,1,49.99),(7,18,1,59.99),
(8,15,1,89.99),
(9,16,1,69.99),
(10,17,1,24.99),
(11,19,1,29.99),
(12,20,1,99.99),

(13,7,1,29.99),
(14,10,1,129.99),
(15,11,2,34.99),
(16,1,1,25.99),
(17,2,1,79.99),
(18,3,2,19.99),
(19,4,1,39.99),
(20,5,1,14.99),
(21,6,1,24.99),
(22,8,2,6.99),
(23,9,1,89.99),
(24,12,3,12.99),
(25,13,1,15.99),
(26,14,2,49.99),
(27,18,1,59.99),
(28,17,1,24.99),
(29,19,1,29.99),
(30,20,1,99.99);

-- 6. Insert Payments (30 rows)

INSERT INTO payments (order_id, payment_date, payment_method, payment_status, amount)
SELECT
    o.order_id,
    o.order_date,
    CASE WHEN o.order_id % 2 = 0 THEN 'Credit Card' ELSE 'UPI' END,
    'Success',
    SUM(oi.quantity * oi.unit_price)
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date;


-- Final Sanity Checks

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM payments;


