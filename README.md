# 🛒 Amazon-Style E-Commerce SQL Analytics Project

## 📘 Project Overview

This project is a **schema-first SQL analytics case study** based on an Amazon-style e-commerce platform.

The objective is to demonstrate how a data analyst / analytics engineer:
- translates real business problems into a clean data model
- designs normalized, analytics-ready schemas
- enforces data integrity using constraints
- answers business-critical questions using SQL

The focus is on **correctness, clarity, and business reasoning**, not dataset size or dashboards.

---

## 🧠 Business Context

An e-commerce business fundamentally operates around transactions:

Customer → Product → Order → Payment → Revenue

To support analytics and decision-making, the business must answer questions such as:
- Where does revenue come from?
- How is revenue trending over time?
- Who are repeat and high-value customers?
- Which products and categories drive performance?
- How do payment methods contribute to revenue?

This project models the **core transactional layer** required to answer these questions reliably.

---

## 🏗️ Schema Design (Analytics-First)

The schema follows **fact and dimension modeling principles**, with a strong emphasis on grain clarity.

### Tables Included

**Dimensions**
- `customers` — customer identity and signup information
- `categories` — product groupings
- `products` — product master data

**Facts**
- `orders` — checkout transactions (order-level grain)
- `order_items` — purchased items within orders (**revenue grain**)
- `payments` — financial transactions linked to orders

### Key Design Decisions
- Revenue is calculated at the **order-item level** (`quantity × unit_price`)
- Derived metrics (AOV, revenue totals) are **not stored**
- Foreign keys and constraints are enforced to prevent invalid data
- Each table has a clearly defined grain

An ER diagram and detailed explanations are available in the `docs/` folder.

---

## 🚫 Scope Decisions (Intentional)

The following domains are intentionally excluded:
- Delivery and logistics
- Inventory management
- Customer reviews and ratings

These belong to **operations or engagement analytics** and are typically handled by separate systems in real-world architectures.  
They are excluded by design to maintain focus on **core commerce analytics**.

---

## 📊 Dataset Strategy

The dataset is **small but realistic by design**.

This project prioritizes:
- schema correctness
- analytical logic
- explainability

The same schema and queries would scale directly to large datasets.  
This mirrors real analytics workflows: **design → validate → scale**.

---

## 📈 Analytics Covered

The project answers the following business questions using SQL:

1. Revenue by product category  
2. Monthly revenue trends  
3. Identification of repeat customers  
4. Top customers by total spend  
5. Customer ranking and cumulative revenue contribution (window functions)  
6. Average Order Value (AOV)  
7. Top products by revenue  
8. Payment method usage and revenue contribution  

SQL techniques used:
- multi-table joins with correct grain handling
- CTEs for clarity and modular logic
- window functions where they add analytical value

---

## 🗂️ Project Structure

amazon-ecommerce-sql-analytics/
│
├── README.md
├── sql/
│   ├── 01_schema.sql
│   ├── 02_constraints.sql
│   ├── 03_sample_data.sql
│   └── 04_analytics_queries.sql
├── docs/
│   ├── er_diagram.png
│   └── schema_explanation.md
└── notes/
    └── business_questions.md


▶️ How to Run
Create a PostgreSQL database

Execute SQL files in order:

sql
Copy code
01_schema.sql
02_constraints.sql
03_sample_data.sql
04_analytics_queries.sql
Review query outputs directly in PostgreSQL

🎯 What This Project Demonstrates
Strong SQL fundamentals

Fact vs dimension modeling

Data integrity enforcement

Correct revenue modeling

Business-oriented analytical thinking

This project reflects expectations for data analyst and analytics engineer roles in real companies.

