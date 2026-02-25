CREATE DATABASE superstore_sales_db;

USE superstore_sales_db;

CREATE TABLE superstore (
Row_ID INT,
Order_ID VARCHAR(20),
Order_Date DATE,
Ship_Date DATE,
Ship_Mode VARCHAR(50),
Customer_ID VARCHAR(20),
Customer_Name VARCHAR(100),
Segment VARCHAR(50),
Country VARCHAR(50),
City VARCHAR(50),
State VARCHAR(50),
Postal_Code VARCHAR(20),
Region VARCHAR(20),
Product_ID VARCHAR(20),
Category VARCHAR(50),
Sub_Category VARCHAR(50),
Product_Name VARCHAR(255),
Sales DECIMAL(10,2),
Quantity INT,
Discount DECIMAL(5,2),
Profit DECIMAL(10,2)
);

CREATE TABLE customers (
Customer_ID VARCHAR(20) PRIMARY KEY,
Customer_Name VARCHAR(100),
Segment VARCHAR(50),
Country VARCHAR(50),
City VARCHAR(50),
State VARCHAR(50),
Postal_Code VARCHAR(20),
Region VARCHAR(20)
);


INSERT INTO customers
SELECT
TRIM(Customer_ID),
MAX(Customer_Name),
MAX(Segment),
MAX(Country),
MAX(City),
MAX(State),
MAX(Postal_Code),
MAX(Region)
FROM superstore
GROUP BY TRIM(Customer_ID);

CREATE TABLE orders (
Row_ID INT PRIMARY KEY,
Order_ID VARCHAR(20),
Order_Date DATE,
Ship_Date DATE,
Ship_Mode VARCHAR(50),
Customer_ID VARCHAR(20),
Product_ID VARCHAR(20),
Category VARCHAR(50),
Sub_Category VARCHAR(50),
Product_Name VARCHAR(255),
Sales DECIMAL(10,2),
Quantity INT,
Discount DECIMAL(5,2),
Profit DECIMAL(10,2),

FOREIGN KEY (Customer_ID)
REFERENCES customers(Customer_ID)
);

INSERT INTO orders
SELECT
Row_ID,
Order_ID,
Order_Date,
Ship_Date,
Ship_Mode,
Customer_ID,
Product_ID,
Category,
Sub_Category,
Product_Name,
Sales,
Quantity,
Discount,
Profit
FROM superstore;


SELECT * FROM superstore;

SELECT * FROM customers;

SELECT * FROM Orders;


-- Total Sales of the Company
SELECT SUM(sales) AS total_sales FROM Orders;
-- Insight: Shows overall company revenue performance.


-- Total Number of Orders
SELECT  count(order_ID) AS total_count
FROM orders;

-- Total Customers
SELECT COUNT(*) AS total_customers
FROM Customers;

-- Average sales 
SELECT AVG(sales) AS average_sales
FROM orders;

-- Sales by Region
SELECT C.Region,sum(O.sales) AS total_sales
FROM customers C 
JOIN Orders O 
ON C.customer_ID = O.customer_ID
GROUP BY Region
ORDER BY total_Sales DESC;
-- Insight: Identify best performing region.

-- Sales by State
SELECT C.state,SUM(sales) AS total_sales
FROM customers C 
JOIN Orders O 
ON  C.customer_ID = O.customer_ID
GROUP BY state
ORDER BY total_Sales DESC;
-- Insight: Shows strongest markets.

-- Top 5 Cities
SELECT C.city,SUM(sales) AS total_sales
FROM customers C 
JOIN Orders O 
ON  C.customer_ID = O.customer_ID
GROUP BY city
ORDER BY total_Sales DESC
LIMIT 5;
-- Insight: Target these cities for marketing.


-- Top 10 Customers
SELECT C.customer_name,SUM(sales) AS total_sales
FROM customers C 
JOIN Orders O 
ON  C.customer_ID = O.customer_ID
GROUP BY customer_name
ORDER BY total_Sales DESC
LIMIT 10;
-- Insight: These customers generate highest revenue.

-- Sales by Segment
SELECT C.segment,SUM(O.sales) AS total_sales
FROM customers C 
JOIN Orders O 
ON C.Customer_ID = O.Customer_ID
GROUP BY segment
ORDER BY total_sales DESC;
-- Insight: Shows which customer type is most valuable.

-- Best Selling Category
SELECT DISTINCT category, SUM(sales) AS total_sales
FROM Orders
GROUP BY category
ORDER BY total_sales DESC;
-- Insight: Focus on high demand categories.

-- Best Selling Sub-Category
SELECT DISTINCT Sub_category, SUM(sales) AS total_sales
FROM Orders
GROUP BY Sub_category
ORDER BY total_sales DESC;
-- Insight: Helps inventory planning.

-- Top 10 Products
SELECT DISTINCT Product_name,SUM(sales) AS total_sales
FROM Orders
GROUP BY Product_name
ORDER BY total_sales DESC
LIMIT 10;
-- Insight: These products drive revenue.

-- Monthly Sales Trend
SELECT MONTH(order_date) AS month, SUM(sales) AS total_sales
FROM Orders
GROUP BY month
ORDER BY month;
-- Insight: Identify seasonal trends.

-- Yearly Sales Trend
SELECT YEAR(order_date) AS Year, SUM(sales) AS total_sales
FROM Orders
GROUP BY Year
ORDER BY Year;
-- Insight: Shows business growth.

-- Most Used Ship Mode
SELECT Ship_Mode, count(*) AS total_count
FROM orders
GROUP BY Ship_Mode
ORDER BY total_count DESC;
-- Insight: Shows customer shipping preference.


SELECT MIN(order_date), MAX(order_date)
FROM Orders;

-- Sales Contribution by Category %
SELECT category,
ROUND(SUM(sales)*100/(SELECT SUM(sales) FROM Orders),2)
AS percentage
FROM Orders
GROUP BY category;
-- Insight: Shows revenue contribution.

-- Average Sales per Customer
SELECT customer_id, AVG(sales)
FROM Orders
GROUP BY customer_id;

-- Region with Highest Orders
SELECT c.region, COUNT(order_id) AS order_count
FROM Orders o
JOIN Customers c 
ON o.customer_id=c.customer_id
GROUP BY region
ORDER BY order_count  DESC;
-- Insight: Shows highest demand region.

-- Top Category per Region
SELECT c.region, category, SUM(sales)
FROM Orders o
JOIN Customers c 
ON o.customer_id=c.customer_id
GROUP BY region, category;
-- Insight: Helps region-specific strategy.

-- Daily Sales
SELECT order_date, SUM(sales)
FROM Orders
GROUP BY order_date;

-- Insight: Shows daily performance