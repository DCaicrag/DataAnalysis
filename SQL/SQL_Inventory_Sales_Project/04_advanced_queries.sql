-- =============================
-- 1. TOP productos por ingresos mensuales (TOP 3 por mes)
-- =============================

WITH ventas_mensuales AS (
    SELECT 
        FORMAT(o.order_date, 'yyyy-MM') AS mes,
        p.product_name,
        SUM(o.sales) AS total_ventas
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY FORMAT(o.order_date, 'yyyy-MM'), p.product_name
),
ranking_mensual AS (
    SELECT *,
        RANK() OVER (PARTITION BY mes ORDER BY total_ventas DESC) AS ranking
    FROM ventas_mensuales
)
SELECT *
FROM ranking_mensual
WHERE ranking <= 3
ORDER BY mes, ranking;


-- =============================
-- 2. Análisis de cohortes (clientes agrupados por su primer mes de compra)
-- =============================

WITH primera_compra AS (
    SELECT 
        customer_id,
        MIN(order_date) AS fecha_primera_compra
    FROM orders
    GROUP BY customer_id
),
cohorte_ordenes AS (
    SELECT 
        o.customer_id,
        FORMAT(p.fecha_primera_compra, 'yyyy-MM') AS cohorte,
        FORMAT(o.order_date, 'yyyy-MM') AS mes_orden,
        COUNT(DISTINCT o.order_id) AS num_ordenes
    FROM orders o
    JOIN primera_compra p ON o.customer_id = p.customer_id
    GROUP BY o.customer_id, p.fecha_primera_compra, o.order_date
)
SELECT cohorte, mes_orden, COUNT(DISTINCT customer_id) AS clientes_activos
FROM cohorte_ordenes
GROUP BY cohorte, mes_orden
ORDER BY cohorte, mes_orden;


-- =============================
-- 3. Análisis RFM de clientes
-- =============================

WITH base_rfm AS (
    SELECT 
        customer_id,
        MAX(order_date) AS ultima_compra,
        COUNT(order_id) AS frecuencia,
        SUM(sales) AS valor_monetario
    FROM orders
    GROUP BY customer_id
),
hoy AS (
    SELECT DATEADD(DAY, 1, MAX(order_date)) AS fecha_actual
    FROM orders
)
SELECT 
    r.customer_id,
    DATEDIFF(DAY, r.ultima_compra, h.fecha_actual) AS recencia,
    r.frecuencia,
    ROUND(r.valor_monetario, 2) AS valor_monetario
FROM base_rfm r
CROSS JOIN hoy h
ORDER BY recencia ASC, frecuencia DESC, valor_monetario DESC;


-- =============================
-- 3a. RFM de clientes activos (frecuencia >= 5)
-- =============================

WITH base_rfm AS (
    SELECT 
        customer_id,
        MAX(order_date) AS ultima_compra,
        COUNT(order_id) AS frecuencia,
        SUM(sales) AS valor_monetario
    FROM orders
    GROUP BY customer_id
),
hoy AS (
    SELECT DATEADD(DAY, 1, MAX(order_date)) AS fecha_actual
    FROM orders
)
SELECT 
    r.customer_id,
    DATEDIFF(DAY, r.ultima_compra, h.fecha_actual) AS recencia,
    r.frecuencia,
    ROUND(r.valor_monetario, 2) AS valor_monetario
FROM base_rfm r
CROSS JOIN hoy h
WHERE r.frecuencia >= 5
ORDER BY recencia ASC, frecuencia DESC;


-- =============================
-- 4a. LTV de clientes con ingresos totales > $500
-- =============================

SELECT 
    customer_id,
    COUNT(DISTINCT order_id) AS frecuencia,
    ROUND(AVG(sales), 2) AS ticket_promedio,
    ROUND(SUM(sales), 2) AS ingresos_totales
FROM orders
GROUP BY customer_id
HAVING SUM(sales) > 500
ORDER BY ingresos_totales DESC;

-- =============================
-- 5a. Productos populares pero con margen bajo (<10%)
-- =============================

SELECT 
    p.product_name,
    SUM(od.quantity) AS total_unidades,
    ROUND(SUM(o.profit) / NULLIF(SUM(o.sales), 0), 4) AS margen
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(od.quantity) > 20 AND (SUM(o.profit) / NULLIF(SUM(o.sales), 0)) < 0.10
ORDER BY total_unidades DESC;

-- =============================
-- 6a. Análisis de entregas tardías para productos premium (> $300)
-- =============================

SELECT 
    o.ship_mode,
    COUNT(*) AS total_envios,
    SUM(CASE WHEN o.late_delivery_risk = 1 THEN 1 ELSE 0 END) AS retrasos,
    ROUND(SUM(CASE WHEN o.late_delivery_risk = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_retraso
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
WHERE p.unit_price > 300
GROUP BY o.ship_mode
ORDER BY pct_retraso DESC;


-- =============================
-- 7a. Clientes con descuentos promedio altos (> 15%)
-- =============================

SELECT 
    o.customer_id,
    ROUND(AVG(od.discount_rate), 4) AS promedio_descuento,
    COUNT(*) AS items_comprados
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY o.customer_id
HAVING AVG(od.discount_rate) > 0.15
ORDER BY promedio_descuento DESC;



