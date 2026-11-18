-- CHECK FOREIGN KEY RELATIONSHIPS
SELECT 'client -> district' AS relationship,
       COUNT(*) AS invalid_records
FROM client c
LEFT JOIN district d
    ON c.district_id = d.district_id
WHERE d.district_id IS NULL

UNION ALL

SELECT 'account -> district',
       COUNT(*)
FROM account a
LEFT JOIN district d
    ON a.district_id = d.district_id
WHERE d.district_id IS NULL

UNION ALL

SELECT 'disp -> client',
       COUNT(*)
FROM disp dp
LEFT JOIN client c
    ON dp.client_id = c.client_id
WHERE c.client_id IS NULL

UNION ALL

SELECT 'disp -> account',
       COUNT(*)
FROM disp dp
LEFT JOIN account a
    ON dp.account_id = a.account_id
WHERE a.account_id IS NULL

UNION ALL

SELECT 'card -> disp',
       COUNT(*)
FROM card c
LEFT JOIN disp dp
    ON c.disp_id = dp.disp_id
WHERE dp.disp_id IS NULL;

-- CHECK REMAINING FOREIGN KEY RELATIONSHIPS
SELECT
    'loan -> account' AS relationship,
    COUNT(*) AS invalid_records
FROM loan l
LEFT JOIN account a
    ON l.account_id = a.account_id
WHERE a.account_id IS NULL

UNION ALL

SELECT
    'payment_order -> account',
    COUNT(*)
FROM payment_order p
LEFT JOIN account a
    ON p.account_id = a.account_id
WHERE a.account_id IS NULL

UNION ALL

SELECT
    'trans -> account',
    COUNT(*)
FROM trans t
LEFT JOIN account a
    ON t.account_id = a.account_id
WHERE a.account_id IS NULL;

-- CREATE FOREIGN KEY CONSTRAINTS
-- 1. Client -> District
ALTER TABLE client
ADD CONSTRAINT fk_client_district
FOREIGN KEY (district_id)
REFERENCES district(district_id);

-- 2. Account -> District
ALTER TABLE account
ADD CONSTRAINT fk_account_district
FOREIGN KEY (district_id)
REFERENCES district(district_id);

-- 3. Disp -> Client
ALTER TABLE disp
ADD CONSTRAINT fk_disp_client
FOREIGN KEY (client_id)
REFERENCES client(client_id);

-- 4. Disp -> Account
ALTER TABLE disp
ADD CONSTRAINT fk_disp_account
FOREIGN KEY (account_id)
REFERENCES account(account_id);

-- 5. Card -> Disp
ALTER TABLE card
ADD CONSTRAINT fk_card_disp
FOREIGN KEY (disp_id)
REFERENCES disp(disp_id);

-- 6. Loan -> Account
ALTER TABLE loan
ADD CONSTRAINT fk_loan_account
FOREIGN KEY (account_id)
REFERENCES account(account_id);

-- 7. Payment Order -> Account
ALTER TABLE payment_order
ADD CONSTRAINT fk_payment_order_account
FOREIGN KEY (account_id)
REFERENCES account(account_id);

-- 8. Trans -> Account
ALTER TABLE trans
ADD CONSTRAINT fk_trans_account
FOREIGN KEY (account_id)
REFERENCES account(account_id);

-- VERIFY FOREIGN KEY CONSTRAINTS
SELECT
    conname AS constraint_name,
    conrelid::regclass AS table_name,
    confrelid::regclass AS referenced_table
FROM pg_constraint
WHERE contype = 'f'
  AND connamespace = 'public'::regnamespace
ORDER BY table_name, constraint_name;
