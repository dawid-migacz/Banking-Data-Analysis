-- DATA QUALITY CHECK
-- Table: staging_district
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT a1) AS unique_districts,
    COUNT(*) FILTER (WHERE a12 IS NULL OR a12 = '?') AS missing_a12,
    COUNT(*) FILTER (WHERE a13 IS NULL OR a13 = '?') AS missing_a13,
    COUNT(*) FILTER (WHERE a15 IS NULL OR a15 = '?') AS missing_a15,
    COUNT(*) FILTER (WHERE a16 IS NULL OR a16 = '?') AS missing_a16
FROM staging_district;

-- DATA QUALITY CHECK
-- Table: staging_client
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT client_id) AS unique_clients,
    COUNT(*) FILTER (
        WHERE client_id IS NULL OR TRIM(client_id) = ''
    ) AS missing_client_id,
    COUNT(*) FILTER (
        WHERE birth_number IS NULL OR TRIM(birth_number) = ''
    ) AS missing_birth_number,
    COUNT(*) FILTER (
        WHERE district_id IS NULL OR TRIM(district_id) = ''
    ) AS missing_district_id
FROM staging_client;

-- DATA QUALITY CHECK
-- Table: staging_account
SELECT
    COUNT(*) AS total_accounts,
    COUNT(DISTINCT account_id) AS unique_accounts,
    COUNT(*) FILTER (
        WHERE account_id IS NULL OR TRIM(account_id) = ''
    ) AS missing_account_id,
    COUNT(*) FILTER (
        WHERE district_id IS NULL OR TRIM(district_id) = ''
    ) AS missing_district_id,
    COUNT(*) FILTER (
        WHERE frequency IS NULL OR TRIM(frequency) = ''
    ) AS missing_frequency,
    COUNT(*) FILTER (
        WHERE date IS NULL OR TRIM(date) = ''
    ) AS missing_date
FROM staging_account;

-- DATA QUALITY CHECK
-- Table: staging_disp
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT disp_id) AS unique_disp,
    COUNT(*) FILTER (
        WHERE disp_id IS NULL OR TRIM(disp_id) = ''
    ) AS missing_disp_id,
    COUNT(*) FILTER (
        WHERE client_id IS NULL OR TRIM(client_id) = ''
    ) AS missing_client_id,
    COUNT(*) FILTER (
        WHERE account_id IS NULL OR TRIM(account_id) = ''
    ) AS missing_account_id,
    COUNT(*) FILTER (
        WHERE type IS NULL OR TRIM(type) = ''
    ) AS missing_type
FROM staging_disp;

-- Distribution of account roles
SELECT
    type,
    COUNT(*) AS total
FROM staging_disp
GROUP BY type
ORDER BY total DESC;

-- DATA QUALITY CHECK
-- Table: staging_card
SELECT
    COUNT(*) AS total_cards,
    COUNT(DISTINCT card_id) AS unique_cards,
    COUNT(*) FILTER (
        WHERE card_id IS NULL OR TRIM(card_id) = ''
    ) AS missing_card_id,
    COUNT(*) FILTER (
        WHERE disp_id IS NULL OR TRIM(disp_id) = ''
    ) AS missing_disp_id,
    COUNT(*) FILTER (
        WHERE type IS NULL OR TRIM(type) = ''
    ) AS missing_type,
    COUNT(*) FILTER (
        WHERE issued IS NULL OR TRIM(issued) = ''
    ) AS missing_issued
FROM staging_card;

-- Distribution of card types
SELECT
    type,
    COUNT(*) AS total
FROM staging_card
GROUP BY type
ORDER BY total DESC;

-- Checking the date format
SELECT
    card_id,
    issued
FROM staging_card
LIMIT 10;

