import sqlite3
import random
import pandas as pd
from datetime import datetime, timedelta
import os

random.seed(42)

PRODUCTS = [
    ("P001", "Laptop",        "Electronics",   55000),
    ("P002", "Smartphone",    "Electronics",   25000),
    ("P003", "Headphones",    "Electronics",    3500),
    ("P004", "Desk Chair",    "Furniture",      8000),
    ("P005", "Office Table",  "Furniture",     12000),
    ("P006", "Notebook",      "Stationery",      120),
    ("P007", "Pen Set",       "Stationery",      250),
    ("P008", "Backpack",      "Accessories",    2200),
    ("P009", "Water Bottle",  "Accessories",     450),
    ("P010", "Monitor",       "Electronics",   18000),
    ("P011", "Keyboard",      "Electronics",    2500),
    ("P012", "Mouse",         "Electronics",    1200),
    ("P013", "Bookshelf",     "Furniture",      6500),
    ("P014", "Whiteboard",    "Stationery",     3000),
    ("P015", "Laptop Bag",    "Accessories",    1800),
]    
# Random items selected and tuple created
 
REGIONS = ["North", "South", "East", "West", "Central"]   # random regions
 
CUSTOMERS = [(f"C{str(i).zfill(4)}", f"Customer_{i}",
              random.choice(REGIONS)) for i in range(1, 501)]  # 500 customer ids// zfill make sure the id is of 4 digits


START_DATE = datetime(2022, 1, 1)
END_DATE   = datetime(2024, 12, 31)  # r dates selected
 
def random_date():
    delta = END_DATE - START_DATE
    return START_DATE + timedelta(days=random.randint(0, delta.days)) # dates created for orders

orders = []
for order_id in range(1, 10_001):
    customer   = random.choice(CUSTOMERS)
    product    = random.choice(PRODUCTS)
    quantity   = random.randint(1, 10)
    discount   = random.choice([0, 0, 0, 5, 10, 15])   # mostly no discount
    unit_price = product[3]
    total      = round(unit_price * quantity * (1 - discount / 100), 2)
    order_date = random_date() # order lists
 
    orders.append({
        "order_id":    order_id,
        "order_date":  order_date.strftime("%Y-%m-%d"),
        "customer_id": customer[0],
        "product_id":  product[0],
        "quantity":    quantity,
        "unit_price":  unit_price,
        "discount_pct":discount,
        "total_amount":total,
        "region":      customer[2],
    })


df_orders    = pd.DataFrame(orders)
df_products  = pd.DataFrame(PRODUCTS, 
                   columns=["product_id","product_name","category","base_price"]) #PRODUCTS is a tuple!
df_customers = pd.DataFrame(CUSTOMERS, 
                   columns=["customer_id","customer_name","region"])
 
db_path = os.path.join(os.path.dirname(__file__), "..", "retail_sales.db")
db_path = os.path.abspath(db_path)
 
conn = sqlite3.connect(db_path)   # sql file conversion 
df_products.to_sql("products",   conn, if_exists="replace", index=False)
df_customers.to_sql("customers", conn, if_exists="replace", index=False)
df_orders.to_sql("orders",       conn, if_exists="replace", index=False)
conn.close()
 
print(f"✅  Database created at: {db_path}")
print(f"    Orders   : {len(df_orders):,}")
print(f"    Products : {len(df_products)}")
print(f"    Customers: {len(df_customers)}")
 