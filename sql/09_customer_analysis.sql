-- CUSTOMER ANALYSIS: Client Account Roles
SELECT
    type AS client_role,
    COUNT(*) AS relationship_count,
    COUNT(DISTINCT client_id) AS unique_clients,
    COUNT(DISTINCT account_id) AS unique_accounts
FROM disp
GROUP BY type
ORDER BY relationship_count DESC;

-- CUSTOMER ANALYSIS: Clients per Account
WITH account_clients AS (
    SELECT
        account_id,
        COUNT(DISTINCT client_id) AS client_count
    FROM disp
    GROUP BY account_id
)

SELECT
    client_count,
    COUNT(*) AS account_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM account_clients
GROUP BY client_count
ORDER BY client_count;

-- CUSTOMER ANALYSIS: Gender Distribution
WITH client_gender AS (
    SELECT
        client_id,
        CASE
            WHEN (birth_number / 100)::int % 100 > 50
                THEN 'Female'
            ELSE 'Male'
        END AS gender
    FROM client
)

SELECT
    gender,
    COUNT(*) AS client_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM client_gender
GROUP BY gender
ORDER BY client_count DESC;

-- CUSTOMER ANALYSIS: Banking Product Adoption
WITH client_products AS (
    SELECT
        d.client_id,
        d.type AS client_role,

        EXISTS (
            SELECT 1
            FROM card c
            WHERE c.disp_id = d.disp_id
        ) AS has_card,

        (
            d.type = 'OWNER'
            AND EXISTS (
                SELECT 1
                FROM loan l
                WHERE l.account_id = d.account_id
            )
        ) AS has_loan

    FROM disp d
)

SELECT
    COUNT(*) AS total_clients,
    COUNT(*) FILTER (
        WHERE has_card
    ) AS clients_with_card,
    COUNT(*) FILTER (
        WHERE has_loan
    ) AS owners_with_loan,
    COUNT(*) FILTER (
        WHERE has_card AND has_loan
    ) AS clients_with_both,
    COUNT(*) FILTER (
        WHERE NOT has_card AND NOT has_loan
    ) AS clients_without_products

FROM client_products;

-- CUSTOMER ANALYSIS: Product-Based Customer Segmentation

WITH client_products AS (
    SELECT
        d.client_id,
        EXISTS (
            SELECT 1
            FROM card c
            WHERE c.disp_id = d.disp_id
        ) AS has_card,
        (
            d.type = 'OWNER'
            AND EXISTS (
                SELECT 1
                FROM loan l
                WHERE l.account_id = d.account_id
            )
        ) AS has_loan

    FROM disp d
),

customer_segments AS (
    SELECT
        client_id,

        CASE
            WHEN has_card AND has_loan
                THEN 'Card and Loan'
            WHEN has_card AND NOT has_loan
                THEN 'Card Only'
            WHEN NOT has_card AND has_loan
                THEN 'Loan Only'
            ELSE 'Neither'
        END AS customer_segment

    FROM client_products
)

SELECT
    customer_segment,
    COUNT(*) AS client_count,

    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage

FROM customer_segments
GROUP BY customer_segment
ORDER BY client_count DESC;


-- CUSTOMER ANALYSIS: Product Segments vs Transaction Activity
WITH account_activity AS (
    SELECT
        account_id,
        COUNT(*) AS transaction_count,
        SUM(amount) AS total_amount
    FROM trans
    GROUP BY account_id
),

owner_products AS (
    SELECT
        d.client_id,
        d.account_id,
        CASE
            WHEN EXISTS (
                SELECT 1 FROM card c
                WHERE c.disp_id = d.disp_id
            )
            AND EXISTS (
                SELECT 1 FROM loan l
                WHERE l.account_id = d.account_id
            ) THEN 'Card and Loan'
            WHEN EXISTS (
                SELECT 1 FROM card c
                WHERE c.disp_id = d.disp_id
            ) THEN 'Card Only'
            WHEN EXISTS (
                SELECT 1 FROM loan l
                WHERE l.account_id = d.account_id
            ) THEN 'Loan Only'
            ELSE 'Neither'
        END AS customer_segment

    FROM disp d
    WHERE d.type = 'OWNER'
)

SELECT
    op.customer_segment,
    COUNT(*) AS owner_count,
    ROUND(AVG(COALESCE(a.transaction_count, 0)), 2)
        AS avg_transactions,
    ROUND(AVG(COALESCE(a.total_amount, 0)), 2)
        AS avg_total_amount_per_account

FROM owner_products op
LEFT JOIN account_activity a
    ON op.account_id = a.account_id

GROUP BY op.customer_segment
ORDER BY avg_transactions DESC;

-- CUSTOMER ANALYSIS: Transaction Share by Product Segment
WITH owner_segments AS (
    SELECT
        d.account_id,
        CASE
            WHEN EXISTS (
                SELECT 1 FROM card c
                WHERE c.disp_id = d.disp_id
            )
            AND EXISTS (
                SELECT 1 FROM loan l
                WHERE l.account_id = d.account_id
            ) THEN 'Card and Loan'
            WHEN EXISTS (
                SELECT 1 FROM card c
                WHERE c.disp_id = d.disp_id
            ) THEN 'Card Only'
            WHEN EXISTS (
                SELECT 1 FROM loan l
                WHERE l.account_id = d.account_id
            ) THEN 'Loan Only'

            ELSE 'Neither'
        END AS customer_segment
    FROM disp d
    WHERE d.type = 'OWNER'
),

segment_transactions AS (
    SELECT
        os.customer_segment,
        COUNT(t.trans_id) AS transaction_count
    FROM owner_segments os
    LEFT JOIN trans t
        ON os.account_id = t.account_id
    GROUP BY os.customer_segment
)

SELECT
    customer_segment,
    transaction_count,
    ROUND(
        100.0 * transaction_count
        / NULLIF(SUM(transaction_count) OVER (), 0),
        2
    ) AS transaction_share_pct
FROM segment_transactions
ORDER BY transaction_count DESC;
