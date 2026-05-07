CREATE TABLE IF NOT EXISTS products (
    product_id   TEXT PRIMARY KEY,
    product_name TEXT NOT NULL,
    category     TEXT NOT NULL,
    base_price   REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id   TEXT PRIMARY KEY,
    customer_name TEXT NOT NULL,
    region        TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS orders (
    order_id     INTEGER PRIMARY KEY,
    order_date   TEXT    NOT NULL,   -- stored as YYYY-MM-DD
    customer_id  TEXT    NOT NULL,
    product_id   TEXT    NOT NULL,
    quantity     INTEGER NOT NULL,
    unit_price   REAL    NOT NULL,
    discount_pct INTEGER NOT NULL DEFAULT 0,
    total_amount REAL    NOT NULL,
    region       TEXT    NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES products(product_id)
);