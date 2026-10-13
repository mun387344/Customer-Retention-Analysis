-- =============================================================================
-- 01_data_exploration.sql
-- Purpose: Data validation and exploration for Online Retail II
-- =============================================================================

-- Step 1: Validate Data Ingestion Against Excel Audit Benchmarks
SELECT 
    COUNT(*) AS total_records,
    COUNT(customer_id) AS populated_customer_ids,
    COUNT(*) - COUNT(customer_id) AS blank_customer_ids,
    COUNT(*) FILTER (WHERE invoice LIKE 'C%') AS cancelled_invoices,
    COUNT(*) FILTER (WHERE quantity <= 0) AS non_positive_quantities,
    COUNT(*) FILTER (WHERE price <= 0) AS non_positive_prices
FROM raw_retail;

-- Step 2: Investigate negative quantities that are NOT cancellations
SELECT 
    stock_code,
    description,
    quantity,
    price,
    customer_id,
    COUNT(*) AS row_count
FROM raw_retail
WHERE quantity <= 0 
  AND invoice NOT LIKE 'C%'
GROUP BY stock_code, description, quantity, price, customer_id
ORDER BY row_count DESC
LIMIT 10;

-- Step 3: Investigate zero and negative prices
SELECT 
    description,
    price,
    COUNT(*) AS row_count,
    COUNT(customer_id) AS populated_customer_count
FROM raw_retail
WHERE price <= 0
GROUP BY description, price
ORDER BY row_count DESC
LIMIT 10;

-- Step 4: Check for exact duplicate rows
SELECT 
    invoice, stock_code, description, quantity, invoice_date, price, customer_id, country,
    COUNT(*) AS occurrence_count
FROM raw_retail
GROUP BY invoice, stock_code, description, quantity, invoice_date, price, customer_id, country
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC
LIMIT 10;

-- Step 5: Total count of duplicate rows (extra copies beyond the first)
WITH duplicate_summary AS (
    SELECT 
        COUNT(*) - 1 AS extra_copies
    FROM raw_retail
    GROUP BY invoice, stock_code, description, quantity, invoice_date, price, customer_id, country
    HAVING COUNT(*) > 1
)
SELECT SUM(extra_copies) AS total_duplicate_records
FROM duplicate_summary;

-- Step 6: Inspect Customer ID formats and check for floating decimals or non-digits
SELECT 
    customer_id,
    COUNT(*) AS record_count
FROM raw_retail
WHERE customer_id IS NOT NULL
  AND customer_id NOT SIMILAR TO '[0-9]+'
GROUP BY customer_id
LIMIT 10;

