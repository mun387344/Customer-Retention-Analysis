-- =============================================================================
-- 05_customer_segments.sql
-- Purpose: Customer Value Segments, Pareto Distribution, and Product Behavior
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Questions 11 & 12: Revenue Concentration and Frequency Disparity
-- Compares customer share, revenue contribution, spend, and order frequency 
-- between One-Time Buyers and Repeat Buyers.
-- -----------------------------------------------------------------------------
WITH customer_aggregates AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT invoice) AS total_orders,
        SUM(line_total) AS total_spend
    FROM cleaned_retail_sales
    GROUP BY customer_id
),
customer_classification AS (
    SELECT 
        customer_id,
        total_orders,
        total_spend,
        CASE 
            WHEN total_orders = 1 THEN 'One-Time Buyer'
            ELSE 'Repeat Buyer'
        END AS buyer_type
    FROM customer_aggregates
)
SELECT 
    buyer_type,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS customer_pct,
    ROUND(SUM(total_spend), 2) AS total_revenue,
    ROUND(SUM(total_spend) * 100.0 / SUM(SUM(total_spend)) OVER (), 2) AS revenue_pct,
    ROUND(AVG(total_spend), 2) AS avg_spend_per_customer,
    ROUND(AVG(total_orders), 1) AS avg_orders_per_customer
FROM customer_classification
GROUP BY buyer_type
ORDER BY total_revenue DESC;

-- -----------------------------------------------------------------------------
-- Question 13: Customer Value Deciles (Pareto / Top Spender Analysis)
-- Splits customer base into 10 equal tiers based on cumulative lifetime spend.
-- Decile 10 = Top 10% highest spenders.
-- -----------------------------------------------------------------------------
WITH customer_lifetime_spend AS (
    SELECT 
        customer_id,
        SUM(line_total) AS lifetime_spend
    FROM cleaned_retail_sales
    GROUP BY customer_id
),
customer_deciles AS (
    SELECT 
        customer_id,
        lifetime_spend,
        NTILE(10) OVER (ORDER BY lifetime_spend ASC) AS spend_decile
    FROM customer_lifetime_spend
)
SELECT 
    spend_decile,
    COUNT(*) AS customers_in_tier,
    ROUND(MIN(lifetime_spend), 2) AS min_tier_spend,
    ROUND(MAX(lifetime_spend), 2) AS max_tier_spend,
    ROUND(SUM(lifetime_spend), 2) AS tier_revenue,
    ROUND(SUM(lifetime_spend) * 100.0 / SUM(SUM(lifetime_spend)) OVER (), 2) AS tier_revenue_pct
FROM customer_deciles
GROUP BY spend_decile
ORDER BY spend_decile DESC;

-- -----------------------------------------------------------------------------
-- Question 14: Products Driving Initial Acquisition vs. Repeat Orders
-- Compares top 5 items ordered on a customer's 1st order vs. subsequent orders
-- -----------------------------------------------------------------------------
WITH invoice_order_rank AS (
    SELECT 
        customer_id,
        invoice,
        DENSE_RANK() OVER (
            PARTITION BY customer_id 
            ORDER BY invoice_date ASC
        ) AS order_number
    FROM cleaned_retail_sales
    GROUP BY customer_id, invoice, invoice_date
),
line_items_tagged AS (
    SELECT 
        s.description,
        s.quantity,
        CASE 
            WHEN r.order_number = 1 THEN 'First Order (Acquisition)'
            ELSE 'Repeat Order (Retention)'
        END AS order_stage
    FROM cleaned_retail_sales s
    JOIN invoice_order_rank r
      ON s.customer_id = r.customer_id 
     AND s.invoice = r.invoice
),
item_rankings AS (
    SELECT 
        order_stage,
        description,
        SUM(quantity) AS units_sold,
        DENSE_RANK() OVER (
            PARTITION BY order_stage 
            ORDER BY SUM(quantity) DESC
        ) AS item_rank
    FROM line_items_tagged
    GROUP BY order_stage, description
)
SELECT *
FROM item_rankings
WHERE item_rank <= 5
ORDER BY order_stage, item_rank;