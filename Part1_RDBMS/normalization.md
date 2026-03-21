1.1
Anomaly Analysis

Insert Anomaly: We cannot add a new Product to the system (e.g., a "Webcam" with product_id P010) until someone actually places an order for it. 
Since order_id is the primary record key, storing a product without an order would require null values or dummy data in order-related columns.

Update Anomaly: Priya Sharma (C002) appears in multiple rows (e.g., Row 0 and Row 3). 
If she changes her email address, we must update it in every single row where she has an order. 
If Row 0 is updated but Row 3 is missed, the database will contain conflicting information for the same customer.

Delete Anomaly: If Vikram Singh (C005) has only one order in the system (e.g., ORD1075 in Row 7) 
and that order is deleted due to a cancellation, we lose all information about Vikram (his email and city) as well.

1.2

-- Create Customers Table
CREATE TABLE Customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) UNIQUE NOT NULL,
    customer_city VARCHAR(50) NOT NULL
);

-- Create Products Table
CREATE TABLE Products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);

-- Create SalesReps Table
CREATE TABLE SalesReps (
    sales_rep_id VARCHAR(10) PRIMARY KEY,
    sales_rep_name VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(100) UNIQUE NOT NULL,
    office_address TEXT NOT NULL
);

-- Create Orders Table
CREATE TABLE Orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    sales_rep_id VARCHAR(10) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (sales_rep_id) REFERENCES SalesReps(sales_rep_id)
);

-- Populating Data
INSERT INTO Customers VALUES 
('C001', 'Rohan Mehta', 'rohan@gmail.com', 'Mumbai'),
('C002', 'Priya Sharma', 'priya@gmail.com', 'Delhi'),
('C003', 'Amit Verma', 'amit@gmail.com', 'Bangalore'),
('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai'),
('C006', 'Neha Gupta', 'neha@gmail.com', 'Delhi');

INSERT INTO Products VALUES 
('P001', 'Laptop', 'Electronics', 55000),
('P002', 'Mouse', 'Electronics', 800),
('P003', 'Desk Chair', 'Furniture', 8500),
('P004', 'Notebook', 'Stationery', 120),
('P007', 'Pen Set', 'Stationery', 250);

INSERT INTO SalesReps VALUES 
('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021'),
('SR02', 'Anita Desai', 'anita@corp.com', 'Delhi Office, Connaught Place, New Delhi - 110001'),
('SR03', 'Ravi Kumar', 'ravi@corp.com', 'South Zone, MG Road, Bangalore - 560001'),
('SR04', 'Sita Ram', 'sita@corp.com', 'Kolkata Hub, Salt Lake, Kolkata - 700091'),
('SR05', 'Karan Johar', 'karan@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021');

INSERT INTO Orders VALUES 
('ORD1027', 'C002', 'P004', 'SR02', 4, '2023-11-02'),
('ORD1114', 'C001', 'P007', 'SR01', 2, '2023-08-06'),
('ORD1153', 'C006', 'P007', 'SR01', 3, '2023-02-14'),
('ORD1002', 'C002', 'P005', 'SR02', 1, '2023-01-17'),
('ORD1075', 'C005', 'P003', 'SR03', 3, '2023-04-18');

[Schema_Design.sql](https://github.com/user-attachments/files/26156562/Schema_Design.sql)
le


1.3


-- Q1: List all customers from Mumbai along with their total order value
SELECT c.customer_name, SUM(o.quantity * p.unit_price) AS total_order_value
FROM customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Products p ON o.product_id = p.product_id
WHERE c.customer_city = 'Mumbai'
GROUP BY c.customer_id, c.customer_name;

-- Q2: Find the top 3 products by total quantity sold
SELECT p.product_name, SUM(o.quantity) AS total_sold
FROM Products p
JOIN Orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 3;

-- Q3: List all sales representatives and the number of unique customers they have handled
SELECT s.sales_rep_name, COUNT(DISTINCT o.customer_id) AS unique_customers
FROM SalesReps s
LEFT JOIN Orders o ON s.sales_rep_id = o.sales_rep_id
GROUP BY s.sales_rep_id, s.sales_rep_name;

-- Q4: Find all orders where the total value exceeds 10,000, sorted by value descending
SELECT o.order_id, (o.quantity * p.unit_price) AS order_total
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
WHERE (o.quantity * p.unit_price) > 10000
ORDER BY order_total DESC;

-- Q5: Identify any products that have never been ordered
SELECT p.product_name
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

[queries.sql](https://github.com/user-attachments/files/26156554/queries.sql)


Normalization Justification

The argument that a single flat table is "simpler" is a common misconception that prioritizes initial setup speed over long-term data integrity and system scalability. While a flat file like orders_flat.csv is easy to read at a glance, it is fundamentally flawed for a growing business.

Data Integrity and Redundancy: In the current dataset, customer details for Rohan Mehta (C001) are duplicated across every order he places. If the company needs to update his email address, an administrator must update dozens of rows. If even one row is missed, the system enters an inconsistent state where the "source of truth" is lost. Normalization to 3NF ensures that each piece of information (like a customer's email or a product's price) is stored in exactly one place.

Operational Limitations: The flat structure prevents basic business operations. For example, we cannot store information about a new Sales Representative or a New Product until a sale occurs. If we delete a customer's only order, we accidentally erase the customer's contact history from our database. By separating these into Customers, Products, and SalesReps tables, we can manage our assets and personnel independently of sales transactions.

Normalization is not over-engineering; it is a necessary architectural step to prevent data corruption, reduce storage waste, and provide a reliable foundation for business reporting.
