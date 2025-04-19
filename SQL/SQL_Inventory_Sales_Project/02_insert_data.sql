CREATE TABLE staging_dataco (
    [Type] VARCHAR(50),
    [Days_for_shipping_real] INT,
    [Days_for_shipment_scheduled] INT,
    [Benefit_per_order] DECIMAL(12, 2),
    [Sales_per_customer] DECIMAL(12, 2),
    [Delivery_Status] VARCHAR(50),
    [Late_delivery_risk] INT,
    [Category_Id] INT,
    [Category_Name] VARCHAR(100),
    
    [Customer_City] VARCHAR(100),
    [Customer_Country] VARCHAR(100),
    [Customer_Email] VARCHAR(100),
    [Customer_Fname] VARCHAR(100),
    [Customer_Id] VARCHAR(50),
    [Customer_Lname] VARCHAR(100),
    [Customer_Password] VARCHAR(100),
    [Customer_Segment] VARCHAR(50),
    [Customer_State] VARCHAR(50),
    [Customer_Street] VARCHAR(255),
    [Customer_Zipcode] VARCHAR(20),
    
    [Department_Id] INT,
    [Department_Name] VARCHAR(100),
    [Latitude] FLOAT,
    [Longitude] FLOAT,
    
    [Market] VARCHAR(50),
    [Order_City] VARCHAR(100),
    [Order_Country] VARCHAR(100),
    [Order_Customer_Id] VARCHAR(50),
    [Order_Date] DATETIME,
    [Order_Id] INT,
    
    [Order_Item_Cardprod_Id] INT,
    [Order_Item_Discount] DECIMAL(12, 2),
    [Order_Item_Discount_Rate] DECIMAL(5, 4),
    [Order_Item_Id] INT,
    [Order_Item_Product_Price] DECIMAL(12, 2),
    [Order_Item_Profit_Ratio] DECIMAL(5, 4),
    [Order_Item_Quantity] INT,
    
    [Sales] DECIMAL(12, 2),
    [Order_Item_Total] DECIMAL(12, 2),
    [Order_Profit_Per_Order] DECIMAL(12, 2),
    
    [Order_Region] VARCHAR(100),
    [Order_State] VARCHAR(100),
    [Order_Status] VARCHAR(50),
    [Order_Zipcode] VARCHAR(20),
    
    [Product_Card_Id] INT,
    [Product_Category_Id] INT,
    [Product_Description] VARCHAR(255),
    [Product_Name] VARCHAR(255),
    [Product_Price] DECIMAL(12, 2),
    [Product_Status] INT,
    
    [Shipping_Date] DATETIME,
    [Shipping_Mode] VARCHAR(50)
);



INSERT INTO customers
SELECT DISTINCT
    customer_id,
    customer_fname,
    customer_lname,
    customer_segment,
    customer_country,
    customer_city,
    customer_state,
    customer_zipcode,
    customer_street
FROM staging_dataco
WHERE customer_id IS NOT NULL;

INSERT INTO products
SELECT DISTINCT
    order_item_cardprod_id AS product_id,
    product_name,
    category_name,
    order_item_product_price AS unit_price
FROM staging_dataco
WHERE order_item_cardprod_id IS NOT NULL;

PRINT 'Insertando en ORDERS...';

INSERT INTO orders
SELECT
    Order_Id AS order_id,
    MIN(Order_Date) AS order_date,
    MIN(Customer_Id) AS customer_id,
    SUM(Sales) AS sales,
    SUM(Order_Profit_Per_Order) AS profit,
    MIN(Shipping_Mode) AS ship_mode,
    MIN(Late_Delivery_Risk) AS late_delivery_risk
FROM staging_dataco
WHERE Order_Id IS NOT NULL
GROUP BY Order_Id;

PRINT 'Insertando en ORDER_DETAILS...';

INSERT INTO order_details
SELECT
    Order_Item_Id AS order_detail_id,
    Order_Id AS order_id,
    Order_Item_Cardprod_Id AS product_id,
    Order_Item_Quantity AS quantity,
    Order_Item_Discount AS discount,
    Order_Item_Discount_Rate AS discount_rate
FROM staging_dataco
WHERE Order_Item_Id IS NOT NULL
  AND Order_Id IN (SELECT order_id FROM orders)
  AND Order_Item_Cardprod_Id IN (SELECT product_id FROM products);


PRINT 'Verificando resultados...';

SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_order_details FROM order_details;



