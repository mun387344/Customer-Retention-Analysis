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

-- -----------------------------------------------------------------------------
-- Question 8: Cohort Retention Activity (Cohort Month vs. Cohort Index)
-- Calculates the number of unique active customers returning in each subsequent month
-- -----------------------------------------------------------------------------
WITH customer_cohort AS (
    -- Step A: Find the first purchase month for each customer
    SELECT 
        customer_id,
        DATE_TRUNC('month', MIN(invoice_date))::DATE AS cohort_month
    FROM cleaned_retail_sales
    GROUP BY customer_id
),
customer_activities AS (
    -- Step B: Pair every invoice with the customer's cohort month
    SELECT DISTINCT
        s.customer_id,
        c.cohort_month,
        DATE_TRUNC('month', s.invoice_date)::DATE AS purchase_month
    FROM cleaned_retail_sales s
    JOIN customer_cohort c 
      ON s.customer_id = c.customer_id
),
cohort_indexed AS (
    -- Step C: Calculate the month difference (cohort_index)
    SELECT 
        customer_id,
        cohort_month,
        purchase_month,
        (EXTRACT(YEAR FROM purchase_month) - EXTRACT(YEAR FROM cohort_month)) * 12 +
        (EXTRACT(MONTH FROM purchase_month) - EXTRACT(MONTH FROM cohort_month)) AS cohort_index
    FROM customer_activities
)
-- Step D: Aggregate unique customers active in each cohort_index
SELECT 
    cohort_month,
    cohort_index,
    COUNT(DISTINCT customer_id) AS active_customers
FROM cohort_indexed
GROUP BY cohort_month, cohort_index
ORDER BY cohort_month ASC, cohort_index ASC;

-- -----------------------------------------------------------------------------
-- Question 9: Repurchase Cadence (Days Between Orders)
-- -----------------------------------------------------------------------------
WITH customer_orders_dated AS (
    -- Get distinct order dates per customer
    SELECT DISTINCT
        customer_id,
        invoice,
        invoice_date::DATE AS order_date
    FROM cleaned_retail_sales
),
order_intervals AS (
    -- Calculate days since previous order
    SELECT 
        customer_id,
        invoice,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id 
            ORDER BY order_date ASC
        ) AS previous_order_date,
        order_date - LAG(order_date) OVER (
            PARTITION BY customer_id 
            ORDER BY order_date ASC
        ) AS days_since_last_order
    FROM customer_orders_dated
)
SELECT 
    COUNT(days_since_last_order) AS total_repurchase_events,
    ROUND(AVG(days_since_last_order), 1) AS avg_days_between_orders,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days_since_last_order) AS median_days_between_orders
FROM order_intervals
WHERE days_since_last_order IS NOT NULL;
