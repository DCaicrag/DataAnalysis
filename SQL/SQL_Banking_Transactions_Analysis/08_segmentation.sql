-- 1. Segmentation by Transaction Frequency
-- This query groups transactions by customer_id and counts the total transactions.
-- It then classifies customers into segments based on the frequency of their transactions:
-- 'Muy activo' (>=200), 'Activo' (100-199), 'Moderado' (50-99), or 'Bajo uso' (less than 50).
SELECT 
    customer_id,
    COUNT(*) AS transacciones,  -- Total transactions per customer
    CASE 
        WHEN COUNT(*) >= 200 THEN 'Muy activo'
        WHEN COUNT(*) BETWEEN 100 AND 199 THEN 'Activo'
        WHEN COUNT(*) BETWEEN 50 AND 99 THEN 'Moderado'
        ELSE 'Bajo uso'
    END AS segmento_frecuencia  -- Frequency-based segmentation label
FROM transactions
GROUP BY customer_id;


-- 2. Segmentation by Total Spending Volume
-- This query aggregates transactions per customer to obtain the total spending.
-- It then assigns a segment based on the total spent:
-- 'Alto valor' (total > 5000), 'Medio valor' (total between 2000 and 5000), or 'Bajo valor' (total <= 2000).
SELECT 
    customer_id,
    SUM(amount) AS total_gastado,  -- Total amount spent by each customer
    CASE 
        WHEN SUM(amount) > 5000 THEN 'Alto valor'
        WHEN SUM(amount) BETWEEN 2000 AND 5000 THEN 'Medio valor'
        ELSE 'Bajo valor'
    END AS segmento_valor  -- Spending-based segmentation label
FROM transactions
GROUP BY customer_id;


-- 3. Segmentation by Fraud Risk
-- This query computes, for each customer, the total number of transactions and the number of fraudulent transactions.
-- It then calculates the fraud percentage and assigns a risk segment:
-- 'Riesgo Alto' (fraud ratio >= 20%), 'Riesgo Medio' (fraud ratio >= 5%), or 'Riesgo Bajo' (fraud ratio < 5%).
SELECT 
    customer_id,
    COUNT(*) AS total_transacciones,  -- Total transactions per customer
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraudes,  -- Fraud count per customer
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS porcentaje_fraude,  -- Fraud percentage
    CASE 
        WHEN SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) >= 0.20 THEN 'Riesgo Alto'
        WHEN SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) >= 0.05 THEN 'Riesgo Medio'
        ELSE 'Riesgo Bajo'
    END AS segmento_riesgo  -- Fraud risk segmentation label
FROM transactions
GROUP BY customer_id;


-- 4. Cross-Segmentation: Frequency and Spending
-- This query combines the frequency and spending segments into a final segmentation.
-- Two common table expressions (CTEs) are used:
-- "frecuencia" calculates the transaction frequency segmentation for each customer.
-- "valor" calculates the total spending segmentation for each customer.
-- The final SELECT joins both CTEs and concatenates the segmentation labels to form a composite segment.
WITH frecuencia AS (
    SELECT 
        customer_id,
        COUNT(*) AS transacciones,
        CASE 
            WHEN COUNT(*) >= 200 THEN 'Muy activo'
            WHEN COUNT(*) BETWEEN 100 AND 199 THEN 'Activo'
            WHEN COUNT(*) BETWEEN 50 AND 99 THEN 'Moderado'
            ELSE 'Bajo uso'
        END AS nivel_actividad  -- Activity level based on transaction count
    FROM transactions
    GROUP BY customer_id
),
valor AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_gastado,
        CASE 
            WHEN SUM(amount) > 5000 THEN 'Alto valor'
            WHEN SUM(amount) BETWEEN 2000 AND 5000 THEN 'Medio valor'
            ELSE 'Bajo valor'
        END AS nivel_valor  -- Spending level based on total amount spent
    FROM transactions
    GROUP BY customer_id
)
SELECT 
    f.customer_id,
    f.nivel_actividad,          -- Activity level label from frequency segmentation
    v.nivel_valor,              -- Spending level label from value segmentation
    CONCAT(f.nivel_actividad, ' / ', v.nivel_valor) AS segmento_final  -- Combined final segmentation
FROM frecuencia f
JOIN valor v ON f.customer_id = v.customer_id
ORDER BY segmento_final;
