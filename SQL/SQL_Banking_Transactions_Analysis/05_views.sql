-- View: Transactions Summary by Category
-- This view aggregates transaction data by category.
-- It calculates the total number of transactions, the total and average amount,
-- the total number of fraudulent transactions, and the fraud percentage for each category.
CREATE VIEW vw_transacciones_por_categoria AS
SELECT 
    category,
    COUNT(*) AS total_transacciones,  -- Total number of transactions per category
    SUM(amount) AS total_monto,         -- Total amount of transactions per category
    ROUND(AVG(amount), 2) AS promedio_monto,  -- Average transaction amount per category (rounded)
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS total_fraudes,  -- Total fraud cases per category
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS porcentaje_fraude  -- Fraud percentage (rounded)
FROM transactions
GROUP BY category;


-- View: Customers with Repeated Transactions of the Same Amount
-- This view identifies customers who have consecutive transactions with the same amount.
-- It uses window functions (LAG) to compare the current transaction amount with the previous two transactions.
CREATE VIEW vw_patrones_repetidos AS
WITH movs AS (
    SELECT *,
        LAG(amount, 1) OVER (PARTITION BY customer_id ORDER BY step) AS amt_1,  -- Previous transaction amount
        LAG(amount, 2) OVER (PARTITION BY customer_id ORDER BY step) AS amt_2   -- Amount two transactions ago
    FROM transactions
)
SELECT customer_id, step, amount
FROM movs
WHERE amount = amt_1 AND amt_1 = amt_2;  -- Identifies cases where the amount is repeated in 3 consecutive transactions


-- View: Top Customers by Total Value (LTV) – Without ORDER BY in the view
-- This view calculates, for each customer, the number of non-fraudulent transactions,
-- the average ticket (transaction amount), and the total spent.
-- Only customers with a total spent greater than 500 are included.
CREATE VIEW vw_top_clientes_ltv AS
SELECT 
    customer_id,
    COUNT(*) AS num_transacciones,                -- Total non-fraudulent transactions per customer
    ROUND(AVG(amount), 2) AS ticket_promedio,       -- Average transaction amount (ticket) per customer
    ROUND(SUM(amount), 2) AS total_gastado          -- Total amount spent by the customer
FROM transactions
WHERE is_fraud = 0
GROUP BY customer_id
HAVING SUM(amount) > 500;  -- Filter: only include customers with total spent > 500

-- To display the top customers by total spent, order the view results:
SELECT *
FROM vw_top_clientes_ltv
ORDER BY total_gastado DESC;


-- View: Customers with Multiple Consecutive Decreasing Patterns
-- This view identifies customers whose transaction amounts decrease consecutively (over at least 3 steps).
-- It uses window functions (LAG) to compare current and previous amounts and counts the occurrences.
CREATE VIEW vw_conducta_decreciente AS
WITH montos AS (
    SELECT 
        customer_id,
        step,
        amount,
        LAG(amount, 1) OVER (PARTITION BY customer_id ORDER BY step) AS amt_1,  -- Amount from previous transaction
        LAG(amount, 2) OVER (PARTITION BY customer_id ORDER BY step) AS amt_2   -- Amount from two transactions ago
    FROM transactions
),
patrones AS (
    SELECT customer_id
    FROM montos
    WHERE amount < amt_1 AND amt_1 < amt_2  -- Condition: consecutive decrease in amounts
)
SELECT customer_id, COUNT(*) AS veces_decreciente  -- Count the occurrences per customer
FROM patrones
GROUP BY customer_id
HAVING COUNT(*) >= 3;  -- Only include customers with at least 3 decreasing patterns


-- Example Queries to Review the Views
-- Display data from the top customers view
SELECT * FROM vw_top_clientes_ltv;

-- Display data from the transactions summary by category view
SELECT * FROM vw_transacciones_por_categoria;

