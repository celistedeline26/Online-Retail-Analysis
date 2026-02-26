# Online Retail SQL Analysis
SQL-based data cleaning, exploratory analysis, and advanced business insights using PostgreSQL.

## 📖 Executive Summary (Storytelling Section)
This project analyses online retail transaction data using PostgreSQL to uncover how revenue is generated and distributed across customers, products, and countries.

After cleaning and preparing the dataset, customer-level revenue patterns were analysed using ranking and window functions. The analysis revealed strong revenue concentration: the top 20% of customers generate approximately 73.8% of total net revenue.

These findings highlight the importance of high-value customer retention and revenue risk monitoring in online retail businesses.

## Project Overview
This project performs data cleaning, exploratory data analysis (EDA), and advanced customer revenue analysis on an online retail transaction dataset using PostgreSQL.
The goal is to understand customer behaviour, sales performance, product trends, country-level revenue distribution, and revenue concentration using net revenue analysis.

## Business Context
- Online retail businesses need to understand:
- Who their most valuable customers are
- Which products generate the most revenue
- How sales change over time
- Which countries contribute most to revenue
- Whether revenue is concentrated among a small group of customers
These insights support strategic decision-making in marketing, customer retention, inventory planning, and business growth.

## Business Questions
- Who are the top revenue-generating customers?
- How is revenue distributed across customers?
- Does the dataset follow the Pareto (80/20) principle?
- What are the monthly sales trends?
- Which products generate the most revenue?
- Which countries contribute most to total revenue?

## Dataset Used
The dataset contains transaction-level records from an online retail store, including:
- Invoice number
- Stock code
- Product description
- Quantity
- Invoice date
- Unit price
- Customer ID
- Country

The analysis is based on net revenue, calculated as:
Net Revenue = Quantity × Unit Price

Returns (negative quantities) were retained to allow realistic financial analysis.

## Data Cleaning & Preparation
The following steps were performed in PostgreSQL:
Imported raw dataset into online_retail_raw
Created a cleaned working table (online_retail_clean)
Converted data types from TEXT to appropriate formats
Checked for missing values
Identified and removed duplicate records
Verified data integrity before analysis
Retained negative quantities for net revenue calculation
These steps ensured accurate aggregation and business analysis.

Customer ID Handling:
Records with NULL customer IDs were excluded from customer-level analysis.
This decision was made because customer ID is required for meaningful customer-based aggregation, ranking, and revenue concentration analysis. Without a valid customer identifier, it is not possible to accurately measure individual customer contribution or perform segmentation analysis.

These steps ensured accurate aggregation and reliable business insights.

## Basic Exploratory Data Analysis (EDA)
Basic EDA was conducted to understand dataset structure and scale:
- How many rows?
- Data range
- Total net revenue?
- Number of customers?
- Number of countries?
This provided an overview of the dataset before performing deeper analysis.

 ## Deeper/Focused Exploratory Data Analysis (EDA)
 More focused exploratory analysis was conducted to better understand patterns in the dataset and support subsequent business analysis.
 - Revenue distribution
 - Top countries by number of distribution
 - Monthly transaction volume
 - Customer purchase frequency

### 1️. Customer Analysis
Purpose:
To identify high-value customers and evaluate how revenue and transactions are distributed across customers.
- Top 10 customers by net revenue
- Customer frequency
Insight:
Revenue is not evenly distributed, indicating that certain customers contribute significantly more to total net revenue.

### 2️. Sales Trend Analysis
Purpose:
To identify growth patterns, seasonality, and fluctuations in sales performance over time.
- Monthly net revenue trend
- Monthly transaction volume
Insight:
Monthly trends allow the business to monitor performance changes and identify potential seasonal peaks or declines.

### 3️. Product Performance Analysis
Purpose:
To determine which products are the primary drivers of revenue and sales volume.
- Top products by revenue
- Top products by quantity
Insight:
A small number of products typically generate a large share of revenue, supporting strategic inventory and pricing decisions.

### 4. Country-Level Analysis
Purpose:
To evaluate geographic performance and identify key markets contributing to overall revenue.
- Revenue by country
- Transaction count by country
Insight:
Revenue distribution across countries highlights market concentration and international performance differences.

## Advanced Customer Revenue Analysis
### 1. Customer ranking  
Purpose:
To rank customers based on total net revenue and identify the highest-value customers.
Insight:
Ranking helps determine which customers are the primary revenue contributors and supports retention strategies.

### 2. Revenue concentration
Purpose:
To measure each customer’s percentage contribution to total net revenue and evaluate revenue distribution.
Insight:
Revenue is significantly concentrated among top customers, indicating dependency on a smaller customer segment.

### 3. Top 10 customers by net revenue (filtered view of customer ranking)
Purpose:
To provide a focused view of the highest revenue-generating customers for reporting and interpretation.
Insight:
The top customers represent the most valuable business relationships.

### 4. Pareto Analysis
To test whether revenue follows the Pareto principle (80/20 rule), where a small proportion of customers generate the majority of revenue.
- Count cumulative percentage
- Count total customers
- Calculate top 20% customers
Result:
The analysis showed that the top 20% of customers generate approximately 73.8% of total net revenue.
Insight:
This demonstrates strong revenue concentration, meaning the business depends heavily on a relatively small group of high-value customers.

## Key Findings & Insights
- Revenue is highly concentrated among top customers.
- A small proportion of customers contribute the majority of total net revenue.
- Sales trends can be analysed over time for strategic planning.
- Product and country analysis identify key revenue drivers.
- Advanced SQL techniques (window functions) were used for deeper insights.

## Business Implications & Recommendations
Based on the analysis:
- Retention strategies should focus on high-value customers.
- Revenue concentration should be monitored to reduce dependency risk.
- Top-performing products should be prioritised in inventory planning.
- Monthly trend analysis can support forecasting and seasonal planning.

## Limitations
- Analysis is descriptive and does not establish causality.
- Dataset may not represent all retail environments.
- External factors (marketing campaigns, economic conditions) are not included.
- Some assumptions were made during data cleaning.

## Tools & Technologies
- PostgreSQL
- SQL (including window functions)
- Data cleaning and aggregation techniques
- GitHub

## Project Files
- 📓 [SQL Script](sql_scripts/online_retail_analysis.sql) – Full SQL script (cleaning + analysis)
- 📁 Note: The raw dataset is not included due to file size limitations. It can be downloaded from [https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci] – Raw online retail dataset

