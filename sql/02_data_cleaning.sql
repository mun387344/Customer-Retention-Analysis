-- =============================================================================
-- 02_data_cleaning.sql
-- Purpose: Create cleaned, deduplicated sales table for retention cohort analysis
-- =============================================================================

-- Step 1: Create cleaned retail sales table
DROP TABLE IF EXISTS cleaned_retail_sales;

CREATE TABLE cleaned_retail_sales AS
SELECT DISTINCT
    invoice,
    stock_code,
    description,
    quantity,
    invoice_date,
    price,
    customer_id,
    country,
    (quantity * price) AS line_total
FROM raw_retail
WHERE customer_id IS NOT NULL
  AND price > 0
  AND quantity > 0
  AND invoice NOT LIKE 'C%';

-- Step 2: Verify the count of clean transactions
SELECT COUNT(*) AS total_clean_rows
FROM cleaned_retail_sales;
--Output: cleaned_retail_sales (779,407 records)

-- Step 3: Index customer_id and invoice_date for high-performance cohort modeling
CREATE INDEX idx_cleaned_customer_id ON cleaned_retail_sales(customer_id);
CREATE INDEX idx_cleaned_invoice_date ON cleaned_retail_sales(invoice_date);