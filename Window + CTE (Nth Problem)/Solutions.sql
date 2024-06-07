-- Write a query to select Nth maximum salary from EMP table

WITH CTE AS (SELECT *,
RANK() OVER(ORDER BY SALARY DESC) AS RANKS
FROM EMP)
SELECT * 
FROM CTE 
WHERE RANKS=5; -- REPLACE N HERE 

-- Write a query to select top N salaries from the EMP table

WITH CTE AS (SELECT *,
RANK() OVER(ORDER BY SALARY DESC) AS RANKS
FROM EMP)
SELECT * 
FROM CTE 
WHERE RANKS<=5; -- REPLACE N HERE 

-- Write a query to select top N salaries from each department of the EMP table

WITH CTE AS (SELECT *,
DENSE_RANK() OVER(PARTITION BY DEPARTMENT ORDER BY SALARY DESC) AS RANKS
FROM EMP)
SELECT * 
FROM CTE 
WHERE RANKS<=3; -- REPLACE N HERE

-- Write a query to select only those employee information who are earning the same salary?
WITH CTE AS (SELECT *,
COUNT(*) OVER(PARTITION BY SALARY ORDER BY SALARY ) AS CNT
FROM EMP)
SELECT * 
FROM CTE 
WHERE CNT>=2;

SELECT * FROM EMP 
GROUP BY SALARY