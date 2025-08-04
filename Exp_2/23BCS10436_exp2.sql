-- Exp 2 (a)

CREATE DATABASE company;
USE company;

CREATE TABLE employee (
    empid INT PRIMARY KEY,
    ename VARCHAR(50),
    department VARCHAR(50),
    managerid INT
);

INSERT INTO employee (empid, ename, department, managerid) VALUES 
(1, 'Alice', 'HR', NULL),
(2, 'Bob', 'Finance', 1),
(3, 'Charlie', 'IT', 1),
(4, 'David', 'Finance', 2),
(5, 'Eve', 'IT', 3),
(6, 'Frank', 'HR', 1);

SELECT 
    e.ename AS EmployeeName,
    e.department AS EmployeeDepartment,
    m.ename AS ManagerName,
    m.department AS ManagerDepartment
FROM 
    employee e
LEFT JOIN 
    employee m ON e.managerid = m.empid;


-- Exp 2 (b)

create database company2;
use  company2;

CREATE TABLE Year_tbl (
    ID INT,
    YEAR INT,
    NPV INT
);

CREATE TABLE Queries (
    ID INT,
    YEAR INT
);

INSERT INTO Year_tbl (ID, YEAR, NPV)
VALUES
(1, 2018, 100),
(7, 2020, 30),
(13, 2019, 40),
(1, 2019, 113),
(2, 2008, 121),
(3, 2009, 12),
(11, 2020, 99),
(7, 2019, 0);

INSERT INTO Queries (ID, YEAR)
VALUES
(1, 2019),
(2, 2008),
(3, 2009),
(7, 2018),
(7, 2019),
(7, 2020),
(13, 2019);

SELECT 
    q.ID,
    q.YEAR,
    IFNULL(y.NPV, 0) AS NPV
FROM 
    Queries q
LEFT JOIN 
    Year_tbl y ON q.ID = y.ID AND q.YEAR = y.YEAR;