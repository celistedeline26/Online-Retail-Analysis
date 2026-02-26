CREATE TABLE online_retail_raw (
    invoiceno TEXT,
    stockcode TEXT,
    description TEXT,
    quantity TEXT,
    invoicedate TEXT,
    unitprice TEXT,
    customerid TEXT,
    country TEXT
);
SELECT count(*) FROM online_retail_raw;

SELECT * 
FROM online_retail_raw
LIMIT 10;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'online_retail_raw';

SELECT 
    COUNT(*) AS total_rows,
    COUNT(invoiceno) AS invoiceno_not_null,
    COUNT(customerid) AS customerid_not_null
FROM online_retail_raw;

SELECT *
FROM online_retail_raw
WHERE customerid IS NULL;

SELECT *
FROM online_retail_raw
WHERE invoiceno LIKE 'C%';

--(Technical) NULL customer IDs were removed to ensure data integrity for grouping and customer-based analysis.
--(Business) Removing NULL customer IDs ensures accurate insights into customer behaviour, sales performance, and revenue contribution.
CREATE TABLE online_retail_clean AS
SELECT
    invoiceno,
    stockcode,
    description,
    CAST(quantity AS INTEGER) AS quantity,
    CAST(unitprice AS NUMERIC) AS unitprice,
    CAST(invoicedate AS TIMESTAMP) AS invoicedate,
    CAST(customerid AS INTEGER) AS customerid,
    country
FROM online_retail_raw
WHERE customerid IS NOT NULL;

--Check for duplicate transactions
--No evidence of exact duplicate records
SELECT 
    invoiceno,
    stockcode,
    quantity,
    unitprice,
    COUNT(*)
FROM online_retail_clean
GROUP BY 
    invoiceno,
    stockcode,
    quantity,
    unitprice
HAVING COUNT(*) > 1;

DELETE FROM online_retail_clean
WHERE ctid IN (
    SELECT ctid
    FROM (
        SELECT 
            ctid,
            ROW_NUMBER() OVER (
                PARTITION BY 
                    invoiceno,
                    stockcode,
                    quantity,
                    unitprice,
                    invoicedate,
                    customerid,
                    country
                ORDER BY ctid
            ) AS rn
        FROM online_retail_clean
    ) t
    WHERE rn > 1
);

SELECT 
    invoiceno,
    stockcode,
    quantity,
    unitprice,
    COUNT(*)
FROM online_retail_clean
GROUP BY 
    invoiceno,
    stockcode,
    quantity,
    unitprice
HAVING COUNT(*) > 1;

SELECT *
FROM online_retail_clean
WHERE invoiceno = '567183'
AND stockcode = '22659';

SELECT 
    invoiceno,
    stockcode,
    quantity,
    unitprice,
    invoicedate,
    customerid,
    country,
    COUNT(*)
FROM online_retail_clean
GROUP BY 
    invoiceno,
    stockcode,
    quantity,
    unitprice,
    invoicedate,
    customerid,
    country
HAVING COUNT(*) > 1;

DROP TABLE online_retail_clean;

--Recreating clean raw data where NULL customer IDs were removed under the same jsutificationas previosuly.
--To ensure proper data handling for duplicates.
CREATE TABLE online_retail_clean AS
SELECT
    invoiceno,
    stockcode,
    description,
    CAST(quantity AS INTEGER) AS quantity,
    CAST(unitprice AS NUMERIC) AS unitprice,
    CAST(invoicedate AS TIMESTAMP) AS invoicedate,
    CAST(customerid AS INTEGER) AS customerid,
    country
FROM online_retail_raw
WHERE customerid IS NOT NULL;

--Check for duplicate transactions
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'online_retail_clean';

SELECT 
    unitprice,
	invoiceno,
	customerid,
	quantity,
	country,
    stockcode,
    description,
	invoicedate,
    COUNT(*)
FROM online_retail_clean
GROUP BY 
    unitprice,
	invoiceno,
	customerid,
	quantity,
	country,
    stockcode,
    description,
	invoicedate
