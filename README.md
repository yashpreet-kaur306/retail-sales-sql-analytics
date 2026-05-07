# 🛒 Retail Sales SQL Analytics

An end-to-end SQL analytics project on a 10,000+ record retail sales database.  
Demonstrates complex SQL (Joins, CTEs, Window Functions, Subqueries) paired with a Python pipeline that auto-exports formatted Excel MIS reports.

---

## 📁 Project Structure

```
retail-sales-sql-analytics/
├── data/
│   └── generate_data.py       # Generates 10,000+ synthetic sales records → SQLite DB
├── sql/
│   ├── schema.sql             # Table definitions
│   └── analysis_queries.sql   # All 8 analytical SQL queries
├── reports/                   # Auto-generated Excel reports (git-ignored)
├── main.py                    # Python pipeline: runs queries → exports Excel
├── requirements.txt
└── README.md
```

---

## 🔍 Business Questions Answered

| # | Analysis | SQL Concepts Used |
|---|----------|-------------------|
| 1 | Top-performing products by revenue | JOIN, GROUP BY, ORDER BY |
| 2 | Monthly revenue trends (2022–2024) | DATE functions, Aggregation |
| 3 | Regional sales breakdown & market share | Subquery, Division |
| 4 | Customer retention & segmentation | CTE, HAVING |
| 5 | Category-wise performance with running total | CTE + Window Function (SUM OVER) |
| 6 | Top 5 customers per region | RANK() OVER PARTITION BY |
| 7 | Month-over-month revenue growth | LAG() Window Function |
| 8 | Discount impact on order value | CASE, GROUP BY, AVG |

---

## ⚙️ Setup & Run

```bash
# 1. Clone the repo
git clone https://github.com/yashpreet-kaur306/retail-sales-sql-analytics.git
cd retail-sales-sql-analytics

# 2. Install dependencies
pip install -r requirements.txt

# 3. Run the full pipeline
python main.py
```

Running `main.py` will:
1. Auto-generate `retail_sales.db` with 10,000 orders, 500 customers, 15 products
2. Execute all 8 SQL queries via SQLite
3. Export a styled multi-sheet Excel report to the `reports/` folder

---

## 📊 Sample Insights

- **Electronics** is the highest-revenue category, contributing ~45% of total sales
- **North** and **West** regions consistently lead in order volume
- Month-over-month growth shows seasonal peaks in Q4 each year
- Customers with **no discount** have a higher average order value than discounted ones

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| SQLite | Relational database engine (no server required) |
| Python / Pandas | Data generation and pipeline automation |
| openpyxl | Styled Excel report export |
| SQL | Core analytics — CTEs, Window Functions, Joins |

---

## 👩‍💻 Author

**Yashpreet Kaur**  
[GitHub](https://github.com/yashpreet-kaur306) · [LinkedIn](https://linkedin.com/in/yashpreet-kaur-47b385211)