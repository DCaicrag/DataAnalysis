-- Procedure: High Fraud Percentage Customers
-- This procedure retrieves customers whose fraud ratio exceeds a given threshold.
-- The default threshold is 20%, but it can be adjusted by passing a different value.
-- It returns the total number of transactions, the number of fraud transactions,
-- and the fraud percentage for each customer meeting the threshold.
CREATE PROCEDURE sp_clientes_fraude_alto
    @umbral_fraude FLOAT = 0.2 -- default threshold: 20%
AS
BEGIN
    SELECT 
        customer_id,
        COUNT(*) AS total_transacciones,  -- Total transactions per customer
        SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS transacciones_fraudulentas,  -- Fraudulent transactions count
        ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS porcentaje_fraude  -- Fraud percentage per customer
    FROM transactions
    GROUP BY customer_id
    HAVING SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) > @umbral_fraude;  -- Filter by threshold
END;
GO

-- Execute the procedure with a threshold of 25%
EXEC sp_clientes_fraude_alto @umbral_fraude = 0.25;
GO

-- Procedure: Detect Customers with 3 Consecutive Transactions
--              of Similar Amounts (difference less than $0.50)
-- This procedure uses window functions (LAG) to compare a transaction's amount with the two previous ones,
-- and selects those cases where the differences between consecutive amounts are less than $0.50.
-- It returns the customer ID, transaction step, current amount, and the previous two amounts.
CREATE PROCEDURE sp_alertas_montos_similares
AS
BEGIN
    WITH movs AS (
        SELECT *,
            LAG(amount, 1) OVER (PARTITION BY customer_id ORDER BY step) AS amt_1,  -- Previous transaction amount
            LAG(amount, 2) OVER (PARTITION BY customer_id ORDER BY step) AS amt_2   -- Amount from two transactions ago
        FROM transactions
    )
    SELECT customer_id, step, amount, amt_1, amt_2
    FROM movs
    WHERE 
        ABS(amount - amt_1) < 0.5 AND  -- Current and previous transaction amounts differ by less than $0.50
        ABS(amt_1 - amt_2) < 0.5 AND   -- Previous two transactions also differ by less than $0.50
        amount > 0;                   -- Excludes zero amounts to avoid spurious matches
END;
GO

-- Execute the procedure to detect similar transaction amounts in sequence
EXEC sp_alertas_montos_similares;
GO

-- =============================================
-- Stored Procedure: General Financial Summary
-- Description:
-- Returns a general summary of the transaction dataset, including:
-- - Total number of transactions
-- - Unique customers
-- - Total transaction amount
-- - Average ticket size
-- - Total fraud cases and fraud percentage
-- =============================================

IF OBJECT_ID('sp_resumen_general', 'P') IS NOT NULL
    DROP PROCEDURE sp_resumen_general;
GO

CREATE PROCEDURE sp_resumen_general
AS
BEGIN
    SELECT 
        COUNT(*) AS total_transactions,  -- Total number of transactions
        COUNT(DISTINCT customer_id) AS unique_customers,  -- Total unique customers
        ROUND(SUM(amount), 2) AS total_amount,  -- Total amount transacted
        ROUND(AVG(amount), 2) AS average_ticket,  -- Average transaction amount
        SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_cases,  -- Number of fraudulent transactions
        ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_percentage  -- % of frauds
    FROM transactions;
END;
GO

--  Execute the procedure to get financial summary
EXEC sp_resumen_general;
GO
