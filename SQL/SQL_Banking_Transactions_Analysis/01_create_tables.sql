-- PHASE 1: TABLE CREATION
-- Project: Banking Transactions Analysis

-- Switch to the correct database context
USE BankingDB;
GO

-- Create the "customers" table
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,  -- Unique customer identifier
    age_group CHAR(1),                    -- Age group indicator (e.g., 'A', 'B', 'C')
    gender CHAR(1)                        -- Customer gender ('M' or 'F')
);

-- Drop existing table if needed
IF OBJECT_ID('transactions', 'U') IS NOT NULL
    DROP TABLE transactions;
GO

-- Create the "transactions" table
CREATE TABLE transactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id VARCHAR(50),  -- Match the length of customers.customer_id
    step INT,
    merchant VARCHAR(50),
    category VARCHAR(50),
    amount DECIMAL(12,2),
    is_fraud BIT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
GO

-- Display metadata (column definitions) for the "customers" table
EXEC sp_help 'customers';

-- Display metadata (column definitions) for the "transactions" table
EXEC sp_help 'transactions';

