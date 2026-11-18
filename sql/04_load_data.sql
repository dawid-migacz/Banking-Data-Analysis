-- LOAD DATA: district
-- Source: staging_district
-- Target: district
INSERT INTO district (
    district_id,
    district_name,
    region,
    inhabitants,
    municipalities_0_499,
    municipalities_500_1999,
    municipalities_2000_9999,
    municipalities_10000_plus,
    cities,
    urban_ratio,
    average_salary,
    unemployment_1995,
    unemployment_1996,
    entrepreneurs,
    crimes_1995,
    crimes_1996
)
SELECT
    a1::INTEGER,
    a2,
    a3,
    a4::INTEGER,
    a5::INTEGER,
    a6::INTEGER,
    a7::INTEGER,
    a8::INTEGER,
    a9::INTEGER,
    a10::NUMERIC(5,2),
    a11::INTEGER,
    NULLIF(TRIM(a12), '?')::NUMERIC(8,2),
    NULLIF(TRIM(a13), '?')::NUMERIC(8,2),
    a14::INTEGER,
    NULLIF(TRIM(a15), '?')::INTEGER,
    NULLIF(TRIM(a16), '?')::INTEGER
FROM staging_district;

-- VALIDATION: district
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE unemployment_1995 IS NULL)
        AS missing_unemployment,
    COUNT(*) FILTER (WHERE crimes_1995 IS NULL)
        AS missing_crimes
FROM district;

-- LOAD DATA: client
-- Source: staging_client
-- Target: client
INSERT INTO client (
    client_id,
    birth_number,
    district_id
)
SELECT
    client_id::INTEGER,
    birth_number::BIGINT,
    district_id::INTEGER
FROM staging_client;

-- VALIDATION: client
SELECT
    COUNT(*) AS total_clients,
    COUNT(DISTINCT client_id) AS unique_clients,
    COUNT(*) FILTER (
        WHERE birth_number IS NULL
    ) AS missing_birth_number,
    COUNT(*) FILTER (
        WHERE district_id IS NULL
    ) AS missing_district_id
FROM client;

-- LOAD DATA: account
-- Source: staging_account
-- Target: account
INSERT INTO account (
    account_id,
    district_id,
    frequency,
    date
)
SELECT
    account_id::INTEGER,
    district_id::INTEGER,
    frequency,
    TO_DATE(date, 'YYMMDD')
FROM staging_account;

-- VALIDATION: account
SELECT
    COUNT(*) AS total_accounts,
    COUNT(DISTINCT account_id) AS unique_accounts,
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date,
    COUNT(*) FILTER (
        WHERE date IS NULL
    ) AS missing_dates
FROM account;

-- Check account-district relationships
SELECT
    COUNT(*) AS accounts_without_district
FROM account a
LEFT JOIN district d
    ON a.district_id = d.district_id
WHERE d.district_id IS NULL;

-- LOAD DATA: disp
-- Source: staging_disp
-- Target: disp
INSERT INTO disp (
    disp_id,
    client_id,
    account_id,
    type
)
SELECT
    disp_id::INTEGER,
    client_id::INTEGER,
    account_id::INTEGER,
    type
FROM staging_disp;

-- VALIDATION: disp
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT disp_id) AS unique_disp,
    COUNT(*) FILTER (
        WHERE client_id IS NULL
    ) AS missing_client_id,
    COUNT(*) FILTER (
        WHERE account_id IS NULL
    ) AS missing_account_id
FROM disp;

-- Check relationships between disp, client and account
SELECT
    COUNT(*) FILTER (
        WHERE c.client_id IS NULL
    ) AS invalid_clients,
    COUNT(*) FILTER (
        WHERE a.account_id IS NULL
    ) AS invalid_accounts
FROM disp d
LEFT JOIN client c
    ON d.client_id = c.client_id
LEFT JOIN account a
    ON d.account_id = a.account_id;

-- Check whether every account has exactly one owner
SELECT
    account_id,
    COUNT(*) AS owner_count
FROM disp
WHERE type = 'OWNER'
GROUP BY account_id
HAVING COUNT(*) <> 1;

-- LOAD DATA: card
-- Source: staging_card
-- Target: card
INSERT INTO card (
    card_id,
    disp_id,
    type,
    issued
)
SELECT
    card_id::INTEGER,
    disp_id::INTEGER,
    type,
    TO_DATE(LEFT(TRIM(issued), 6), 'YYMMDD')
