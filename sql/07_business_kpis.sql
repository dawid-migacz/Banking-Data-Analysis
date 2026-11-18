-- BUSINESS KPI: Banking Overview
SELECT
    (SELECT COUNT(*) FROM client) AS total_clients,
    (SELECT COUNT(*) FROM account) AS total_accounts,
    (SELECT COUNT(*) FROM trans) AS total_transactions,
    (SELECT COUNT(*) FROM loan) AS total_loans,
    (SELECT COUNT(*) FROM card) AS total_cards,
    (SELECT COUNT(*) FROM payment_order) AS total_payment_orders;

-- BUSINESS KPI: Transactions by Type
SELECT
    type,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(AVG(amount), 2) AS avg_amount
FROM trans
GROUP BY type
ORDER BY transaction_count DESC;

-- BUSINESS KPI: Transaction Financial Overview
SELECT
    ROUND(SUM(CASE
        WHEN type = 'PRIJEM' THEN amount
        ELSE 0
    END), 2) AS total_inflow,
    ROUND(SUM(CASE
        WHEN type IN ('VYDAJ', 'VYBER') THEN amount
        ELSE 0
    END), 2) AS total_outflow,
    ROUND(SUM(CASE
        WHEN type = 'PRIJEM' THEN amount
        WHEN type IN ('VYDAJ', 'VYBER') THEN -amount
        ELSE 0
    END), 2) AS net_flow

FROM trans;

-- BUSINESS KPI: Monthly Transaction Trends
SELECT
    DATE_TRUNC('month', date)::date AS transaction_month,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(AVG(amount), 2) AS avg_amount
FROM trans
GROUP BY DATE_TRUNC('month', date)::date
ORDER BY transaction_month;

-- BUSINESS KPI: Yearly Transaction Trends
SELECT
    EXTRACT(YEAR FROM date)::int AS transaction_year,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(AVG(amount), 2) AS avg_amount
FROM trans
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY transaction_year;

-- BUSINESS KPI: Year-over-Year Transaction Growth
WITH yearly_transactions AS (
    SELECT
        EXTRACT(YEAR FROM date)::int AS transaction_year,
        COUNT(*) AS transaction_count
    FROM trans
    GROUP BY EXTRACT(YEAR FROM date)
)

SELECT
    transaction_year,
    transaction_count,
    LAG(transaction_count) OVER (
        ORDER BY transaction_year
    ) AS previous_year_count,
    ROUND(
        100.0 * (
            transaction_count
            - LAG(transaction_count) OVER (
                ORDER BY transaction_year
            )
        )
        / NULLIF(
            LAG(transaction_count) OVER (
                ORDER BY transaction_year
            ), 0
        ), 2
    ) AS yoy_growth_pct

FROM yearly_transactions
ORDER BY transaction_year;
