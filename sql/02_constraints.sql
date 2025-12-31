-- ======================================================
-- File: 02_constraints.sql
-- Project: Amazon-Style E-Commerce Analytics
-- Purpose: Add relationships and data integrity constraints
-- ======================================================

/* 1. Customer ↔ Orders relationship*/

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

/* 2. Category ↔ Products relationship*/

ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (category_id)
REFERENCES categories(category_id);

/* 3. Orders ↔ Order Items relationship*/

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

/* 4. Products ↔ Order Items relationship*/

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);


/* 5. Orders ↔ Payments relationship*/

ALTER TABLE payments
ADD CONSTRAINT fk_payments_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

/* Data Quality Check*/

ALTER TABLE order_items
ADD CONSTRAINT chk_order_items_quantity
CHECK (quantity > 0);

/* Price and Amount must be non negative*/

ALTER TABLE order_items
ADD CONSTRAINT chk_order_items_unit_price
CHECK (unit_price >= 0);

ALTER TABLE payments
ADD CONSTRAINT chk_payments_amount
CHECK (amount >= 0);


--

ALTER TABLE customers
ADD CONSTRAINT uq_customers_email UNIQUE (email);

-- Validate constraints

SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type
FROM information_schema.table_constraints tc
WHERE tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name;


