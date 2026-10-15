# Executive Summary: Customer Retention & Revenue Concentration Analysis
**Dataset:** Online Retail II (UCI Machine Learning Repository)  
**Scope:** 779,407 validated transactions across 5,878 identifiable customers (Dec 2009 – Dec 2011)  
**Tools:** PostgreSQL, Python (pandas, seaborn), Tableau Public, Git  

---

## 1. Executive Performance Overview

Between December 2009 and December 2011, the enterprise generated **£17,374,804.25** in gross revenue across **36,969** distinct orders and **10,513,934** units sold, maintaining an overall Average Order Value (AOV) of **£469.98**.

The commercial engine is characterized by extreme revenue concentration and strong seasonal wholesale purchasing behavior:
* **The Retention Multiplier:** Repeat buyers represent **72.39%** of the customer base (4,255 customers) but generate **96.78% of total revenue** (£16.81M). 
* **Spend Disparity:** A repeat customer spends an average of **£3,951.71** over **8.3 orders**, compared to just **£345.21** across **1.0 order** for a one-time buyer (an **11.4x lifetime value premium**).
* **Pareto Concentration:** The top 10% highest-spending accounts (Decile 10: 587 customers) generate **63.90%** of total commercial revenue (£11.10M). The top 20% generate **77.22%**, aligning with the classic Pareto distribution.

---

## 2. Key Empirical Findings

### A. Repurchase Cadence & Purchase Intervals
* **Median Cadence:** 50% of returning customers place their subsequent order within **25.0 days** (~3.5 weeks).
* **Mean Cadence:** The average repurchase interval is **51.7 days**, skewed by returning seasonal accounts.
* **Strategic Takeaway:** Replenishment campaigns must trigger within a 20-to-30 day window post-purchase before momentum degrades.

### B. Longitudinal Cohort Retention & Seasonal Spikes
* **Initial Month-1 Drop:** All cohorts experience an immediate drop from 100% to between **18% and 35%** in Month 1.
* **Wholesale Floor Stability:** After Month 1, retention rates stabilize between **15% and 25%** for up to 18–24 months rather than decaying to zero.
* **Q4 Holiday Surge:** Diagonal matrix analysis reveals substantial re-engagement in November of each year (e.g., the December 2009 cohort jumps back to **49.53%** retention in Month 11). B2B wholesale buyers pre-stock inventory before consumer holiday demand peaks.
* **Holiday Acquisition Degradation:** Customers acquired in December 2010 exhibited lower subsequent retention (rarely exceeding 10%), indicating that December acquisitions consist largely of one-off holiday shoppers rather than recurring trade clients.

### C. Geographic Market Structure
* **Domestic Dominance:** The United Kingdom accounts for **82.82%** of company revenue (£14,389,235) across 33,541 orders.
* **Export Hubs:** The top four international destinations are Ireland/EIRE (3.55%), Netherlands (3.19%), Germany (2.45%), and France (2.01%). 

### D. Product Acquisition Gateways vs. Retention Drivers
* **Acquisition Gateways (Order #1):** Driven by accessible giftware (`WHITE HANGING HEART T-LIGHT HOLDER` – 14,086 units; `WORLD WAR 2 GLIDERS` – 13,719 units).
* **Retention Drivers (Order #2+):** Dominated by high-volume restocking goods (`WORLD WAR 2 GLIDERS` surges to 91,515 units; `PAPER CRAFT, LITTLE BIRDIE` reaches 80,995 units).

---

## 3. Strategic Business Recommendations

### 1. High-Value Account Management (VIP Tiering)
* **Rationale:** Decile 10 generates nearly two-thirds (63.90%) of revenue. Losing a single account in this tier carries substantial commercial impact.
* **Action:** Establish a dedicated wholesale account management team for the 587 top-tier buyers with negotiated volume pricing, priority shipping, and automated reorder alerts.

### 2. Time-Bound Post-Purchase Automation
* **Rationale:** Half of returning buyers repurchase within 25 days.
* **Action:** Deploy automated post-purchase email workflows at **Day 18 to Day 22** featuring top retention drivers (`WORLD WAR 2 GLIDERS`, packaging, craft supplies) to capture the natural re-order window.

### 3. Dormancy Intervention at Day 90
* **Rationale:** 49.15% of customers are Active ($\le 90$ days), but 10.05% sit in the critical Dormant transition window (91–180 days) before permanently lapsing (40.80%).
* **Action:** Launch an automated win-back campaign at Day 90 offering tiered restocking incentives before accounts cross the 180-day threshold.

### 4. Separate Holiday Acquisition from Year-Round Marketing
* **Rationale:** December acquisitions have historically poor retention (under 10%).
* **Action:** Avoid over-investing acquisition marketing budgets on seasonal one-off buyers in December. Shift acquisition ad spend to August–September to onboard trade accounts ahead of the November restocking rush.