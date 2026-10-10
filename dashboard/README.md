# Dashboard "Olist Sales"

Quick way: Workspace → a folder → ⋮ → **Import** → select `Olist Sales.lvdash.json`. The manual way is below.

1. Left menu → **Dashboards** → **Create dashboard**.
2. Open the **Data** tab → **Create from SQL** → paste one query from `dashboard_queries.sql` → Run. Repeat for all 6 and name each dataset.
3. Open the **Canvas** tab → **Add a visualization** → pick the dataset and the chart type below.
4. Click **Publish**.

| # | Dataset | Chart | Fields |
|---|---|---|---|
| 1 | KPI totals | 3 Counters | revenue · orders · customers |
| 2 | Revenue by month | Line | X: month_start · Y: revenue |
| 3 | Top 10 categories | Bar (horizontal) | X: revenue · Y: product_category |
| 4 | Orders by state | Bar | X: customer_state · Y: orders |
| 5 | Payment type split | Pie | Angle: total_paid · Color: payment_type |
| 6 | Delivery days by month | Line | X: month_start · Y: avg_delivery_days |

Suggested layout: the 3 counters in the top row, the two line charts in the middle, and the bar and pie charts at the bottom.

Product category names are in Portuguese, because that is how the dataset stores them.
