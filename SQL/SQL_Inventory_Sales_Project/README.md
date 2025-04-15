Inventory and Sales Management Project – SQL

📌 Project Overview
This SQL project simulates a retail company's operations through analysis of sales, customers, products, shipping, and delivery data. Using a normalized relational database, it allows business-driven insights into sales performance, inventory rotation, shipping efficiency, and customer behavior.
The dataset comes from DataCo Supply Chain Dataset, containing more than 180,000 sales orders with rich attributes.
________________________________________
🧠 Business Objectives
•	Analyze regional and product-level sales performance
•	Identify best-selling and high-margin products
•	Measure delayed deliveries and shipping mode efficiency
•	Profile customer behavior and spending
________________________________________
🗂️ Project Structure
SQL_Inventory_Sales_Analysis/
├── data/
│   └── DataCoSupplyChainDataset.csv
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_insert_data.sql
│   ├── 03_transform_columns.sql
│   ├── 04_analysis_queries.sql
├── docs/
│   └── README.md
________________________________________
🧱 Database Design
Tables Created
•	staging_dataco: Original raw import of the CSV
•	customers: Customer ID, name, segment, country
•	products: Product name, category, subcategory, price
•	orders: Order ID, date, region, sales, profit, shipping, delivery risk
•	order_details: Product ID, quantity, discount, links orders with products
________________________________________
🔄 Data Flow
1.	Raw CSV imported to staging_dataco
2.	Normalized tables populated from staging
3.	Column transformation for consistency (order_region, etc.)
________________________________________
📊 Query Blocks (04_analysis_queries.sql)
🔹 Sales Analysis
•	Total sales by region:
•	SELECT order_region, SUM(sales) FROM orders GROUP BY order_region;
•	Top 10 best-selling products by quantity:
•	JOIN orders + order_details + products
•	GROUP BY product_name ORDER BY SUM(quantity)
•	Top spending customers:
•	JOIN orders + customers
•	GROUP BY customer_name ORDER BY SUM(sales)
•	Profit margin by product:
•	SUM(profit) / SUM(sales) per product
🔹 Inventory and Logistics Analysis
•	Products with high sales but low margin
•	Delivery risk by region (late_delivery_risk)
•	Shipping mode comparison (costs + delays)
________________________________________
📈 Query Enhancements
To make the queries more efficient and focused:
•	Filters like OFFSET 0 ROWS FETCH NEXT 10 added for top-N reports
•	New queries:
o	Sales by country
o	Products with discounts over 15%
o	Shipping mode profitability
o	Customers with most orders + highest spend
________________________________________
✅ Key Learnings and Highlights
•	Data modeling from unstructured CSV to normalized SQL schema
•	Working with foreign keys, data transformation
•	Use of aggregations, filters, CASE, and JOINs
•	Clear, structured modular file separation (one phase per file)
________________________________________
📎 Dataset Source
•	Name: DataCoSupplyChainDataset.csv
•	Public dataset found on Kaggle/Mendeley Data
•	Includes 180K+ records covering orders, customers, products, shipping
________________________________________
🚀 Author Notes:

This project was built in SQL Server Management Studio, covering structured data loading, table creation, data cleaning, and business queries. It’s designed as a professional SQL portfolio piece simulating a real-world retail analytics system.