HAVING COUNT(*) > 1;

SELECT *
FROM online_retail_clean
WHERE invoiceno = '536945'
AND stockcode = '21830';

--Create backup to avoid same mistake
CREATE TABLE online_retail_backup AS
SELECT * FROM online_retail_clean;

--Preview of what will be deleted
SELECT *
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                  unitprice,
	              invoiceno,
	              customerid,
	              quantity,
	              country,
                  stockcode,
                  description,
               	  invoicedate
            ORDER BY ctid
        ) AS rn
    FROM online_retail_clean
) t
WHERE rn > 1;

--Deleting the duplicates
DELETE FROM online_retail_clean
WHERE ctid IN (
    SELECT ctid
    FROM (
        SELECT 
            ctid,
            ROW_NUMBER() OVER (
                PARTITION BY 
                    invoiceno,
                    stockcode,
                    quantity,
                    unitprice,
                    invoicedate,
                    customerid,
                    country
                ORDER BY ctid
            ) AS rn
        FROM online_retail_clean
    ) t
    WHERE rn > 1
);

SELECT COUNT(*) FROM online_retail_clean;

SELECT 
    invoiceno,
    stockcode,
    description,
    quantity,
    unitprice,
    invoicedate,
    customerid,
    country,
    COUNT(*)
FROM online_retail_clean
GROUP BY 
    invoiceno,
    stockcode,
    description,
    quantity,
    unitprice,
    invoicedate,
    customerid,
    country
HAVING COUNT(*) > 1;

--Check for missing values
SELECT
    COUNT(*) AS total_rows,
    COUNT(customerid) AS non_null_customerid,
    COUNT(quantity) AS non_null_quantity,
    COUNT(unitprice) AS non_null_unitprice
FROM online_retail_clean;

--Check for negative values
--Negative quantities detected (likely returns). These records are retained to calculate NET revenue, where total sales minus returns provides a realisticmeasure of overall business performance.
--No negative values found in unitprice.
SELECT *
FROM online_retail_clean
WHERE quantity < 0;

SELECT *
FROM online_retail_clean
WHERE unitprice < 0;

--Basic Exploratory Data Analysis
--How many rows?
SELECT COUNT(*) FROM online_retail_clean;
--Data range
SELECT MIN(invoicedate), MAX(invoicedate)
FROM online_retail_clean;
--Total net revenue?
SELECT SUM(quantity * unitprice)
FROM online_retail_clean;
--Number of customers?
SELECT COUNT(DISTINCT customerid)
FROM online_retail_clean;
--Number of countries?
SELECT COUNT(DISTINCT country)
FROM online_retail_clean;

--Deeper/Focused Exploratory Data Analysis
--Revenue distribution
SELECT 
    MIN(quantity * unitprice),
    MAX(quantity * unitprice),
    AVG(quantity * unitprice)
FROM online_retail_clean;
--Top countries by number of distribution
SELECT 
    country,
    COUNT(*) AS total_transactions
FROM online_retail_clean
GROUP BY country
ORDER BY total_transactions DESC;
--Monthly transaction volume
SELECT
    DATE_TRUNC('month', invoicedate) AS month,
    COUNT(*) AS transactions
FROM online_retail_clean
GROUP BY month
ORDER BY month;
--Customer purchase frequency
SELECT
    customerid,
    COUNT(*) AS total_purchases
FROM online_retail_clean
GROUP BY customerid
ORDER BY total_purchases DESC;

--Customer Analysis
--Top 10 customers by net revenue
SELECT
    customerid,
    SUM(quantity * unitprice) AS net_revenue
FROM online_retail_clean
GROUP BY customerid
ORDER BY net_revenue DESC
LIMIT 10;
--Customer frequency
SELECT
    customerid,
    COUNT(*) AS total_transactions
FROM online_retail_clean
GROUP BY customerid
ORDER BY total_transactions DESC
LIMIT 10;

--Sales Trend Analysis
--Monthly net revenue trend
SELECT
    DATE_TRUNC('month', invoicedate) AS month,
    SUM(quantity * unitprice) AS monthly_net_revenue
