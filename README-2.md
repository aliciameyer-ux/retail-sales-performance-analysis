# Retail Sales Performance Analysis

## Executive Summary

This project analyses retail sales performance for a Superstore-style business using PostgreSQL, working from the Kaggle Superstore Sales dataset. I cleaned and validated raw data across five related tables, then used SQL to identify which categories, regions, segments, and customers were driving revenue, and how sales trended over time.

The analysis found that **Technology is the top-performing category** ($825,529 in sales), the **West region leads all regions** ($2.12M in sales), and total sales grew by roughly **50% between 2015 and 2018**. Based on these findings, I recommend the business:

1. Prioritise inventory and marketing investment in Technology and the West region
2. Build retention strategies around high-value customers and the Home Office segment
3. Plan ahead for the November sales peak, the strongest month in the dataset

## Business Problem

Retail businesses generate large volumes of transactional data, but without structured analysis it's hard to know where revenue is actually coming from and where the opportunities are. This project answers a set of core business questions a retail or product team would realistically ask:

- Which product categories and subcategories generate the most sales?
- Which regions perform best?
- Who are the highest-value customers?
- How do sales change over time?
- Are there patterns across shipping methods and customer segments?

## Methodology

1. **Explore** the data to understand each table's structure and content.
2. **Clean** the data by trimming whitespace from text fields and rounding currency values.
3. **Validate** the data by checking for duplicates, missing values, invalid records, and orphaned foreign keys.
4. **Join** five tables (orders, order items, customers, products, geography) to build a complete view of each transaction.
5. **Aggregate** sales by category, region, customer segment, and shipping method.
6. **Rank and calculate running totals** using window functions to identify top performers.
7. **Analyse trends** over time using date-based functions to spot seasonality and year-over-year growth.

Built in PostgreSQL using pgAdmin.

## Skills Demonstrated

**SQL:** multi-table JOINs, CTEs, aggregate functions, GROUP BY, data cleaning and validation

**Window Functions:** RANK(), LAG(), running totals, partitioned rankings

**Time-Series Analysis:** EXTRACT(), year-over-year and month-over-month comparisons

## Results & Business Recommendation

The analysis surfaced clear, actionable patterns in the data:

![Sales Dashboard](images/sales_dashboard.png)

- **Technology** is the top-performing category by sales, at **$825,529.02**
- **The West region** outperforms all others, generating **$2,122,657.58** in total sales
- **Sean Miller** (Home Office segment) is the highest-value customer at **$25,043.07**, followed by Tamara Chand, Raymond Buch, Tom Ashbrook, and Adrian Barton
- Total sales grew from **$479,330.75 in 2015 to $721,351.26 in 2018**, a roughly **50% increase** over four years, including a **20% jump between 2017 and 2018 alone**
- **November** is the strongest month for sales across all years, at **$350,161.74**, pointing to a clear seasonal peak

Based on these findings, I'd recommend the business:

1. **Double down on Technology and the West region** with focused inventory planning and marketing spend, since these are the biggest proven revenue drivers.
2. **Build a retention programme around top customers and the Home Office segment**, since a small number of customers are contributing disproportionately to revenue.
3. **Prepare for the November peak** ahead of time, with stock levels, staffing, and campaigns planned around the seasonal spike rather than reacting to it.
4. **Investigate the weaker-performing regions and categories** to understand whether the gap is driven by demand, pricing, or distribution, and whether it's worth closing.

## Next Steps

1. Build a Power BI or Tableau dashboard on top of this analysis for ongoing self-serve reporting.
2. Segment the year-over-year growth further to see whether it's driven by more customers, larger orders, or both.
3. Run a cohort analysis on top customers to understand retention and repeat purchase behaviour.

## Files in This Repository

- `retail_sales_analysis.sql` — SQL queries covering data exploration, cleaning, validation, joins, aggregation, window functions, and time-based analysis.

## Data Source

[Kaggle Superstore Sales Dataset](https://www.kaggle.com/datasets/rohitsahoo/sales-forecasting)
