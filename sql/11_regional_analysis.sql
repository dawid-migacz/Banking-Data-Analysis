-- REGIONAL ANALYSIS: Clients by District
SELECT
    d.district_id,
    d.district_name,
    COUNT(c.client_id) AS client_count,
    ROUND(
        100.0 * COUNT(c.client_id)
        / NULLIF(SUM(COUNT(c.client_id)) OVER (), 0),
        2
    ) AS client_percentage
FROM district d
LEFT JOIN client c
    ON d.district_id = c.district_id

GROUP BY
    d.district_id,
    d.district_name

ORDER BY client_count DESC, d.district_id
LIMIT 10;

-- REGIONAL ANALYSIS: Accounts by Owner District

SELECT
    d.district_id,
    d.district_name,
    COUNT(DISTINCT a.account_id) AS account_count,
    ROUND(
        100.0 * COUNT(DISTINCT a.account_id)
        / NULLIF(
            SUM(COUNT(DISTINCT a.account_id)) OVER (), 0
        ),
        2
    ) AS account_percentage

FROM district d
LEFT JOIN client c
    ON d.district_id = c.district_id
LEFT JOIN disp dp
    ON c.client_id = dp.client_id
   AND dp.type = 'OWNER'
LEFT JOIN account a
    ON dp.account_id = a.account_id
GROUP BY
    d.district_id,
    d.district_name

ORDER BY account_count DESC, d.district_id
LIMIT 10;

-- REGIONAL ANALYSIS: Transaction Activity by District
WITH account_activity AS (
    SELECT
        account_id,
        COUNT(*) AS transaction_count,
        SUM(amount) AS total_amount
    FROM trans
    GROUP BY account_id
)

SELECT
    d.district_id,
    d.district_name,
    COUNT(DISTINCT a.account_id) AS account_count,
    SUM(COALESCE(t.transaction_count, 0)) AS transaction_count,
    ROUND(
        SUM(COALESCE(t.total_amount, 0)), 2
    ) AS total_transaction_amount,
    ROUND(
        AVG(COALESCE(t.transaction_count, 0)), 2
    ) AS avg_transactions_per_account

FROM district d
LEFT JOIN client c
    ON d.district_id = c.district_id
LEFT JOIN disp dp
    ON c.client_id = dp.client_id
   AND dp.type = 'OWNER'
LEFT JOIN account a
    ON dp.account_id = a.account_id
LEFT JOIN account_activity t
    ON a.account_id = t.account_id
WHERE a.account_id IS NOT NULL
GROUP BY
    d.district_id,
    d.district_name
ORDER BY transaction_count DESC, d.district_id
LIMIT 10;

-- REGIONAL ANALYSIS: Loans by District
SELECT
    d.district_id,
    d.district_name,
    COUNT(l.loan_id) AS loan_count,
    ROUND(
        SUM(COALESCE(l.amount, 0)), 2
    ) AS total_loan_amount,
    ROUND(
        AVG(l.amount), 2
    ) AS avg_loan_amount,
    COUNT(l.loan_id) FILTER (
        WHERE l.status IN ('B', 'D')
    ) AS problematic_loans

FROM district d
LEFT JOIN client c
    ON d.district_id = c.district_id
LEFT JOIN disp dp
    ON c.client_id = dp.client_id
   AND dp.type = 'OWNER'
LEFT JOIN loan l
    ON dp.account_id = l.account_id
GROUP BY
    d.district_id,
    d.district_name
ORDER BY loan_count DESC, d.district_id
LIMIT 10;

-- REGIONAL ANALYSIS: Problematic Loan Rate by District
SELECT
    d.district_id,
    d.district_name,
    COUNT(l.loan_id) AS loan_count,
    COUNT(l.loan_id) FILTER (
        WHERE l.status IN ('B', 'D')
    ) AS problematic_loans,
    ROUND(
        100.0 * COUNT(l.loan_id) FILTER (
            WHERE l.status IN ('B', 'D')
        ) / NULLIF(COUNT(l.loan_id), 0),
        2
    ) AS problematic_pct

FROM district d
JOIN client c
    ON d.district_id = c.district_id
JOIN disp dp
    ON c.client_id = dp.client_id
   AND dp.type = 'OWNER'
JOIN loan l
    ON dp.account_id = l.account_id
GROUP BY
    d.district_id,
    d.district_name
HAVING COUNT(l.loan_id) >= 10
ORDER BY
    problematic_pct DESC,
    loan_count DESC;

-- REGIONAL ANALYSIS: Inspect District Economic Indicators
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'district'
ORDER BY ordinal_position;

-- REGIONAL ANALYSIS: Economic Indicators vs Loan Problems
WITH regional_loans AS (
    SELECT
        c.district_id,
        COUNT(l.loan_id) AS loan_count,
        COUNT(l.loan_id) FILTER (
            WHERE l.status IN ('B', 'D')
        ) AS problematic_loans
    FROM loan l
    JOIN disp dp
        ON l.account_id = dp.account_id
       AND dp.type = 'OWNER'
    JOIN client c
        ON dp.client_id = c.client_id
    GROUP BY c.district_id
)

SELECT
    d.district_name,
    d.average_salary,
    d.unemployment_1996,
    r.loan_count,
    r.problematic_loans,
    ROUND(
        100.0 * r.problematic_loans
        / NULLIF(r.loan_count, 0),
        2
    ) AS problematic_pct

FROM regional_loans r
JOIN district d
    ON r.district_id = d.district_id
WHERE r.loan_count >= 10
ORDER BY
    problematic_pct DESC,
    r.loan_count DESC;
