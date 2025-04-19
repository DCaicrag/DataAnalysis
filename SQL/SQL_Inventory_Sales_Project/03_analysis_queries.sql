-- =============================
-- Proyecto: Inventory & Sales
-- Archivo: 03_analysis_queries.sql
-- Descripción: Consultas de análisis de negocio
-- =============================

-- =============================
-- 1. Ventas por Región
-- =============================

SELECT 
    o.order_region,
    SUM(o.sales) AS total_sales
FROM orders o
GROUP BY o.order_region
ORDER BY total_sales DESC;

-- =============================
-- 2. Productos más vendidos (por cantidad)
-- =============================

SELECT 
    p.product_name,
    SUM(od.quantity) AS total_units_sold
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units_sold DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY; -- TOP 10

-- =============================
-- 3. Clientes que más han gastado
-- =============================

SELECT 
    c.customer_fname + ' ' + c.customer_lname AS customer_name,
    SUM(o.sales) AS total_spent,
    COUNT(o.order_id) AS num_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_fname, c.customer_lname
ORDER BY total_spent DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- =============================
-- 4. Margen de ganancia por producto
-- =============================

SELECT 
    p.product_name,
    SUM(o.profit) AS total_profit,
    SUM(o.sales) AS total_sales,
    ROUND(SUM(o.profit) * 1.0 / NULLIF(SUM(o.sales), 0), 4) AS profit_margin
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY profit_margin DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- =============================
-- 5. Porcentaje de entregas con riesgo de retraso por región
-- =============================

SELECT 
    o.order_region,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN o.late_delivery_risk = 1 THEN 1 ELSE 0 END) AS at_risk_deliveries,
    ROUND(SUM(CASE WHEN o.late_delivery_risk = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_delivery_pct
FROM orders o
GROUP BY o.order_region
ORDER BY late_delivery_pct DESC;


-- =============================
-- 6. Total de ventas por país
-- =============================

SELECT 
    c.customer_country,
    SUM(o.sales) AS total_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_country
ORDER BY total_sales DESC;

-- =============================
-- 7. Comparativa de ventas por modo de envío
-- =============================

SELECT 
    ship_mode,
    COUNT(*) AS total_envios,
    SUM(sales) AS total_sales,
    ROUND(AVG(sales), 2) AS avg_order_value
FROM orders
GROUP BY ship_mode
ORDER BY total_sales DESC;

-- =============================
-- 8. Porcentaje de productos con descuentos altos (> 20%)
-- =============================

SELECT 
    COUNT(*) AS total_items,
    SUM(CASE WHEN discount_rate > 0.20 THEN 1 ELSE 0 END) AS high_discount_items,
    ROUND(SUM(CASE WHEN discount_rate > 0.20 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS high_discount_pct
FROM order_details;










