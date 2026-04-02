# Olist Brazilian E-Commerce Analysis

A data analytics project exploring 100,000+ Brazilian e-commerce orders from the [Olist public dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). Built a clean analytical layer from 9 raw tables using PostgreSQL, Python, and Tableau to uncover insights around revenue growth, delivery performance, and regional demand.

**Live dashboard:** [View on Tableau Public](https://public.tableau.com/views/OlistBrazilianE-CommerceAnalysis/OverviewDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

## Key Findings

- **Delivery delays hurt ratings significantly.** Late orders averaged 2.5 stars vs. 4.2 stars for on-time orders across all 27 states.
- **Revenue grew 11x in 18 months.** From ~$88K/month in Jan 2017 to ~$1M/month by mid-2018, with a 63% MoM spike in November 2017 (Black Friday).
- **Southeast Brazil dominates.** São Paulo, Minas Gerais, and Rio de Janeiro lead both order volume and revenue.

---

## Tech Stack

| Tool | Purpose |
|---|---|
| PostgreSQL | Relational database and analytical layer |
| pgAdmin | Database management and query interface |
| Python (pandas, SQLAlchemy) | Data ingestion from CSV to Postgres |
| Tableau Public | Interactive dashboard and visualizations |

---

## Business Questions

1. How did revenue and order volume trend over time?
2. How did delivery performance affect customer satisfaction?
3. Which Brazilian states drove the highest order volume and revenue?

---

## Data Pipeline

```
Kaggle CSVs -> Python ingest -> PostgreSQL views -> Tableau dashboard
```

1. **Download.** Retrieved 9 CSV files from Kaggle.
2. **Ingest.** Used pandas + SQLAlchemy to load raw CSVs into PostgreSQL.
3. **Model.** Built SQL views to create a clean analytical layer.
4. **Visualize.** Exported master view to Tableau Public.

---

## Data Modeling Decisions

**Deduplicating reviews.** Some orders had up to 29 review records. To avoid inflating metrics, a CTE with `DISTINCT ON (order_id)` retains only the most recent review per order.

**Aggregating payments.** Orders with split payments or vouchers produced multiple payment rows. Payments are pre-aggregated in a CTE to sum values and consolidate payment types at the order level.

**Delivered orders only.** 97% of orders were delivered, so revenue analysis is scoped to delivered orders only to keep metrics consistent.

**Time-series start date.** 2016 data is sparse, so trend analysis begins in January 2017 for a cleaner, more reliable time series.

---

## SQL Views

### `v_orders_complete`
Base view. One clean row per order, joining orders, customers, items, aggregated payments, and aggregated reviews. Foundation for all downstream views.

### `v_monthly_revenue`
Monthly revenue, order count, average order value, and average review score broken down by customer state. Powers the revenue trend and geo dashboards.

### `v_delivery_performance`
Actual vs. estimated delivery days, delay days, on-time/late classification, and review score per order. Powers the delivery and satisfaction analysis.

### `v_master_dashboard`
Single denormalized view combining all key fields from the above views for direct Tableau ingestion.

---

## Business Impact

### Delivery delays strongly reduce customer satisfaction
Late orders averaged **2.5 stars** vs. **4.2 stars** for on-time orders across all 27 Brazilian states. Improving delivery reliability is one of the highest-leverage levers for improving customer ratings and retention.

### Revenue scaled rapidly with a predictable holiday spike
Revenue grew from ~$88K/month in January 2017 to ~$1M/month by mid-2018. November 2017 saw a major Black Friday / Cyber Monday surge: 7,289 orders vs. 4,478 the prior month (+63% MoM). Inventory and marketing spend should increase ahead of November each year.

### Southeast Brazil drives order volume and revenue
São Paulo, Minas Gerais, and Rio de Janeiro lead on both metrics. Logistics investment, seller expansion, and marketing should prioritize these high-demand markets.

---

## Dashboard Preview

![Olist Tableau Dashboard](dashboard_preview.png)

---

## Running Locally

### Prerequisites
- PostgreSQL installed and running
- Python 3 with pip
- Tableau Public (free)

### Setup

```bash
# Clone the repo
git clone https://github.com/yourusername/olist-ecommerce-analysis.git
cd olist-ecommerce-analysis

# Create and activate a virtual environment
python3 -m venv venv
source venv/bin/activate      # Windows: venv\Scripts\activate

# Install dependencies
pip install pandas sqlalchemy psycopg2-binary

# Create the database
createdb olist_db

# Download the Olist dataset from Kaggle and place CSVs in data/raw/
# https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

# Update the connection string and csv_folder path in scripts/load_data.py
# then run the ingestion script
python scripts/load_data.py
```

The ingestion script uses pandas to read each CSV and SQLAlchemy to automatically create and populate the corresponding Postgres tables.

---

## Future Directions

- **Product category analysis.** Which categories drive the most revenue, and which have the lowest satisfaction scores?
- **Seller performance.** Top sellers by revenue, rating, and on-time delivery rate.
- **Post-2018 data.** Understanding how the Brazilian e-commerce market has evolved since the dataset ends.e
---
Built by: Brandon Trautner - [LinkedIn](https://www.linkedin.com/in/brandontrautner/) | [Tableau Public](https://public.tableau.com/app/profile/brandon.trautner/vizzes)





