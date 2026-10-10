# Olist E-commerce Sales Lakehouse (Databricks Free Edition)

A simple end-to-end data engineering and analytics project: raw CSV files go in, a cleaned star schema
and a sales dashboard come out. Everything is governed by Unity Catalog.

## Problem statement
An online store keeps its orders, customers, products and payments in separate files. Nobody can easily
answer questions like "how much did we sell each month?", "which product categories sell best?" or
"how long does delivery take?". This project loads the files into Databricks, cleans them, models them
as a star schema, and shows the answers on a dashboard.

## Unity Catalog layout
```
olist                      <- catalog
 ├── bronze                <- schema
 │    ├── raw              <- volume holding the 5 CSV files
 │    └── orders, order_items, customers, products, payments
 ├── silver                <- schema
 │    └── orders, order_items, customers, products, payments   (cleaned)
 └── gold                  <- schema
      └── fact_orders, dim_customer, dim_product, dim_date, payments
```
Unity Catalog features used:
- **Catalog, schemas and a volume** to organise the layers
- **Three-part names** everywhere, for example `olist.gold.fact_orders`
- **Primary and foreign keys** on the gold tables, so Catalog Explorer draws the star schema
- **Lineage**, tracked automatically from bronze to silver to gold

## Architecture
```
5 CSV files (Kaggle Olist dataset)
      │  upload
      ▼
Volume  /Volumes/olist/bronze/raw/
      │  01_bronze  (PySpark: read.csv → saveAsTable)
      ▼
olist.bronze.*   raw tables
      │  02_silver  (SQL: fix types, remove duplicates, drop rows with no ID)
      ▼
olist.silver.*   cleaned tables
      │  03_gold    (SQL: star schema)   04_keys (SQL: primary and foreign keys)
      ▼
olist.gold.*     fact_orders + dim_customer + dim_product + dim_date  (and payments)
      │
      └─► Dashboard "Olist Sales" (6 charts)
```

## Star schema (`olist.gold`)
```
                  dim_date
                PK order_date
                      │ 1
                      │
                      │ *
dim_customer 1 ── * fact_orders * ── 1 dim_product
PK customer_id    FK customer_id      PK product_id
                  FK product_id
                  FK order_date
```
| Table | Columns |
|---|---|
| `dim_date` | **order_date** (PK), year, month, month_start |
| `dim_customer` | **customer_id** (PK), customer_city, customer_state |
| `dim_product` | **product_id** (PK), product_category |
| `fact_orders` | order_id, customer_id (FK), product_id (FK), order_date (FK), price, freight_value, delivery_days |
| `payments` | order_id, payment_type, payment_value |

`fact_orders` has one row per item in an order.

To see the diagram in Databricks: Catalog → `olist` → `gold` → `fact_orders` → **View relationships**.
To see lineage: open any gold table → **Lineage** tab → **See lineage graph**.

## Project files
| File | What it does |
|---|---|
| `notebooks/00_setup.ipynb` | Run once. Five `CREATE` statements: catalog, 3 schemas, volume |
| `notebooks/01_bronze.ipynb` | Two lines of PySpark per CSV: read it, save it as a table in `olist.bronze` |
| `notebooks/02_silver.ipynb` | Cleans each table with one SQL query into `olist.silver` |
| `notebooks/03_gold.ipynb` | Builds the star schema in `olist.gold` with one SQL query per table |
| `notebooks/04_keys.ipynb` | Adds the primary and foreign keys, one `ALTER TABLE` per cell |
| `dashboard/dashboard_queries.sql` | 6 SQL queries for the dashboard |
| `dashboard/Olist Sales.lvdash.json` | The dashboard as a file you can import into Databricks |
| `dashboard/README.md` | Which chart to use for each query |
| `data/` | Not in the repository. Put the 5 CSVs from Kaggle here after you download them |

## Status
Built and run in Databricks Free Edition on 2026-10-10. The notebooks are in the workspace folder
`olist-sales/notebooks`, and the dashboard "Olist Sales" sits next to them as a draft (not published).

Gold row counts after the run: fact_orders 112,650 · dim_customer 99,441 · dim_product 32,951 ·
dim_date 634 · payments 103,886. The 3 primary keys and 3 foreign keys are in place.

There is no scheduled job and no alert, because the data is a fixed historical dataset: the notebooks
are run by hand, in order.

## What you need (all free)
- **Databricks Free Edition**: sign up at databricks.com/learn/free-edition with your Gmail. No card needed.
- **Kaggle account**: to download the "Brazilian E-Commerce Public Dataset by Olist".

## Build order
1. Sign in to Databricks Free Edition.
2. Download the Olist dataset from Kaggle and unzip it.
3. Import the notebooks: Workspace → your home folder → ⋮ → **Import** → select the 5 `.ipynb` files.
4. Open `00_setup` and run the first cell.
5. Upload these 5 CSVs to the volume (Catalog → olist → bronze → raw → Upload to this volume):
   `olist_orders_dataset.csv`, `olist_order_items_dataset.csv`, `olist_customers_dataset.csv`,
   `olist_products_dataset.csv`, `olist_order_payments_dataset.csv`
6. Run `01_bronze`, then `02_silver`, then `03_gold`, then `04_keys`.
7. Build the dashboard from `dashboard/README.md`.

## Skills this project shows
Medallion architecture (bronze, silver, gold) · Unity Catalog (catalog, schemas, volumes, keys, lineage) ·
PySpark ingestion · SQL transformations · star schema modelling · dashboards