FROM online_retail_clean
GROUP BY month
ORDER BY month;
--Monthly transaction volume
SELECT
    DATE_TRUNC('month', invoicedate) AS month,
    COUNT(*) AS total_transactions
FROM online_retail_clean
GROUP BY month
ORDER BY month;

--Product Performance
--Top products by revenue
SELECT
    stockcode,
    description,
    SUM(quantity) AS total_units_sold,
    SUM(quantity * unitprice) AS total_net_revenue
FROM online_retail_clean
GROUP BY stockcode, description
ORDER BY total_net_revenue DESC
LIMIT 10;
--Top products by quantity
SELECT
    stockcode,
    description,
    SUM(quantity) AS total_units_sold
FROM online_retail_clean
GROUP BY stockcode, description
ORDER BY total_units_sold DESC
LIMIT 10;

--Country Analysis
--Revenue by country
SELECT
    country,
    SUM(quantity * unitprice) AS total_net_revenue
FROM online_retail_clean
GROUP BY country
ORDER BY total_net_revenue DESC;
--Transaction count by country
SELECT
    country,
    COUNT(*) AS total_transactions
FROM online_retail_clean
GROUP BY country
ORDER BY total_transactions DESC;

--Advanced Customer Revenue Analysis
--Customer ranking 
SELECT
    customerid,
    SUM(quantity * unitprice) AS net_revenue,
    RANK() OVER (
        ORDER BY SUM(quantity * unitprice) DESC
    ) AS revenue_rank
FROM online_retail_clean
GROUP BY customerid
ORDER BY net_revenue DESC;
--Revenue concentration
SELECT
    customerid,
    SUM(quantity * unitprice) AS customer_revenue,
    ROUND(
        SUM(quantity * unitprice) * 100.0 /
        SUM(SUM(quantity * unitprice)) OVER (),
        2
    ) AS revenue_percentage
FROM online_retail_clean
GROUP BY customerid
ORDER BY customer_revenue DESC;
--Top 10 customers by net revenue (filtered view of customer ranking)
SELECT *
FROM (
    SELECT
        customerid,
        SUM(quantity * unitprice) AS net_revenue,
        RANK() OVER (
            ORDER BY SUM(quantity * unitprice) DESC
        ) AS revenue_rank
    FROM online_retail_clean
    GROUP BY customerid
) t
WHERE revenue_rank <= 10
ORDER BY net_revenue DESC;

--Pareto Analysis
--Count cummualtive percentage
WITH customer_revenue AS (
    SELECT
        customerid,
        SUM(quantity * unitprice) AS net_revenue
    FROM online_retail_clean
    GROUP BY customerid
),
ranked AS (
    SELECT
        customerid,
        net_revenue,
        SUM(net_revenue) OVER () AS total_revenue,
        SUM(net_revenue) OVER (ORDER BY net_revenue DESC) AS cumulative_revenue
    FROM customer_revenue
)
SELECT
    customerid,
    net_revenue,
    cumulative_revenue,
    ROUND(cumulative_revenue * 100.0 / total_revenue, 2) AS cumulative_percentage
FROM ranked
ORDER BY net_revenue DESC;
--Count total customers
SELECT COUNT(*) AS total_customers
FROM online_retail_clean;
--Calculate top 20% customers
WITH customer_revenue AS (
    SELECT
        customerid,
        SUM(quantity * unitprice) AS net_revenue
    FROM online_retail_clean
    GROUP BY customerid
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY net_revenue DESC) AS rn,
           COUNT(*) OVER () AS total_customers
    FROM customer_revenue
)
SELECT
    SUM(net_revenue) AS top_20_percent_revenue,
    SUM(net_revenue) * 100.0 /
    (SELECT SUM(quantity * unitprice) FROM online_retail_clean) 
    AS percentage_of_total_revenue
FROM ranked
WHERE rn <= total_customers * 0.2;
--Pareto analysis shows that the top 20% of customers generate 73.8% of total net revenue.