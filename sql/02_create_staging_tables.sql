-- Create staging tables
CREATE TABLE staging_district (
    a1 TEXT,
    a2 TEXT,
    a3 TEXT,
    a4 TEXT,
    a5 TEXT,
    a6 TEXT,
    a7 TEXT,
    a8 TEXT,
    a9 TEXT,
    a10 TEXT,
    a11 TEXT,
    a12 TEXT,
    a13 TEXT,
    a14 TEXT,
    a15 TEXT,
    a16 TEXT
);

-- STAGING TABLE: client
CREATE TABLE staging_client (
    client_id TEXT,
    birth_number TEXT,
    district_id TEXT
);

-- STAGING TABLE: account
CREATE TABLE staging_account (
    account_id TEXT,
    district_id TEXT,
    frequency TEXT,
    date TEXT
);

-- STAGING TABLE: disp
CREATE TABLE staging_disp (
    disp_id TEXT,
    client_id TEXT,
    account_id TEXT,
    type TEXT
);

-- STAGING TABLE: card
CREATE TABLE staging_card (
    card_id TEXT,
    disp_id TEXT,
    type TEXT,
    issued TEXT
);

-- STAGING TABLE: loan
CREATE TABLE staging_loan (
    loan_id TEXT,
    account_id TEXT,
    date TEXT,
    amount TEXT,
    duration TEXT,
    payments TEXT,
    status TEXT
);

-- STAGING TABLE: payment_order
CREATE TABLE staging_payment_order (
    order_id TEXT,
    account_id TEXT,
    bank_to TEXT,
    account_to TEXT,
    amount TEXT,
    k_symbol TEXT
);

-- STAGING TABLE: trans
CREATE TABLE staging_trans (
    trans_id TEXT,
    account_id TEXT,
    date TEXT,
    type TEXT,
    operation TEXT,
    amount TEXT,
    balance TEXT,
    k_symbol TEXT,
    bank TEXT,
    account TEXT
);
