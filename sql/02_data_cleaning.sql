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

-- Step 3: Index customer_id and invoice_date for high-performance cohort modeling
CREATE INDEX idx_cleaned_customer_id ON cleaned_retail_sales(customer_id);
CREATE INDEX idx_cleaned_invoice_date ON cleaned_retail_sales(invoice_date);

--Step 4: Calculate total identifiable customers and repeat purchase rate
WITH customer_order_counts AS (
    SELECT
	     customer_id,
		 COUNT(DISTINCT invoice) AS total_orders
	FROM cleaned_retail_sales
	GROUP BY customer_id
)
SELECT 
    COUNT(*) AS total_unique_customers,
	COUNT(*) FILTER (WHERE total_orders = 1) AS one_time_buyers,
	COUNT(*) FILTER (WHERE total_orders > 1) AS repeat_buyers,
	ROUND(
        COUNT(*) FILTER (WHERE total_orders > 1) * 100.0 / COUNT(*), 2
	) AS repeat_buyer_percentage
FROM customer_order_counts;