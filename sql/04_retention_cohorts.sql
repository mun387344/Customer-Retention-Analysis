-- =============================================================================
-- 04_retention_cohorts.sql
-- Purpose: Cohort Analysis, Longitudinal Retention Rates, and Customer Lifecycles
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Questions 5 & 6: Customer Base and Overall Repeat Purchase Rate
-- -----------------------------------------------------------------------------
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


-- -----------------------------------------------------------------------------
-- Question 7: Monthly Customer Acquisition Volume
-- Finding the month of each customer's first order and counting new acquisitions per month.
-- -----------------------------------------------------------------------------
WITH customer_first_order AS (
    SELECT 
        customer_id,
        DATE_TRUNC('month', MIN(invoice_date))::DATE AS cohort_month
    FROM cleaned_retail_sales
    GROUP BY customer_id
)
SELECT 
    cohort_month,
    COUNT(customer_id) AS new_customers_acquired
FROM customer_first_order
GROUP BY cohort_month
ORDER BY cohort_month ASC;
