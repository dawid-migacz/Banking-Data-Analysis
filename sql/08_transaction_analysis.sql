-- TRANSACTION ANALYSIS: Top 10 Active Accounts
SELECT
    account_id,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(AVG(amount), 2) AS avg_amount
FROM trans
GROUP BY account_id
ORDER BY transaction_count DESC, account_id
LIMIT 10;

-- TRANSACTION ANALYSIS: Top 10 Accounts by Value
SELECT
    account_id,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(AVG(amount), 2) AS avg_amount
FROM trans
GROUP BY account_id
ORDER BY total_amount DESC, account_id
LIMIT 10;

-- TRANSACTION ANALYSIS: Account Cash Flows
SELECT
    account_id,
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

FROM trans
GROUP BY account_id
ORDER BY total_inflow DESC, account_id
LIMIT 10;

-- TRANSACTION ANALYSIS: Top 10 Accounts with Highest Net Flow
WITH account_flows AS (
    SELECT
        account_id,

        ROUND(SUM(CASE
            WHEN type = 'PRIJEM' THEN amount
            ELSE 0
        END), 2) AS total_inflow,

        ROUND(SUM(CASE
            WHEN type IN ('VYDAJ', 'VYBER') THEN amount
            ELSE 0
        END), 2) AS total_outflow

    FROM trans
    GROUP BY account_id
)

SELECT
    account_id,
    total_inflow,
    total_outflow,
    total_inflow - total_outflow AS net_flow
FROM account_flows
ORDER BY net_flow DESC, account_id
LIMIT 10;

-- TRANSACTION ANALYSIS: Top 10 Accounts with Lowest Net Flow
WITH account_flows AS (
    SELECT
        account_id,

        ROUND(SUM(CASE
            WHEN type = 'PRIJEM' THEN amount
            ELSE 0
        END), 2) AS total_inflow,

        ROUND(SUM(CASE
            WHEN type IN ('VYDAJ', 'VYBER') THEN amount
            ELSE 0
        END), 2) AS total_outflow

    FROM trans
    GROUP BY account_id
)

SELECT
    account_id,
    total_inflow,
    total_outflow,
    total_inflow - total_outflow AS net_flow
FROM account_flows
ORDER BY net_flow ASC, account_id
LIMIT 10;

-- TRANSACTION ANALYSIS: Account Net Flow Distribution
WITH account_flows AS (
    SELECT
        account_id,
        SUM(CASE
            WHEN type = 'PRIJEM' THEN amount
            WHEN type IN ('VYDAJ', 'VYBER') THEN -amount
            ELSE 0
        END) AS net_flow
    FROM trans
    GROUP BY account_id
)

SELECT
    CASE
        WHEN net_flow > 0 THEN 'Positive'
        WHEN net_flow < 0 THEN 'Negative'
        ELSE 'Zero'
    END AS flow_category,
    COUNT(*) AS account_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage

FROM account_flows
GROUP BY flow_category
ORDER BY account_count DESC;

-- TRANSACTION ANALYSIS: Account Activity Statistics
WITH account_activity AS (
    SELECT
        account_id,
        COUNT(*) AS transaction_count
    FROM trans
    GROUP BY account_id
)

SELECT
    COUNT(*) AS total_active_accounts,
    ROUND(AVG(transaction_count), 2) AS avg_transactions,
    MIN(transaction_count) AS min_transactions,
    MAX(transaction_count) AS max_transactions,
    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY transaction_count
    ) AS median_transactions
FROM account_activity;

-- TRANSACTION ANALYSIS: Account Activity by Opening Year
WITH account_activity AS (
    SELECT
        a.account_id,
        EXTRACT(YEAR FROM a.date)::int AS opening_year,
        COUNT(t.trans_id) AS transaction_count,
        (
            (EXTRACT(YEAR FROM DATE '1998-12-31') -
             EXTRACT(YEAR FROM a.date)) * 12
            +
            (EXTRACT(MONTH FROM DATE '1998-12-31') -
             EXTRACT(MONTH FROM a.date))
            + 1
        ) AS months_active
    FROM account a
    LEFT JOIN trans t
        ON a.account_id = t.account_id
    GROUP BY a.account_id, a.date
)

SELECT
    opening_year,
    COUNT(*) AS account_count,
    ROUND(AVG(transaction_count), 2) AS avg_total_transactions,
    ROUND(
        AVG(transaction_count / NULLIF(months_active, 0)),
        2
    ) AS avg_monthly_transactions
FROM account_activity
GROUP BY opening_year
ORDER BY opening_year;

-- TRANSACTION ANALYSIS: Yearly Account Activity
SELECT
    EXTRACT(YEAR FROM date)::int AS transaction_year,
    COUNT(DISTINCT account_id) AS active_accounts,
    COUNT(*) AS transaction_count,
    ROUND(
        COUNT(*)::numeric
        / NULLIF(COUNT(DISTINCT account_id), 0),
        2
    ) AS avg_transactions_per_account

FROM trans
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY transaction_year;

-- TRANSACTION ANALYSIS: Monthly Cash Flows
SELECT
    DATE_TRUNC('month', date)::date AS transaction_month,
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

FROM trans
GROUP BY DATE_TRUNC('month', date)::date
ORDER BY transaction_month;

-- TRANSACTION ANALYSIS: Monthly Net Flow Extremes
WITH monthly_flows AS (
    SELECT
        DATE_TRUNC('month', date)::date AS transaction_month,

        ROUND(SUM(CASE
            WHEN type = 'PRIJEM' THEN amount
            WHEN type IN ('VYDAJ', 'VYBER') THEN -amount
            ELSE 0
        END), 2) AS net_flow

    FROM trans
    GROUP BY DATE_TRUNC('month', date)::date
),

