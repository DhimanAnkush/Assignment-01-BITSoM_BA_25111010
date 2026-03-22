## ETL Decisions

**Decision 1** — Category Casing Standardization
Problem: The raw data contained inconsistent casing for categories (e.g., 'electronics', 'ELECTRONICS', and 'Electronics'). This would cause duplicate groupings in BI reports.
Resolution: During the transformation phase, a UPPER(LEFT(category, 1)) + LOWER(SUBSTRING(category, 2)) logic (or Python .title()) was applied to ensure all categories were loaded into dim_product in Proper Case format.

**Decision 2** — Date Format Harmonization
Problem: The transaction_date column used mixed formats (some rows as MM/DD/YYYY, others as YYYY-MM-DD).
Resolution: I used a standard parsing function (pd.to_datetime in Python) to force all strings into a unified ISO 8601 date object before extracting components for the dim_date table, ensuring the date_key (YYYYMMDD) remained an integer for high-performance joins.

**Decision 3** — Handling NULL Measures
Problem: Several rows in the raw data had NULL values for quantity or unit_price, which would break mathematical aggregations.
Resolution: Rather than dropping the rows (which loses transaction history), I implemented an imputation strategy where NULL prices were filled using the Mode price for that specific product_id from the existing catalog, and NULL quantities were defaulted to 1 (the minimum possible transaction).
