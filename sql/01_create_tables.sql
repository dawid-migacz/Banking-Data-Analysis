-- Create table client
CREATE TABLE client (
    client_id INTEGER PRIMARY KEY,
    birth_number BIGINT,
    district_id INTEGER
);

-- Create table district 
CREATE TABLE district (
    district_id INTEGER PRIMARY KEY,
    district_name VARCHAR(100),
    region VARCHAR(100),
    inhabitants INTEGER,
    municipalities_0_499 INTEGER,
    municipalities_500_1999 INTEGER,
    municipalities_2000_9999 INTEGER,
    municipalities_10000_plus INTEGER,
    cities INTEGER,
    urban_ratio NUMERIC(5,2),
    average_salary INTEGER,
    unemployment_1995 NUMERIC(8,2),
    unemployment_1996 NUMERIC(8,2),
    entrepreneurs INTEGER,
    crimes_1995 INTEGER,
    crimes_1996 INTEGER
);

-- Create table account
CREATE TABLE account (
    account_id INTEGER PRIMARY KEY,
    district_id INTEGER,
    frequency VARCHAR(50),
    date DATE
);

-- Create table disp
CREATE TABLE disp (
    disp_id INTEGER PRIMARY KEY,
    client_id INTEGER,
    account_id INTEGER,
    type VARCHAR(20)
);

-- Create table card
CREATE TABLE card (
    card_id INTEGER PRIMARY KEY,
    disp_id INTEGER,
    type VARCHAR(20),
    issued DATE
);

-- Create table loan
CREATE TABLE loan (
    loan_id INTEGER PRIMARY KEY,
    account_id INTEGER,
    date DATE,
    amount INTEGER,
    duration INTEGER,
    payments NUMERIC(12,2),
    status VARCHAR(2)
);

-- Create table payment_order
CREATE TABLE payment_order (
    order_id INTEGER PRIMARY KEY,
    account_id INTEGER,
    bank_to VARCHAR(10),
    account_to VARCHAR(20),
    amount NUMERIC(12,2),
    k_symbol VARCHAR(20)
);

-- Create table trans
CREATE TABLE trans (
    trans_id INTEGER PRIMARY KEY,
    account_id INTEGER,
    date DATE,
    type VARCHAR(20),
    operation VARCHAR(50),
    amount NUMERIC(15,2),
    balance NUMERIC(15,2),
    k_symbol VARCHAR(30),
    bank VARCHAR(10),
    account VARCHAR(20)
);
