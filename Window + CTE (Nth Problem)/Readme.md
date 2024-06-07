
Absolutely! Here’s a LinkedIn post that you can use to share your SQL solutions:

---

🚀 Excited to share some critical SQL solutions I've developed using **Window Functions** and **Common Table Expressions (CTE)**! These techniques have been invaluable for solving various data queries efficiently. Check out some of the key examples below:

1. **Nth Maximum Salary**:
```sql
WITH CTE AS (SELECT *, RANK() OVER(ORDER BY SALARY DESC) AS RANKS FROM EMP)
SELECT * FROM CTE WHERE RANKS = 5; -- REPLACE N HERE
```
**Result**: 
| EMP_ID | NAME    | SALARY   | DEPARTMENT | JOIN_DATE  | RANKS |
|--------|---------|---------|------------|------------|-------|
| 3      | Charlie | 80000.0 | Finance    | 2017-05-13 | 3     |

2. **Top N Salaries**:
```sql
WITH CTE AS (SELECT *, RANK() OVER(ORDER BY SALARY DESC) AS RANKS FROM EMP)
SELECT * FROM CTE WHERE RANKS <= 5; -- REPLACE N HERE
```
**Result**: 
| EMP_ID | NAME    | SALARY   | DEPARTMENT | JOIN_DATE  | RANKS |
|--------|---------|---------|------------|------------|-------|
| 7      | Grace   | 95000.0 | Finance    | 2015-07-19 | 1     |
| 5      | Eve     | 85000.0 | Finance    | 2016-09-25 | 2     |
| 3      | Charlie | 80000.0 | Finance    | 2017-05-13 | 3     |
| 4      | David   | 75000.0 | IT         | 2020-02-18 | 4     |
| 10     | Jack    | 72000.0 | IT         | 2017-11-30 | 5     |

3. **Top N Salaries by Department**:
```sql
WITH CTE AS (SELECT *, DENSE_RANK() OVER(PARTITION BY DEPARTMENT ORDER BY SALARY DESC) AS RANKS FROM EMP)
SELECT * FROM CTE WHERE RANKS <= 3; -- REPLACE N HERE
```
**Result**: 
| EMP_ID | NAME    | SALARY   | DEPARTMENT | JOIN_DATE  | RANKS |
|--------|---------|---------|------------|------------|-------|
| 7      | Grace   | 95000.0 | Finance    | 2015-07-19 | 1     |
| 5      | Eve     | 85000.0 | Finance    | 2016-09-25 | 2     |
| 3      | Charlie | 80000.0 | Finance    | 2017-05-13 | 3     |
| 9      | Ivy     | 67000.0 | HR         | 2018-12-12 | 1     |
| 1      | Alice   | 60000.0 | HR         | 2019-01-15 | 2     |
| 6      | Frank   | 50000.0 | HR         | 2021-11-04 | 3     |
| 4      | David   | 75000.0 | IT         | 2020-02-18 | 1     |
| 10     | Jack    | 72000.0 | IT         | 2017-11-30 | 2     |
| 2      | Bob     | 70000.0 | IT         | 2018-03-22 | 3     |

4. **Employees Earning the Same Salary**:
```sql
WITH CTE AS (SELECT *, COUNT(*) OVER(PARTITION BY SALARY) AS CNT FROM EMP)
SELECT * FROM CTE WHERE CNT >= 2;
```
**Result**: 
| EMP_ID | NAME  | SALARY   | DEPARTMENT | JOIN_DATE  | CNT |
|--------|-------|---------|------------|------------|-----|
| 10     | Jack  | 72000.0 | IT         | 2017-11-30 | 2   |
| 11     | Fack  | 72000.0 | IT         | 2017-11-28 | 2   |

5. **Display Even/Odd Number Rows**:
```sql
SELECT * FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY EMP_ID) AS RN FROM EMP) TEMP
-- WHERE RN % 2 = 1; -- ODD
WHERE RN % 2 = 0; -- EVEN
```
**Result**:
| EMP_ID | NAME   | SALARY   | DEPARTMENT | JOIN_DATE  | RN  |
|--------|--------|---------|------------|------------|-----|
| 2      | Bob    | 70000.0 | IT         | 2018-03-22 | 2   |
| 4      | David  | 75000.0 | IT         | 2020-02-18 | 4   |
| 6      | Frank  | 50000.0 | HR         | 2021-11-04 | 6   |
| 8      | Hannah | 64000.0 | IT         | 2019-04-21 | 8   |
| 10     | Jack   | 72000.0 | IT         | 2017-11-30 | 10  |


6. **Count Rows Without COUNT Function**:
```sql
WITH CTE AS (SELECT *, ROW_NUMBER() OVER (ORDER BY EMP_ID DESC) AS RN FROM EMP)
SELECT MAX(RN) FROM CTE;
```
**Result**:
| EMP_ID | 
|--------|
| 2      |

7. **Find Last Inserted Record**:
```sql
SELECT * FROM EMP WHERE JOIN_DATE = (SELECT MAX(JOIN_DATE) FROM EMP);
```
**Result**:
| EMP_ID | NAME   | SALARY    | DEPARTMENT | JOIN_DATE  |
|--------|--------|----------|------------|------------|
| 6      | Frank  | 50000.00 | HR         | 2021-11-04 |

