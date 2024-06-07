
Absolutely! Here’s a LinkedIn post that you can use to share your SQL solutions:

---

🚀 Excited to share some critical SQL solutions I've developed using **Window Functions** and **Common Table Expressions (CTE)**! These techniques have been invaluable for solving various data queries efficiently. Check out some of the key examples below:

1. **Nth Maximum Salary**:
```sql
WITH CTE AS (SELECT *, RANK() OVER(ORDER BY SALARY DESC) AS RANKS FROM EMP)
SELECT * FROM CTE WHERE RANKS = 5; -- REPLACE N HERE
```

2. **Top N Salaries**:
```sql
WITH CTE AS (SELECT *, RANK() OVER(ORDER BY SALARY DESC) AS RANKS FROM EMP)
SELECT * FROM CTE WHERE RANKS <= 5; -- REPLACE N HERE
```

3. **Top N Salaries by Department**:
```sql
WITH CTE AS (SELECT *, DENSE_RANK() OVER(PARTITION BY DEPARTMENT ORDER BY SALARY DESC) AS RANKS FROM EMP)
SELECT * FROM CTE WHERE RANKS <= 3; -- REPLACE N HERE
```

4. **Employees Earning the Same Salary**:
```sql
WITH CTE AS (SELECT *, COUNT(*) OVER(PARTITION BY SALARY) AS CNT FROM EMP)
SELECT * FROM CTE WHERE CNT >= 2;
```

5. **Display Even/Odd Number Rows**:
```sql
SELECT * FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY EMP_ID) AS RN FROM EMP) TEMP
-- WHERE RN % 2 = 1; -- ODD
WHERE RN % 2 = 0; -- EVEN
```

6. **Count Rows Without COUNT Function**:
```sql
WITH CTE AS (SELECT *, ROW_NUMBER() OVER (ORDER BY EMP_ID DESC) AS RN FROM EMP)
SELECT MAX(RN) FROM CTE;
```

7. **Find Last Inserted Record**:
```sql
SELECT * FROM EMP WHERE JOIN_DATE = (SELECT MAX(JOIN_DATE) FROM EMP);
```

8. **Employees Working for the Past 5 Years**:
```sql
SELECT * FROM EMP WHERE JOIN_DATE <= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
```



#SQL #DataAnalysis #Database #CTE #WindowFunctions #Tech #Learning #CareerGrowth

---
