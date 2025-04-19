-- 1. Total of Transactions by Category
-- This query groups transactions by category,
-- counts the number of transactions, and sums the total amount per category.
-- Results are sorted in descending order by the number of transactions.
SELECT 
    category,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY category
ORDER BY total_transactions DESC;


-- 2. Customers with the Most Transactions
-- This query retrieves the customers with the highest number of transactions,
-- along with the total number of transactions and total amount per customer.
-- Only the top 10 customers are shown.

SELECT 
    customer_id,
    COUNT(*) AS num_transactions,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY customer_id
ORDER BY num_transactions DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;


-- 3. Classification of Transactions by Amount
-- This query classifies transactions into three ranges based on their amount:
-- 'Low (<$50)', 'Medium ($50-$200)', and 'High (>$200)'.
SELECT 
    CASE 
        WHEN amount < 50 THEN 'Low (<$50)'
        WHEN amount BETWEEN 50 AND 200 THEN 'Medium ($50-$200)'
        ELSE 'High (>$200)'
    END AS amount_range,
    COUNT(*) AS quantity
FROM transactions
GROUP BY 
    CASE 
        WHEN amount < 50 THEN 'Low (<$50)'
        WHEN amount BETWEEN 50 AND 200 THEN 'Medium ($50-$200)'
        ELSE 'High (>$200)'
    END;


-- 4. Categories with the Most Fraud
-- This query shows, for each category, the total transactions,
-- number of fraudulent transactions, and the fraud percentage.
-- The results are ordered by the fraud percentage in descending order.
SELECT 
    category,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS frauds,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_percentage
FROM transactions
GROUP BY category
ORDER BY fraud_percentage DESC;


-- 5. Customers with the Most Fraudulent Transactions
-- This query identifies customers with the highest count of fraudulent transactions,
-- along with the total fraud amount per customer.
-- Only the top 10 customers are displayed.
SELECT 
    customer_id,
    COUNT(*) AS total_frauds,
    SUM(amount) AS total_amount
FROM transactions
WHERE is_fraud = 1
GROUP BY customer_id
ORDER BY total_frauds DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;


-- 6. Overall Fraud Percentage
-- This query calculates the overall fraud percentage in the transactions table,
-- displaying total transactions, total frauds, and the computed fraud percentage.
SELECT 
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS total_frauds,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_percentage
FROM transactions;
