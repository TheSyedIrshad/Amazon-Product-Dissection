-- Q1: Total revenue and revenue by category

SELECT
    c.category_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;

-- Q2: Monthly revenue trend

SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month;

-- Q3: Repeat customers and their order counts

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- Q4: Top customers by total spend

WITH customer_spend AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_spend
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(cs.total_spend, 2) AS total_spend
FROM customer_spend cs
JOIN customers c
    ON cs.customer_id = c.customer_id
ORDER BY total_spend DESC
LIMIT 10;


-- Q5: Rank customers by spend and compute cumulative revenue contribution

WITH customer_spend AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_spend
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
),
ranked_customers AS (
    SELECT
        customer_id,
        total_spend,
        RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
        SUM(total_spend) OVER (
            ORDER BY total_spend DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue
    FROM customer_spend
)
SELECT
    rc.customer_id,
    c.first_name,
    c.last_name,
    ROUND(rc.total_spend, 2) AS total_spend,
    rc.spend_rank,
    ROUND(rc.cumulative_revenue, 2) AS cumulative_revenue
FROM ranked_customers rc
JOIN customers c
    ON rc.customer_id = c.customer_id
ORDER BY rc.spend_rank;

-- Q6: Average Order Value (AOV)

WITH order_revenue AS (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id
)
SELECT
    ROUND(AVG(order_total), 2) AS average_order_value
FROM order_revenue;

-- Q7: Top products by revenue with ranking

WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
)
SELECT
    product_id,
    product_name,
    ROUND(total_revenue, 2) AS total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM product_revenue
ORDER BY revenue_rank
LIMIT 10;


-- Q8: Payment method usage and revenue contribution

SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_revenue,
    ROUND(
        SUM(amount) * 100.0 / SUM(SUM(amount)) OVER (),
        2
    ) AS revenue_percentage
FROM payments
WHERE payment_status = 'Success'
GROUP BY payment_method
ORDER BY total_revenue DESC;