ranked_flows AS (
    SELECT
        transaction_month,
        net_flow,

        ROW_NUMBER() OVER (
            ORDER BY net_flow DESC, transaction_month
        ) AS highest_rank,

        ROW_NUMBER() OVER (
            ORDER BY net_flow ASC, transaction_month
        ) AS lowest_rank

    FROM monthly_flows
)

SELECT
    transaction_month,
    net_flow,
    CASE
        WHEN highest_rank = 1 THEN 'Highest'
        WHEN lowest_rank = 1 THEN 'Lowest'
    END AS flow_category

FROM ranked_flows
WHERE highest_rank = 1
   OR lowest_rank = 1
ORDER BY net_flow DESC;

-- TRANSACTION ANALYSIS: Cash Flow Seasonality
WITH monthly_flows AS (
    SELECT
        EXTRACT(YEAR FROM date)::int AS transaction_year,
        EXTRACT(MONTH FROM date)::int AS transaction_month,
        SUM(CASE
            WHEN type = 'PRIJEM' THEN amount
            WHEN type IN ('VYDAJ', 'VYBER') THEN -amount
            ELSE 0
        END) AS net_flow

    FROM trans
    GROUP BY
        EXTRACT(YEAR FROM date),
        EXTRACT(MONTH FROM date)
)

SELECT
    transaction_month,
    COUNT(*) AS years_count,
    ROUND(AVG(net_flow), 2) AS avg_net_flow,
    ROUND(MIN(net_flow), 2) AS min_net_flow,
    ROUND(MAX(net_flow), 2) AS max_net_flow

FROM monthly_flows
GROUP BY transaction_month
ORDER BY transaction_month;

-- TRANSACTION ANALYSIS: Operations Overview
SELECT
    COALESCE(operation, 'UNKNOWN') AS operation_type,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(AVG(amount), 2) AS avg_amount
FROM trans
GROUP BY COALESCE(operation, 'UNKNOWN')
ORDER BY transaction_count DESC;

-- TRANSACTION ANALYSIS: Transaction Type vs Operation
SELECT
    type AS transaction_type,
    COALESCE(operation, 'UNKNOWN') AS operation_type,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount
FROM trans
GROUP BY
    type,
    COALESCE(operation, 'UNKNOWN')
ORDER BY
    transaction_type,
    transaction_count DESC;

-- TRANSACTION ANALYSIS: January Operations
SELECT
    EXTRACT(YEAR FROM date)::int AS transaction_year,
    type AS transaction_type,
    COALESCE(operation, 'UNKNOWN') AS operation_type,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount

FROM trans
WHERE EXTRACT(MONTH FROM date) = 1
GROUP BY
    EXTRACT(YEAR FROM date),
    type,
    COALESCE(operation, 'UNKNOWN')
ORDER BY
    transaction_year,
    total_amount DESC;

-- TRANSACTION ANALYSIS: January vs February
SELECT
    EXTRACT(YEAR FROM date)::int AS transaction_year,
    EXTRACT(MONTH FROM date)::int AS transaction_month,
    COUNT(*) FILTER (
        WHERE type = 'VYDAJ'
          AND operation = 'VYBER'
    ) AS withdrawal_count,
    ROUND(SUM(CASE
        WHEN type = 'VYDAJ'
         AND operation = 'VYBER'
        THEN amount
        ELSE 0
    END), 2) AS withdrawal_amount,
    ROUND(SUM(CASE
        WHEN type = 'PRIJEM' THEN amount
        ELSE 0
    END), 2) AS total_inflow,
    ROUND(SUM(CASE
        WHEN type IN ('VYDAJ', 'VYBER') THEN amount
        ELSE 0
    END), 2) AS total_outflow

FROM trans
WHERE EXTRACT(MONTH FROM date) IN (1, 2)
  AND EXTRACT(YEAR FROM date) >= 1994
GROUP BY
    EXTRACT(YEAR FROM date),
    EXTRACT(MONTH FROM date)
ORDER BY
    transaction_year,
    transaction_month;

-- TRANSACTION ANALYSIS: K-Symbol Overview
SELECT
    COALESCE(NULLIF(TRIM(k_symbol), ''), 'UNKNOWN') AS category,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(AVG(amount), 2) AS avg_amount
FROM trans
GROUP BY COALESCE(NULLIF(TRIM(k_symbol), ''), 'UNKNOWN')
ORDER BY transaction_count DESC;

-- TRANSACTION ANALYSIS: K-Symbol vs Transaction Type
SELECT
    COALESCE(NULLIF(TRIM(k_symbol), ''), 'UNKNOWN') AS category,
    type AS transaction_type,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount

FROM trans
GROUP BY
    COALESCE(NULLIF(TRIM(k_symbol), ''), 'UNKNOWN'),
    type
ORDER BY
    category,
    transaction_count DESC;

-- TRANSACTION ANALYSIS: Monthly Loan Repayments
SELECT
    DATE_TRUNC('month', date)::date AS transaction_month,
    COUNT(*) AS repayment_count,
    ROUND(SUM(amount), 2) AS total_repayment_amount,
    ROUND(AVG(amount), 2) AS avg_repayment_amount

FROM trans
WHERE k_symbol = 'UVER'
GROUP BY DATE_TRUNC('month', date)::date
ORDER BY transaction_month;

-- TRANSACTION ANALYSIS: Yearly Loan Repayments
SELECT
    EXTRACT(YEAR FROM date)::int AS transaction_year,
    COUNT(*) AS repayment_count,
    ROUND(SUM(amount), 2) AS total_repayment_amount,
    ROUND(AVG(amount), 2) AS avg_repayment_amount,
    COUNT(DISTINCT account_id) AS repaying_accounts

FROM trans
WHERE k_symbol = 'UVER'
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY transaction_year;
