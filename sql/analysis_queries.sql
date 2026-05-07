-- ── 1. TOP-PERFORMING PRODUCTS ───────────────────────────────────

SELECT
    p.product_id,
    p.product_name,
    p.category,
    COUNT(o.order_id)          AS total_orders,
    SUM(o.quantity)            AS total_units_sold,
    ROUND(SUM(o.total_amount), 2)  AS total_revenue,
    ROUND(AVG(o.total_amount), 2)  AS avg_order_value
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC;


-- ── 2. MONTHLY REVENUE TRENDS ────────────────────────────────────


SELECT
    strftime('%Y', order_date) AS year,
    strftime('%m', order_date) AS month,
    COUNT(order_id)            AS total_orders,
    SUM(quantity)              AS total_units,
    ROUND(SUM(total_amount), 2)AS monthly_revenue
FROM orders
GROUP BY year, month
ORDER BY year, month;


-- ── 3. REGIONAL SALES BREAKDOWN ──────────────────────────────────


SELECT
    region,
    COUNT(order_id)                AS total_orders,
    SUM(quantity)                  AS total_units,
    ROUND(SUM(total_amount), 2)    AS regional_revenue,
    ROUND(
        SUM(total_amount) * 100.0 /
        (SELECT SUM(total_amount) FROM orders), 2
    )                              AS revenue_share_pct
FROM orders
GROUP BY region
ORDER BY regional_revenue DESC;


-- ── 4. CUSTOMER RETENTION (REPEAT BUYERS) ────────────────────────


WITH customer_years AS (
    SELECT
        customer_id,
        COUNT(DISTINCT strftime('%Y', order_date)) AS active_years,
        COUNT(order_id)                            AS total_orders,
        ROUND(SUM(total_amount), 2)                AS lifetime_value
    FROM orders
    GROUP BY customer_id
)
SELECT
    cy.customer_id,
    c.customer_name,
    c.region,
    cy.active_years,
    cy.total_orders,
    cy.lifetime_value,
    CASE
        WHEN cy.active_years >= 3 THEN 'Loyal'
        WHEN cy.active_years = 2  THEN 'Returning'
        ELSE                           'New'
    END AS customer_segment
FROM customer_years cy
JOIN customers c ON cy.customer_id = c.customer_id
ORDER BY cy.lifetime_value DESC;


-- ── 5. CATEGORY-WISE PERFORMANCE ────────────────────────────────

WITH category_stats AS (
    SELECT
        p.category,
        COUNT(o.order_id)           AS total_orders,
        SUM(o.quantity)             AS total_units,
        ROUND(SUM(o.total_amount), 2) AS category_revenue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.category
)
SELECT
    category,
    total_orders,
    total_units,
    category_revenue,
    ROUND(
        SUM(category_revenue) OVER (ORDER BY category_revenue DESC),
        2
    ) AS running_total_revenue,
    ROUND(
        category_revenue * 100.0 / SUM(category_revenue) OVER (),
        2
    ) AS revenue_share_pct
FROM category_stats
ORDER BY category_revenue DESC;


-- ── 6. TOP 5 CUSTOMERS PER REGION ───────────────────────────────


WITH customer_revenue AS (
    SELECT
        o.customer_id,
        c.customer_name,
        o.region,
        ROUND(SUM(o.total_amount), 2) AS total_spent,
        COUNT(o.order_id)             AS total_orders
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name, o.region
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY region ORDER BY total_spent DESC) AS region_rank
    FROM customer_revenue
)
SELECT * FROM ranked
WHERE region_rank <= 5
ORDER BY region, region_rank;


-- ── 7. MONTH-OVER-MONTH REVENUE GROWTH ──────────────────────────


WITH monthly AS (
    SELECT
        strftime('%Y-%m', order_date) AS ym,
        ROUND(SUM(total_amount), 2)   AS revenue
    FROM orders
    GROUP BY ym
)
SELECT
    ym,
    revenue,
    LAG(revenue) OVER (ORDER BY ym) AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY ym)) * 100.0 /
        NULLIF(LAG(revenue) OVER (ORDER BY ym), 0), 2
    ) AS mom_growth_pct
FROM monthly
ORDER BY ym;


-- ── 8. DISCOUNT IMPACT ANALYSIS ──────────────────────────────────


SELECT
    CASE
        WHEN discount_pct = 0  THEN 'No Discount'
        WHEN discount_pct <= 5 THEN 'Low (1-5%)'
        WHEN discount_pct <= 10THEN 'Medium (6-10%)'
        ELSE                        'High (>10%)'
    END                             AS discount_tier,
    COUNT(order_id)                 AS total_orders,
    ROUND(AVG(total_amount), 2)     AS avg_order_value,
    ROUND(SUM(total_amount), 2)     AS total_revenue
FROM orders
GROUP BY discount_tier
ORDER BY avg_order_value DESC;