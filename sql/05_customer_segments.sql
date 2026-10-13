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
