-- Create the EMP table
CREATE TABLE EMP (
    EMP_ID INT PRIMARY KEY,
    NAME VARCHAR(100),
    SALARY DECIMAL(10, 2),
    DEPARTMENT VARCHAR(50),
    JOIN_DATE DATE
);

-- Insert sample data into the EMP table
INSERT INTO EMP (EMP_ID, NAME, SALARY, DEPARTMENT, JOIN_DATE) VALUES
(1, 'Alice', 60000, 'HR', '2019-01-15'),
(2, 'Bob', 70000, 'IT', '2018-03-22'),
(3, 'Charlie', 80000, 'Finance', '2017-05-13'),
(4, 'David', 75000, 'IT', '2020-02-18'),
(5, 'Eve', 85000, 'Finance', '2016-09-25'),
(6, 'Frank', 50000, 'HR', '2021-11-04'),
(7, 'Grace', 95000, 'Finance', '2015-07-19'),
(8, 'Hannah', 64000, 'IT', '2019-04-21'),
(9, 'Ivy', 67000, 'HR', '2018-12-12'),
(10, 'Jack', 72000, 'IT', '2017-11-30');

-- Create additional tables as needed based on the questions

-- Example of creating a table to practice duplicate rows
CREATE TABLE DUPLICATE_EMP (
    EMP_ID INT,
    NAME VARCHAR(100),
    SALARY DECIMAL(10, 2),
    DEPARTMENT VARCHAR(50),
    JOIN_DATE DATE
);

-- Insert duplicate data into the DUPLICATE_EMP table
INSERT INTO DUPLICATE_EMP (EMP_ID, NAME, SALARY, DEPARTMENT, JOIN_DATE) VALUES
(1, 'Alice', 60000, 'HR', '2019-01-15'),
(2, 'Alice', 60000, 'HR', '2019-01-15'),
(3, 'Bob', 70000, 'IT', '2018-03-22'),
(4, 'Charlie', 80000, 'Finance', '2017-05-13'),
(5, 'Charlie', 80000, 'Finance', '2017-05-13');