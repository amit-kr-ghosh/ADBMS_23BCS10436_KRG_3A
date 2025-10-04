--Problem 1------------------------------------------
CREATE TABLE transaction_data (
    id INT,
    value INT
);

INSERT INTO transaction_data (id, value)
SELECT 1, random() * 1000
FROM generate_series(1,1000000);

INSERT INTO transaction_data (id, value)
SELECT 2, random() * 1000
FROM generate_series(1,1000000);

CREATE OR REPLACE VIEW sales_summary_view AS
SELECT
    id,
    COUNT(*) AS total_orders,
    SUM(value) AS total_sales,
    AVG(value) AS avg_transaction
FROM transaction_data
GROUP BY id;

EXPLAIN ANALYZE
SELECT * FROM sales_summary_view;

CREATE OR REPLACE MATERIALIZED VIEW sales_summary_mv AS
SELECT
    id,
    COUNT(*) AS total_orders,
    SUM(value) AS total_sales,
    AVG(value) AS avg_transaction
FROM transaction_data
GROUP BY id;

EXPLAIN ANALYZE
SELECT * FROM sales_summary_mv;

REFRESH MATERIALIZED VIEW sales_summary_mv;

--Problem 2-----------------------------------------------------

CREATE TABLE customer_master (
    customer_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(50),
    city VARCHAR(30)
);

CREATE TABLE product_catalog (
    product_id VARCHAR(5) PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    brand VARCHAR(30),
    unit_price NUMERIC(10,2) NOT NULL
);

CREATE TABLE sales_orders (
    order_id SERIAL PRIMARY KEY,
    product_id VARCHAR(5) REFERENCES product_catalog(product_id),
    quantity INT NOT NULL,
    customer_id VARCHAR(5) REFERENCES customer_master(customer_id),
    discount_percent NUMERIC(5,2),
    order_date DATE NOT NULL
);

INSERT INTO customer_master VALUES
('C1', 'Amit Sharma', '9876543210', 'amit.sharma@example.com', 'Delhi'),
('C2', 'Priya Verma', '9876501234', 'priya.verma@example.com', 'Mumbai'),
('C3', 'Ravi Kumar', '9988776655', 'ravi.kumar@example.com', 'Bangalore');

INSERT INTO product_catalog VALUES
('P1', 'Smartphone X100', 'Samsung', 25000.00),
('P2', 'Laptop Pro 15', 'Dell', 65000.00),
('P3', 'Wireless Earbuds', 'Sony', 5000.00);

INSERT INTO sales_orders (product_id, quantity, customer_id, discount_percent, order_date) VALUES
('P1', 2, 'C1', 5.00, '2025-09-01'),
('P2', 1, 'C2', 10.00, '2025-09-02'),
('P3', 3, 'C3', 0.00, '2025-09-03');

CREATE VIEW vW_ORDER_SUMMARY AS
SELECT 
    O.order_id,
    O.order_date,
    P.product_name,
    C.full_name,
    (P.unit_price * O.quantity) - ((P.unit_price * O.quantity) * O.discount_percent / 100) AS final_cost
FROM customer_master AS C
JOIN sales_orders AS O ON O.customer_id = C.customer_id
JOIN product_catalog AS P ON P.product_id = O.product_id;

CREATE ROLE alok WITH LOGIN PASSWORD 'alok';
GRANT SELECT ON vW_ORDER_SUMMARY TO alok;
REVOKE SELECT ON vW_ORDER_SUMMARY FROM alok;

DROP TABLE IF EXISTS employee;

CREATE TABLE employee (
    empid INT PRIMARY KEY,
    name TEXT NOT NULL,
    dept TEXT NOT NULL
);

INSERT INTO employee VALUES (1, 'Clark', 'Sales'), (2, 'Dave', 'Accounting'), (3, 'Ava', 'Sales');

CREATE VIEW vW_STORE_SALES_DATA AS
SELECT empid, name, dept
FROM employee
WHERE dept = 'Sales'
WITH CHECK OPTION;
