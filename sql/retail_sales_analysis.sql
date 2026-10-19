-- Retail Sales SQL Analysis
-- Database: MySQL
-- Dataset: CSV files in ../datasets
-- IDs are text in the source data (for example, C001, P001, S001, T00001).
-- Keep them as VARCHAR so prefixes and leading zeros are preserved.
-- When importing customers.csv, ignore its trailing empty CSV field if the
-- import wizard detects it as an additional column.

CREATE DATABASE IF NOT EXISTS retail_sales_db;
USE retail_sales_db;

CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    birth_date DATE,
    city VARCHAR(100),
    join_date DATE
);

CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    unit_price DECIMAL(10,2),
    cost_price DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS stores (
    store_id VARCHAR(10) PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(100),
    region VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id VARCHAR(12) PRIMARY KEY,
    transaction_date DATE,
    customer_id VARCHAR(10),
    product_id VARCHAR(10),
    store_id VARCHAR(10),
    quantity INT,
    discount DECIMAL(5,2),
    payment_method VARCHAR(50),
    CONSTRAINT fk_transactions_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_transactions_product
        FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_transactions_store
        FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Analytical view.
-- The source discount is stored as a fraction (for example, 0.10 = 10%).
-- Profit is calculated after discount, before any other operating costs.
CREATE OR REPLACE VIEW sales_master AS
SELECT
    t.transaction_id,
    t.transaction_date,
    YEAR(t.transaction_date) AS year,
    MONTH(t.transaction_date) AS month,
    p.product_name,
    p.category,
    s.region,
    t.quantity,
    p.unit_price,
    p.cost_price,
    t.discount,
    (t.quantity * p.unit_price * (1 - t.discount)) AS revenue,
    (t.quantity * (p.unit_price * (1 - t.discount) - p.cost_price)) AS profit
FROM transactions AS t
JOIN products AS p
    ON t.product_id = p.product_id
JOIN stores AS s
    ON t.store_id = s.store_id;

-- Row counts
SELECT COUNT(*) AS customer_rows FROM customers;
SELECT COUNT(*) AS product_rows FROM products;
SELECT COUNT(*) AS store_rows FROM stores;
SELECT COUNT(*) AS transaction_rows FROM transactions;

-- KPIs
SELECT ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_master;

SELECT COUNT(DISTINCT transaction_id) AS total_transactions
FROM transactions;

SELECT SUM(quantity) AS total_units_sold
FROM transactions;

SELECT ROUND(SUM(profit), 2) AS total_profit
FROM sales_master;

-- Sales by region
SELECT
    region,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_master
GROUP BY region
ORDER BY total_revenue DESC;

-- Sales by product category
SELECT
    category,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_master
GROUP BY category
ORDER BY total_revenue DESC;

-- Monthly sales trend (keep year and month together)
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS sales_month,
    ROUND(SUM(revenue), 2) AS monthly_revenue
FROM sales_master
GROUP BY YEAR(transaction_date), MONTH(transaction_date)
ORDER BY YEAR(transaction_date), MONTH(transaction_date);

-- Top 10 products by discounted revenue
SELECT
    product_name,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_master
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;
