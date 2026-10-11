# Data Source & Workbook Audit: Online Retail II

## Source Information
- **Dataset:** Online Retail II
- **Repository:** UCI Machine Learning Repository
- **DOI:** https://doi.org/10.24432/C5CG6D
- **Original File:** `online_retail_II.xlsx`

## Worksheet Verification
| Sheet Name | First Invoice Date | Last Invoice Date | Header Row | Last Used Row | Data Rows |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `Year 2009-2010` | 2009-12-01 | 2010-12-09 | Row 1 | 525,461 | 525,460 |
| `Year 2010-2011` | 2010-12-01 | 2011-12-09 | Row 1 | 541,910 | 541,909 |
| **Total** | | | | | **1,067,369** |

## Audit Discrepancy Note
- **Reported UCI Count:** 1,067,371 records
- **Actual Combined Sheet Rows:** 1,067,369 records
- **Discrepancy:** -2 records. This discrepancy will be investigated during database ingestion and validation.

## Column Schema
- `Invoice`: 6-digit transaction number (starts with 'C' if cancelled)
- `StockCode`: 5-digit product code
- `Description`: Product name
- `Quantity`: Quantities per transaction
- `InvoiceDate`: Transaction timestamp
- `Price`: Unit price (GBP)
- `Customer ID`: 5-digit client identifier
- `Country`: Customer residence country
