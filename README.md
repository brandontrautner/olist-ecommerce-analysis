# Olist Brazilian E-Commerce Analysis
## **Overview**
Having worked in the e-commerce industry, I wanted to apply data analytics to a domain I understand firsthand, analyzing large volumes of transaction data to identify actionable insights that can drive future strategy and resource allocation.

This project uses the [Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) by Olist, sourced from Kaggle, with 100,000+ orders from 2016–2018 across 9 relational tables covering the full customer journey from purchase through delivery and review.

Live Dashboard: [View on Tableau Public](https://public.tableau.com/views/OlistBrazilianE-CommerceAnalysis/OverviewDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
</br>
---
### Tech Stack

* PostgreSQL — relational database and analytical layer.
* pgAdmin — database management and query interface.
* Python (pandas, SQLAlchemy) — data ingestion from CSV to Postgres.
* Tableau Public — interactive dashboard and visualizations.
---
### Data Pipeline

1. Download — 9 CSV files downloaded from Kaggle.
1. Ingest — Python/pandas script auto-creates tables and loads all CSVs into Postgres in one pass.
1. Model — SQL views built on top of raw tables to create a clean analytical layer.
1. Visualize — View exports loaded into Tableau Public as a single master CSV.
---
### Data Modeling Decisions

Before building any analysis, I identified data quality issues that required deliberate modeling decisions:
1. Multiple reviews per order: </br>
The Olist platform allows customers to leave multiple reviews on the same order. One order had as many as 29 reviews attached to it. Joining the raw reviews table directly caused row fan-out, duplicating order rows and inflating all downstream metrics. *Fix: Pre-aggregated reviews in a CTE using DISTINCT ON (order_id), retaining only the most recent review per order.*

2. Multiple payment rows per order
Orders can be split across multiple payment methods or vouchers. One order had 29 separate voucher payment entries. Same fan-out issue.
*Fix: Pre-aggregated payments in a CTE, summing all payment values and consolidating payment types per order.*

3. Filtering to delivered orders only
8 order statuses exist in the dataset — delivered, shipped, cancelled, unavailable, invoiced, processing, created, and approved. 97% of orders are delivered. All revenue analysis is scoped to delivered orders only to ensure accurate metrics.

4. Date range scoping
Since 2016 data contains only a handful of orders, all dashboards and trend analysis start from January 2017 for a clean and consistent time series.
---
### SQL Views</br>
<ins>v_orders_complete</ins></br>
Base view, one clean row per order joining orders, customers, order items, payments (aggregated), and reviews (aggregated). Foundation for all downstream views and analysis.

<ins>v_monthly_revenue</ins></br>
Monthly revenue, order count, average order value, and average review score broken down by customer state. Powers the revenue trend and geo dashboards.

<ins>v_delivery_performance</ins></br>
Actual vs estimated delivery days, delay days, on-time/late classification, and review score per order. Powers the delivery and satisfaction analysis.

<ins>v_master_dashboard</ins></br>
Single denormalized view combining all key fields from the above views into one table for Tableau ingestion.
---
### Key Findings
1. Consistent revenue growth with a Black Friday spike</br>

   E-commerce revenue accelerated rapidly over the observed period, growing from approximately $88K/month in January 2017 to nearly $1M/month by mid-2018, representing more than 11x growth in under 18 months. November 2017 shows a pronounced surge, with 7,289 orders compared to 4,478 orders in the previous month, reinforcing a strong seasonal spike in holiday demand.</br>
**Business implication:** Inventory planning and marketing spend should be strategically increased ahead of November to capture this predictable surge in demand. The sustained high-growth trajectory further supports continued investment in the e-commerce platform to capitalize on scaling opportunities.

2. Southeast Brazil dominates e-commerce activity</br> 
    Mapping revenue by state reveals a clear concentration in Southeast Brazil. São Paulo (SP), Minas Gerais (MG), and Rio de Janeiro (RJ) lead in both order volume and revenue.
   </br>**Business implication:** Logistics infrastructure, seller acquisition, and marketing efforts should be prioritized in the Southeast while identifying growth opportunities in underserved states.
---
### How to Run Locally
Prerequisites:
- PostgreSQL installed and running
- Python 3 with pip
- Tableau Public

````
# The ingestion script uses pandas to read each CSV and SQLAlchemy to 
automatically create and populate the corresponding Postgres tables.
Update the password and csv_folder path in scripts/load_data.py before running.

# Clone the repo
git clone https://github.com/yourusername/olist-ecommerce-analysis.git
cd olist-ecommerce-analysis

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install pandas sqlalchemy psycopg2-binary

# Create database in pgAdmin or psql
createdb olist_db

# Download Olist dataset from Kaggle and place CSVs in data/raw/
# https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

# Run ingestion script
````
---
### Future Analysis
This project is just scratching the surface. </br>Future directions include:

- **Product category analysis:** Which categories drive the most revenue and which have the lowest satisfaction scores?.
- **Seller performance analysis:** top sellers by revenue, rating, and on-time delivery rate.
- **More current data:** analyzing trends beyond 2018 to understand how the market has evolved.
---
Built by: Brandon Trautner - [LinkedIn](https://www.linkedin.com/in/brandontrautner/) | [Tableau Public](https://public.tableau.com/app/profile/brandon.trautner/vizzes)





