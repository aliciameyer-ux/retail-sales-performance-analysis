# Retail Sales Analysis Using SQL

## Project Overview

This project explores the Kaggle Superstore Sales dataset using PostgreSQL. The dataset was cleaned and organised into five related tables before being analysed using SQL.

The project focuses on analysing sales performance, customer behaviour, regional trends, and product performance while applying SQL techniques commonly used in data analysis.

Some of the questions explored include:

* Which product categories and subcategories generate the most sales?
* Which regions perform best?
* Who are the highest-value customers?
* How do sales change over time?
* Are there any noticeable patterns across shipping methods and customer segments?

Built in PostgreSQL using pgAdmin.

## Why This Project

Retail sales data is a common business dataset, making it a good opportunity to practise a complete SQL analysis workflow. The project follows the same approach I would take with a real dataset by exploring the data, cleaning it, validating it, joining tables, and answering business questions.

## SQL Analysis Workflow

1. Explore the data to understand each table.
2. Clean the data by trimming text fields and correcting formatting issues.
3. Validate the data by checking for duplicates, missing values, and invalid records.
4. Join tables to combine customer, product, order, and location information.
5. Analyse sales by category, region, customer segment, and shipping method.
6. Use window functions to rank customers and products and calculate running totals.
7. Analyse monthly and yearly sales trends using time-based functions.

## Skills Demonstrated

* PostgreSQL
* Data cleaning and validation
* Multi-table JOINs
* Aggregate functions
* GROUP BY
* Window functions
* Time-series analysis using `EXTRACT()`
* Ranking functions
* Running totals

## Files in This Repository

* `retail_sales_analysis.sql` - SQL queries covering data exploration, cleaning, validation, joins, aggregation, window functions, and time-based analysis.

## Key Findings

The analysis identified the highest-performing product categories, regions, customer segments, and customers. Window functions were used to rank customers and products by sales, while time-based analysis highlighted monthly and yearly sales trends.

## Data Source

Kaggle Superstore Sales Dataset

https://www.kaggle.com/datasets/rohitsahoo/sales-forecasting
