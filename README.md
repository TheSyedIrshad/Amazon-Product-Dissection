# SQL Data Modeling & Product Dissection

*(🛒 Amazon Case Study)*

## 📌 Project Overview

This project focuses on **relational data modeling and SQL-based analysis** using an Amazon-inspired e-commerce system as a case study. The objective is to design, understand, and query a normalized database schema that supports core business operations such as customer orders, payments, shipments, and product management.

The project emphasizes **how data is structured**, **how relationships are defined**, and **how SQL is used to extract meaningful insights** from a relational database.

---

## 🧩 Problem Statement

E-commerce platforms like Amazon operate on complex relational databases where customer activity, orders, payments, shipments, and products are distributed across multiple tables. Without a well-designed schema and efficient SQL queries, it becomes difficult to answer critical business questions related to customer behavior, order performance, and operational workflows.

This project aims to dissect an e-commerce product database, design its relational structure, and use SQL queries to retrieve and analyze business-relevant information.

---

## 🎯 Objectives

* Design and understand a **normalized relational database schema**
* Define **primary and foreign key relationships**
* Write SQL queries involving:

  * Multi-table joins
  * Aggregations and filtering
  * Business-focused data extraction
* Demonstrate how SQL supports real-world product and analytics use cases

---

## 🗂️ Database Schema Overview

The database schema represents a simplified e-commerce system with entities such as:

* Customers
* Orders and Order Items
* Products and Categories
* Payments
* Shipments
* Cart and Wishlist

An **Entity Relationship (ER) diagram** is included to visually represent table relationships and data flow across the system.

---

## 🧠 SQL Approach

The SQL implementation demonstrates:

* Table relationships using **primary and foreign keys**
* Joins across multiple entities (customers, orders, products, payments)
* Aggregation queries for totals, counts, and summaries
* Query logic aligned with common e-commerce business questions

All SQL logic is documented and organized in a single script for clarity and reproducibility.

---

## 📄 Project Files

```
├── Amazon_Product_Dissection.pdf        # Detailed project explanation & analysis
├── Product Dissection Amazon.sql        # SQL queries and database logic
├── er_diagram.png                       # Entity Relationship (ER) diagram
└── README.md
```

---

## 📈 Example Business Questions Addressed

* How many orders has each customer placed?
* What is the total revenue generated per order or customer?
* How do orders, payments, and shipments relate operationally?
* How does database design support scalable e-commerce workflows?

---

## 🛠 Tools & Technologies

* SQL (relational querying and joins)
* Database design & normalization concepts
* ER modeling
---

## 🚀 How to Use This Project

1. Review the ER diagram to understand table relationships
2. Read the PDF for detailed explanation and business context
3. Execute the SQL script in a relational database environment
4. Modify queries to explore additional analytical questions

---

## 📌 Notes

This project focuses on **data modeling clarity and SQL reasoning** rather than large-scale data volume. It demonstrates how well-structured relational databases enable efficient analytics and support real-world product and business operations.

---

## 👤 Contributor

* **Syed Irshad** – Database design, SQL analysis, data modeling, and documentation

