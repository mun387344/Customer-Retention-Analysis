-- =============================================================================
-- 03_kpi_overview.sql
-- Purpose: Macro Business Performance and High-Level Commercial KPIs
-- =============================================================================

-- Question 1: Overall Commercial Scale (Revenue, Orders, Units Sold, Overall AOV)
SELECT 
    ROUND(SUM(line_total), 2) AS total_revenue,
    COUNT(DISTINCT invoice) AS total_orders,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(line_total) / COUNT(DISTINCT invoice), 2) AS overall_aov
FROM cleaned_retail_sales;


-- Questions 2 & 3: Monthly Revenue, Order Volume, and AOV Dynamics
SELECT 
    DATE_TRUNC('month', invoice_date)::DATE AS sales_month,
    ROUND(SUM(line_total), 2) AS monthly_revenue,
    COUNT(DISTINCT invoice) AS monthly_orders,
    SUM(quantity) AS monthly_units_sold,
    ROUND(SUM(line_total) / COUNT(DISTINCT invoice), 2) AS monthly_aov
FROM cleaned_retail_sales
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY sales_month ASC;


-- Question 4: Top Geographic Markets by Revenue and Order Contribution
SELECT 
    country,
    COUNT(DISTINCT invoice) AS order_count,
    ROUND(SUM(line_total), 2) AS total_revenue,
    ROUND(SUM(line_total) * 100.0 / SUM(SUM(line_total)) OVER (), 2) AS revenue_pct
FROM cleaned_retail_sales
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;