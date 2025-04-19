-- Base de datos: InventorySalesDB
-- Script: Crear tablas

-- Tabla 1: Clientes
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_fname VARCHAR(100),
    customer_lname VARCHAR(100),
    customer_segment VARCHAR(50),
    customer_country VARCHAR(50),
    customer_city VARCHAR(50),
    customer_state VARCHAR(50),
    customer_zipcode VARCHAR(20),
    customer_street VARCHAR(255)
);

-- Tabla 2: Productos
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category_name VARCHAR(100),
    unit_price DECIMAL(10, 2)
);

-- Tabla 3: Órdenes
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATETIME,
    customer_id VARCHAR(50),
    sales DECIMAL(12,2),
    profit DECIMAL(12,2),
    ship_mode VARCHAR(50),
    late_delivery_risk INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Tabla 4: Detalles de la orden
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    discount DECIMAL(10,2),
    discount_rate DECIMAL(5,4),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Verificar si se crearon
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
