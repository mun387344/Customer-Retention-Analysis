-- =============================================================================
-- Script: 01_data_exploration.sql
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