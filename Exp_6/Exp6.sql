--Problem1-----------------------------------------------------------------
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    gender VARCHAR(10)
);

INSERT INTO employees (emp_name, gender) VALUES
('Amit Sharma', 'Male'),
('Priya Singh', 'Female'),
('Rohan Verma', 'Male'),
('Neha Gupta', 'Female'),
('Kunal Mehta', 'Male');

CREATE OR REPLACE PROCEDURE get_employee_count_by_gender(
    IN p_gender VARCHAR,
    OUT p_count INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COUNT(*) INTO p_count
    FROM employees
    WHERE gender = p_gender;
    RAISE NOTICE 'Total employees with gender %: %', p_gender, p_count;
END;
$$;

CALL get_employee_count_by_gender('Male', NULL);
CALL get_employee_count_by_gender('Female', NULL);

--Problem 2----------------------------------------------------------------------

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10,2),
    quantity_remaining INT,
    quantity_sold INT DEFAULT 0
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity_ordered INT,
    total_price NUMERIC(10,2),
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products (product_name, price, quantity_remaining) VALUES
('Smartphone', 15000, 10),
('Tablet', 25000, 5),
('Laptop', 60000, 3);

CREATE OR REPLACE PROCEDURE process_order(
    IN p_product_id INT,
    IN p_quantity INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_price NUMERIC(10,2);
    v_available INT;
    v_total NUMERIC(10,2);
BEGIN
    SELECT price, quantity_remaining INTO v_price, v_available
    FROM products
    WHERE product_id = p_product_id;

    IF v_available >= p_quantity THEN
        v_total := v_price * p_quantity;
        INSERT INTO sales(product_id, quantity_ordered, total_price)
        VALUES (p_product_id, p_quantity, v_total);
        UPDATE products
        SET quantity_remaining = quantity_remaining - p_quantity,
            quantity_sold = quantity_sold + p_quantity
        WHERE product_id = p_product_id;
        RAISE NOTICE 'Product sold successfully!';
    ELSE
        RAISE NOTICE 'Insufficient Quantity Available!';
    END IF;
END;
$$;

CALL process_order(1, 3);
CALL process_order(3, 5);
