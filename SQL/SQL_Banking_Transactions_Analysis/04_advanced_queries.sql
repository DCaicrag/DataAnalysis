-- 1. Customers with Multiple Consecutive Decreasing Amount Patterns
-- This query identifies customers whose transaction amounts show a pattern of consecutive decreases.
-- It uses window functions (LAG) to compare the current transaction amount with the previous two.
-- Customers with at least 3 occurrences of such a pattern are returned.
WITH montos AS (
    SELECT 
        customer_id,
        step,
        amount,
        LAG(amount, 1) OVER (PARTITION BY customer_id ORDER BY step) AS amt_1,
        LAG(amount, 2) OVER (PARTITION BY customer_id ORDER BY step) AS amt_2
    FROM transactions
),
patrones AS (
    SELECT customer_id
    FROM montos
    WHERE amount < amt_1 AND amt_1 < amt_2
)
SELECT customer_id, COUNT(*) AS consecutive_decreasing_patterns
FROM patrones
GROUP BY customer_id
HAVING COUNT(*) >= 3
ORDER BY consecutive_decreasing_patterns DESC;


-- 2. Customers with at Least 2 Consecutive Transactions of the Same Amount
-- This query finds transactions where a customer’s current transaction amount equals the previous one.
-- It uses the LAG window function to compare consecutive transactions.
WITH movs AS (
    SELECT *,
           LAG(amount, 1) OVER (PARTITION BY customer_id ORDER BY step) AS amt_1
    FROM transactions
)
SELECT *
FROM movs
WHERE amount = amt_1 AND amount > 0
ORDER BY customer_id, step;


-- 3. Customer Cohorts Based on Their First Transaction
-- This query first determines the first transaction (step) for each customer.
-- Then, it groups customers into cohorts based on that first transaction and tracks their subsequent activity over time.
WITH primera_compra AS (
    SELECT 
        customer_id,
        MIN(step) AS primer_step
    FROM transactions
    GROUP BY customer_id
),
cohorte_actividad AS (
    SELECT 
        t.customer_id,
        p.primer_step AS cohort,
        t.step,
        COUNT(*) AS num_transactions
    FROM transactions t
    JOIN primera_compra p ON t.customer_id = p.customer_id
    GROUP BY t.customer_id, p.primer_step, t.step
)
SELECT cohort, step, COUNT(DISTINCT customer_id) AS active_customers
FROM cohorte_actividad
GROUP BY cohort, step
ORDER BY cohort, step;


-- 4. Basic Estimation of LTV by Customer
-- This query calculates key metrics for each customer based on non-fraudulent transactions:
-- the number of transactions, the average transaction amount (ticket), and the total amount spent.
-- The results are ordered by the total amount spent, showing only the top 10 customers.
SELECT 
    customer_id,
    COUNT(*) AS transactions,
    ROUND(AVG(amount), 2) AS average_ticket,
    ROUND(SUM(amount), 2) AS total_spent
FROM transactions
WHERE is_fraud = 0
GROUP BY customer_id
ORDER BY total_spent DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;


-- 5. Customers with More than 20% Fraudulent Transactions
-- This query identifies customers whose proportion of fraudulent transactions exceeds 20%.
-- It calculates the total transactions, the number of fraudulent transactions, and the fraud percentage.
-- Results are ordered by fraud percentage in descending order.
SELECT 
    customer_id,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_percentage
FROM transactions
GROUP BY customer_id
HAVING SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) > 0.20
ORDER BY fraud_percentage DESC;


-- 6. Customers with Consecutively Decreasing Spending in 3 Steps
-- This query (similar to query 1) returns all details for transactions where the spending shows a consecutive decrease.
-- It uses window functions to capture the pattern and orders the results for review.
WITH montos AS (
    SELECT 
        customer_id,
        step,
        amount,
        LAG(amount, 1) OVER (PARTITION BY customer_id ORDER BY step) AS amt_1,
        LAG(amount, 2) OVER (PARTITION BY customer_id ORDER BY step) AS amt_2
    FROM transactions
)
SELECT *
FROM montos
WHERE amount < amt_1 AND amt_1 < amt_2
ORDER BY customer_id, step;