-- DATA QUALITY CHECK
-- Table: staging_loan
SELECT
    COUNT(*) AS total_loans,
    COUNT(DISTINCT loan_id) AS unique_loans,
    COUNT(*) FILTER (
        WHERE loan_id IS NULL OR TRIM(loan_id) = ''
    ) AS missing_loan_id,
    COUNT(*) FILTER (
        WHERE account_id IS NULL OR TRIM(account_id) = ''
    ) AS missing_account_id,
    COUNT(*) FILTER (
        WHERE date IS NULL OR TRIM(date) = ''
    ) AS missing_date,
    COUNT(*) FILTER (
        WHERE amount IS NULL OR TRIM(amount) = ''
    ) AS missing_amount,
    COUNT(*) FILTER (
        WHERE duration IS NULL OR TRIM(duration) = ''
    ) AS missing_duration,
    COUNT(*) FILTER (
        WHERE payments IS NULL OR TRIM(payments) = ''
    ) AS missing_payments,
    COUNT(*) FILTER (
        WHERE status IS NULL OR TRIM(status) = ''
    ) AS missing_status
FROM staging_loan;

-- Distribution of loan statuses
SELECT
    status,
    COUNT(*) AS total_loans
FROM staging_loan
GROUP BY status
ORDER BY status;

-- Check loan date format
SELECT
    loan_id,
    date
FROM staging_loan
LIMIT 10;

-- DATA QUALITY CHECK
-- Table: staging_payment_order
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(*) FILTER (
        WHERE order_id IS NULL OR TRIM(order_id) = ''
    ) AS missing_order_id,
    COUNT(*) FILTER (
        WHERE account_id IS NULL OR TRIM(account_id) = ''
    ) AS missing_account_id,
    COUNT(*) FILTER (
        WHERE bank_to IS NULL OR TRIM(bank_to) = ''
    ) AS missing_bank_to,
    COUNT(*) FILTER (
        WHERE account_to IS NULL OR TRIM(account_to) = ''
    ) AS missing_account_to,
    COUNT(*) FILTER (
        WHERE amount IS NULL OR TRIM(amount) = ''
    ) AS missing_amount,
    COUNT(*) FILTER (
        WHERE k_symbol IS NULL OR TRIM(k_symbol) = ''
    ) AS missing_k_symbol
FROM staging_payment_order;

-- Payment order categories
SELECT
    k_symbol,
    COUNT(*) AS total_orders
FROM staging_payment_order
GROUP BY k_symbol
ORDER BY total_orders DESC;


-- DATA QUALITY CHECK
-- Table: staging_trans
SELECT
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT trans_id) AS unique_transactions
FROM staging_trans;


-- DATA QUALITY CHECK: staging_trans
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE trans_id IS NULL OR TRIM(trans_id) = ''
    ) AS missing_trans_id,
    COUNT(*) FILTER (
        WHERE account_id IS NULL OR TRIM(account_id) = ''
    ) AS missing_account_id,
    COUNT(*) FILTER (
        WHERE date IS NULL OR TRIM(date) = ''
    ) AS missing_date,
    COUNT(*) FILTER (
        WHERE type IS NULL OR TRIM(type) = ''
    ) AS missing_type,
    COUNT(*) FILTER (
        WHERE operation IS NULL OR TRIM(operation) = ''
    ) AS missing_operation,
    COUNT(*) FILTER (
        WHERE amount IS NULL OR TRIM(amount) = ''
    ) AS missing_amount,
    COUNT(*) FILTER (
        WHERE balance IS NULL OR TRIM(balance) = ''
    ) AS missing_balance,
    COUNT(*) FILTER (
        WHERE k_symbol IS NULL OR TRIM(k_symbol) = ''
    ) AS missing_k_symbol,
    COUNT(*) FILTER (
        WHERE bank IS NULL OR TRIM(bank) = ''
    ) AS missing_bank,
    COUNT(*) FILTER (
        WHERE account IS NULL OR TRIM(account) = ''
    ) AS missing_account
FROM staging_trans;


-- TRANSACTION TYPES
SELECT
    type,
    COUNT(*) AS total_transactions
FROM staging_trans
GROUP BY type
ORDER BY total_transactions DESC;


-- CHECK TRANSACTION DATE FORMAT
SELECT
    trans_id,
    date
FROM staging_trans
LIMIT 10;
