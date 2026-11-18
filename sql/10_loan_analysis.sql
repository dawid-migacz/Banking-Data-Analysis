-- LOAN ANALYSIS: Portfolio Overview
SELECT
    COUNT(*) AS total_loans,
    ROUND(SUM(amount), 2) AS total_loan_amount,
    ROUND(AVG(amount), 2) AS avg_loan_amount,
    MIN(amount) AS min_loan_amount,
    MAX(amount) AS max_loan_amount
FROM loan;

-- LOAN ANALYSIS: Loan Status Distribution
SELECT
    status AS loan_status,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS loan_percentage,
    ROUND(SUM(amount), 2) AS total_loan_amount,
    ROUND(AVG(amount), 2) AS avg_loan_amount

FROM loan
GROUP BY status
ORDER BY status;

-- LOAN ANALYSIS: Problematic Loans Overview
SELECT
    COUNT(*) AS total_loans,
    COUNT(*) FILTER (
        WHERE status IN ('B', 'D')
    ) AS problematic_loans,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE status IN ('B', 'D')
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS problematic_loans_pct,
    ROUND(SUM(amount) FILTER (
        WHERE status IN ('B', 'D')
    ), 2) AS problematic_loan_amount,
    ROUND(
        100.0 * SUM(amount) FILTER (
            WHERE status IN ('B', 'D')
        ) / NULLIF(SUM(amount), 0),
        2
    ) AS problematic_amount_pct

FROM loan;

-- LOAN ANALYSIS: Loan Amount vs Repayment Problems
WITH loan_groups AS (
    SELECT
        loan_id,
        amount,
        status,

        NTILE(4) OVER (
            ORDER BY amount, loan_id
        ) AS amount_quartile

    FROM loan
)

SELECT
    amount_quartile,
    COUNT(*) AS loan_count,
    MIN(amount) AS min_loan_amount,
    MAX(amount) AS max_loan_amount,
    COUNT(*) FILTER (
        WHERE status IN ('B', 'D')
    ) AS problematic_loans,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE status IN ('B', 'D')
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS problematic_pct

FROM loan_groups
GROUP BY amount_quartile
ORDER BY amount_quartile;

-- LOAN ANALYSIS: Loan Duration vs Repayment Problems
SELECT
    duration AS duration_months,
    COUNT(*) AS loan_count,
    ROUND(AVG(amount), 2) AS avg_loan_amount,
    COUNT(*) FILTER (
        WHERE status IN ('B', 'D')
    ) AS problematic_loans,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE status IN ('B', 'D')
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS problematic_pct

FROM loan
GROUP BY duration
ORDER BY duration;

-- LOAN ANALYSIS: Loan Amount and Repayment Status
SELECT
    CASE
        WHEN status IN ('A', 'B') THEN 'Closed'
        WHEN status IN ('C', 'D') THEN 'Active'
    END AS loan_group,
    CASE
        WHEN status IN ('B', 'D') THEN 'Problematic'
        ELSE 'Non-problematic'
    END AS repayment_category,
    COUNT(*) AS loan_count,
    ROUND(AVG(amount), 2) AS avg_loan_amount,
    ROUND(SUM(amount), 2) AS total_loan_amount

FROM loan
GROUP BY
    loan_group,
    repayment_category
ORDER BY
    loan_group,
    repayment_category;

-- LOAN ANALYSIS: Account Owners With vs Without Loans
WITH account_activity AS (
    SELECT
        account_id,
        COUNT(*) AS transaction_count,
        SUM(amount) AS total_amount
    FROM trans
    GROUP BY account_id
),

owner_loan_status AS (
    SELECT
        d.client_id,
        d.account_id,
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM loan l
                WHERE l.account_id = d.account_id
            ) THEN 'With Loan'
            ELSE 'Without Loan'
        END AS loan_group
    FROM disp d
    WHERE d.type = 'OWNER'
)

SELECT
    o.loan_group,
    COUNT(*) AS owner_count,
    ROUND(
        AVG(COALESCE(a.transaction_count, 0)),
        2
    ) AS avg_transactions,
    ROUND(
        AVG(COALESCE(a.total_amount, 0)),
        2
    ) AS avg_total_amount

FROM owner_loan_status o
LEFT JOIN account_activity a
    ON o.account_id = a.account_id

GROUP BY o.loan_group
ORDER BY avg_transactions DESC;

-- LOAN ANALYSIS: Account Activity vs Repayment Problems
WITH account_activity AS (
    SELECT
        account_id,
        COUNT(*) AS transaction_count,
        SUM(amount) AS total_amount
    FROM trans
    GROUP BY account_id
),

loan_activity AS (
    SELECT
        l.loan_id,
        l.account_id,
        CASE
            WHEN l.status IN ('B', 'D')
                THEN 'Problematic'
            ELSE 'Non-problematic'
        END AS repayment_category,
        COALESCE(a.transaction_count, 0) AS transaction_count,
        COALESCE(a.total_amount, 0) AS total_amount

    FROM loan l
    LEFT JOIN account_activity a
        ON l.account_id = a.account_id
)

SELECT
    repayment_category,
    COUNT(*) AS loan_count,
    ROUND(AVG(transaction_count), 2) AS avg_transactions,
    ROUND(AVG(total_amount), 2) AS avg_total_amount

FROM loan_activity
GROUP BY repayment_category
ORDER BY repayment_category;
