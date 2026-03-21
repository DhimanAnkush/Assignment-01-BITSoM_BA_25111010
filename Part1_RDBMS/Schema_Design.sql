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