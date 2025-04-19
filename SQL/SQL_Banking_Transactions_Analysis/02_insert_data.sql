-- PHASE 2: DATA LOADING

-- DATA IMPORT REQUIRED
-- Before running this script, make sure that the file
-- 'bs140513_032310.csv' has been loaded into the
-- 'staging_banking' table via SSMS Import Wizard.

-- Create staging table as an exact copy of the CSV file
CREATE TABLE staging_banking (
    step INT,                         -- Time step representing when the transaction occurred
    customer VARCHAR(20),             -- Customer identifier (as in the source CSV)
    age CHAR(4),                      -- Age (stored as text, e.g., "35Y" or similar format)
    gender CHAR(3),                   -- Gender (e.g., "M", "F" or similar)
    zipcodeOri VARCHAR(10),           -- Customer's originating zipcode
    merchant VARCHAR(50),             -- Merchant name involved in the transaction
    zipMerchant VARCHAR(10),          -- Merchant's zipcode
    category VARCHAR(50),             -- Transaction category (e.g., CASH_OUT, PAYMENT)
    amount DECIMAL(12,2),             -- Transaction amount with two decimals
    fraud BIT                         -- Flag indicating if the transaction is fraudulent (1 for fraud, 0 otherwise)
);
-- Display the first 10 rows from the staging table to verify data load
SELECT TOP 10 * FROM staging_banking;


-- PHASE 2.1: DATA TRANSFORMATION & INSERTION

-- Insert unique customers into the 'customers' table
INSERT INTO customers (customer_id, age_group, gender)
SELECT DISTINCT
    customer,   -- Unique customer identifier
    age,        -- Age group (as provided in the staging data)
    gender      -- Gender
FROM staging_banking
WHERE customer IS NOT NULL;  -- Ensure not to include records without a valid customer ID

-- Verify the total number of customers inserted
SELECT COUNT(*) AS total_clientes FROM customers;
-- Display the first 10 rows from the 'customers' table to inspect the data
SELECT TOP 10 * FROM customers;


-- Insert cleaned transactions into the 'transactions' table
INSERT INTO transactions (
    customer_id, step, merchant, category, amount, is_fraud
)
SELECT
    customer,     -- Associate transaction with customer (foreign key)
    step,         -- Time step of the transaction
    merchant,     -- Merchant involved in the transaction
    category,     -- Transaction category
    amount,       -- Transaction amount
    fraud         -- Fraud flag
FROM staging_banking
WHERE customer IS NOT NULL;  -- Only consider rows with a valid customer

-- Verify total transactions inserted
SELECT COUNT(*) AS total_transacciones FROM transactions;
-- Display the first 10 rows from the 'transactions' table for data inspection
SELECT TOP 10 * FROM transactions;


