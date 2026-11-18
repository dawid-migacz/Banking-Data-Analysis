-- CREATE INDEXES
-- Banking Data Analysis

-- CLIENT
CREATE INDEX idx_client_district
ON client(district_id);

-- ACCOUNT
CREATE INDEX idx_account_district
ON account(district_id);

-- DISP
CREATE INDEX idx_disp_client
ON disp(client_id);

CREATE INDEX idx_disp_account
ON disp(account_id);

-- CARD
CREATE INDEX idx_card_disp
ON card(disp_id);

-- LOAN
CREATE INDEX idx_loan_account
ON loan(account_id);

-- PAYMENT ORDER
CREATE INDEX idx_payment_order_account
ON payment_order(account_id);

-- TRANSACTIONS
CREATE INDEX idx_trans_account
ON trans(account_id);

CREATE INDEX idx_trans_date
ON trans(date);

-- VERIFY CREATED INDEXES
SELECT
    tablename,
    indexname
FROM pg_indexes
WHERE schemaname = 'public'
  AND indexname LIKE 'idx_%'
ORDER BY tablename, indexname;
