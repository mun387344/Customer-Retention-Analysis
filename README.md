# Customer Retention Analysis

**Project status:** In Progress

## Project Overview

This project analyzes customer purchasing behavior for a UK-based online retailer using the Online Retail II dataset from the UCI Machine Learning Repository.

The goal is to understand how customers return to make additional purchases, how retention changes over time, and which customer groups may need further attention.

This project is designed to build practical experience with the tools used in data analytics: **Excel, SQL, Python, and Tableau**.

## Business Objectives

The analysis will investigate the following questions:

- How many identifiable customers made purchases?
- What percentage of customers made repeat purchases?
- How does customer retention change across monthly cohorts?
- Which customer cohorts demonstrate stronger retention?
- How much time typically passes between customer purchases?
- Which previously active customers have not purchased recently?
- How do one-time and repeat customers contribute to revenue?

These questions will be refined as the dataset is explored and its limitations become clearer.

## Dataset

- **Name:** Online Retail II
- **Source:** [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/502/online+retail+ii)
- **Size:** 1,067,371 transaction-line records
- **Coverage:** December 2009 – December 2011
- **Business context:** A UK-based online retailer selling giftware
- **License:** Creative Commons Attribution 4.0 International (CC BY 4.0)

The dataset contains invoice identifiers, product codes, descriptions, quantities, invoice dates, prices, customer identifiers, and countries.

The source data contains data-quality issues, including missing customer identifiers and cancellation transactions. These will be investigated before calculating customer retention metrics.

**Data handling:** The original dataset will be retained as source data. The full raw workbook will not be committed to GitHub.

## Tools and Technologies

| Tool | Planned use |
|---|---|
| Excel | Inspect the workbook, explore records, check data quality, and validate results |
| SQL / PostgreSQL | Explore data, clean records, and calculate customer-level and cohort metrics |
| Python / pandas | Perform data cleaning, exploratory analysis, and customer-retention calculations |
| Python / Matplotlib | Create analytical visualizations |
| Tableau | Build an interactive customer-retention dashboard |
| Git / GitHub | Track project progress, document decisions, and publish the final work |

## Planned Workflow

1. Define the business questions and inspect the source data.
2. Audit data quality, missing values, duplicate records, cancellations, and data types.
3. Clean the data and document the decisions made.
4. Analyze repeat purchases, customer cohorts, and time between purchases.
5. Compare key results across SQL, Python, and Excel where appropriate.
6. Build an interactive Tableau dashboard.
7. Summarize findings, limitations, and actionable business recommendations.
8. Publish the final documentation, dashboard images, and supporting analysis.

## Repository Structure

```text
Customer-Retention-Analysis/
├── README.md
├── data/
│   └── README.md
├── sql/
│   ├── 01_data_exploration.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_retention_analysis.sql
│   └── 04_customer_analysis.sql
├── python/
├── excel/
├── tableau/
├── images/
└── findings/
```

The folder structure and file names may be adjusted as the project develops.

## Important Analytical Considerations

- A transaction-line record is not necessarily a complete order.
- Repeat purchasing will be measured using distinct invoices, not the number of product rows.
- Customers with missing identifiers cannot be reliably included in customer-level retention calculations.
- Cancellation transactions and negative quantities require careful treatment.
- Customers who have not purchased recently will be described as potentially inactive, not automatically classified as permanently lost.
- Retention definitions and analysis periods will be documented before final metrics are reported.

## Current Progress

- [x] Selected the dataset.
- [x] Downloaded the original Excel workbook.
- [x] Reviewed the column names.
- [ ] Completed the data-quality audit.
- [ ] Completed cleaning and validation.
- [ ] Completed SQL and Python analysis.
- [ ] Built the Tableau dashboard.
- [ ] Documented findings and recommendations.

## Dataset Citation

Chen, D. (2012). *Online Retail II* [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5CG6D

## Final Deliverables

The completed project is intended to include reproducible SQL analysis, Python analysis, Excel-based data exploration and validation, a Tableau dashboard, and a written summary of findings and recommendations.