FROM staging_card;

-- VALIDATION: card
SELECT
    COUNT(*) AS total_cards,
    COUNT(DISTINCT card_id) AS unique_cards,
    MIN(issued) AS earliest_date,
    MAX(issued) AS latest_date,
    COUNT(*) FILTER (
        WHERE issued IS NULL
    ) AS missing_dates
FROM card;

-- Check card-disp relationships
SELECT
    COUNT(*) AS cards_without_disp
FROM card c
LEFT JOIN disp d
    ON c.disp_id = d.disp_id
WHERE d.disp_id IS NULL;

-- LOAD DATA: loan
-- Source: staging_loan
-- Target: loan
INSERT INTO loan (
    loan_id,
    account_id,
    date,
    amount,
    duration,
    payments,
    status
)
SELECT
    loan_id::INTEGER,
    account_id::INTEGER,
    TO_DATE(date, 'YYMMDD'),
    amount::INTEGER,
    duration::INTEGER,
    payments::NUMERIC(12,2),
    status
FROM staging_loan;

-- VALIDATION: loan
SELECT
    COUNT(*) AS total_loans,
    COUNT(DISTINCT loan_id) AS unique_loans,
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date,
    COUNT(*) FILTER (
        WHERE date IS NULL
    ) AS missing_dates,
    SUM(amount) AS total_loan_amount
FROM loan;

-- Check loan-account relationships
SELECT
    COUNT(*) AS loans_without_account
FROM loan l
LEFT JOIN account a
    ON l.account_id = a.account_id
WHERE a.account_id IS NULL;

-- LOAD DATA: payment_order
-- Source: staging_payment_order
-- Target: payment_order
INSERT INTO payment_order (
    order_id,
    account_id,
    bank_to,
    account_to,
    amount,
    k_symbol
)
SELECT
    order_id::INTEGER,
    account_id::INTEGER,
    bank_to,
    account_to,
    amount::NUMERIC(12,2),
    NULLIF(TRIM(k_symbol), '')
FROM staging_payment_order;

-- VALIDATION: payment_order
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(*) FILTER (
        WHERE k_symbol IS NULL
    ) AS missing_k_symbol,
    SUM(amount) AS total_order_amount
FROM payment_order;

-- Check payment_order-account relationships
SELECT
    COUNT(*) AS orders_without_account
FROM payment_order p
LEFT JOIN account a
    ON p.account_id = a.account_id
WHERE a.account_id IS NULL;


-- CHECK NUMERIC VALUES BEFORE IMPORT
-- Table: staging_trans
SELECT
    COUNT(*) FILTER (
        WHERE TRIM(amount) !~ '^-?[0-9]+(\.[0-9]+)?$'
    ) AS invalid_amount,
    COUNT(*) FILTER (
        WHERE TRIM(balance) !~ '^-?[0-9]+(\.[0-9]+)?$'
    ) AS invalid_balance,
    MIN(TRIM(amount)::NUMERIC) AS min_amount,
    MAX(TRIM(amount)::NUMERIC) AS max_amount,
    MIN(TRIM(balance)::NUMERIC) AS min_balance,
    MAX(TRIM(balance)::NUMERIC) AS max_balance
FROM staging_trans;

-- LOAD DATA: trans
-- Source: staging_trans
-- Target: trans
INSERT INTO trans (
    trans_id,
    account_id,
    date,
    type,
    operation,
    amount,
    balance,
    k_symbol,
    bank,
    account
)
SELECT
    trans_id::INTEGER,
    account_id::INTEGER,
    TO_DATE(date, 'YYMMDD'),
    type,
    NULLIF(TRIM(operation), ''),
    amount::NUMERIC(15,2),
    balance::NUMERIC(15,2),
    NULLIF(TRIM(k_symbol), ''),
    NULLIF(TRIM(bank), ''),
    NULLIF(TRIM(account), '')
FROM staging_trans;

-- VALIDATION: trans
SELECT
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT trans_id) AS unique_transactions,
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date,
    COUNT(*) FILTER (
        WHERE date IS NULL
    ) AS missing_dates,
    SUM(amount) AS total_transaction_amount
FROM trans;

-- Check transaction-account relationships
SELECT
    COUNT(*) AS transactions_without_account
FROM trans t
LEFT JOIN account a
    ON t.account_id = a.account_id
WHERE a.account_id IS NULL;
