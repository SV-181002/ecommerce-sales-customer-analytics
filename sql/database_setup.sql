CREATE DATABASE IF NOT EXISTS ecommerce_analysis;

USE ecommerce_analysis;

CREATE TABLE IF NOT EXISTS sales (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10,2),
    CustomerID VARCHAR(20),
    Country VARCHAR(100),
    Revenue DECIMAL(12,2)
);

CREATE TABLE IF NOT EXISTS customers AS
SELECT DISTINCT
    CustomerID,
    Country
FROM sales
WHERE CustomerID IS NOT NULL;

CREATE TABLE IF NOT EXISTS products AS
SELECT DISTINCT
    StockCode,
    Description
FROM sales
WHERE StockCode IS NOT NULL;