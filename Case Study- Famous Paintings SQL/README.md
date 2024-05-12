# SQL Painting Project

This project involves analyzing a dataset related to paintings, artists, museums, and various attributes associated with them using SQL queries.

## Dataset Overview

The dataset includes the following tables:

- `artist`: Contains information about artists.
- `canvas_size`: Provides details about different canvas sizes.
- `image_link`: Stores links to images of paintings.
- `museum`: Holds information about museums.
- `museum_hours`: Contains museum opening hours.
- `subject`: Contains subjects of paintings.
- `work`: Stores details about paintings.
- `product_size`: Provides details about product sizes associated with paintings.
- 
## Exploring the dataset 

```sql
SELECT * FROM artist; -- 421
SELECT * FROM canvas_size; -- 200
SELECT * FROM image_link; -- 14775
SELECT * FROM museum; -- 57
SELECT * FROM museum_hours; -- 351
SELECT * FROM  subject; -- 6771
SELECT * FROM work; -- 14776
SELECT * FROM product_size; -- 110347
```


## SQL Queries and Outputs

Here are the SQL queries along with their outputs:

1. **Fetch all the paintings which are not displayed in any museums**

```sql
SELECT * FROM work
WHERE museum_id IS NULL;
```
-- Output --  
There are 10,223 paintings which are not displayed on any museums.

2. **Are there museuems without any paintings**

```sql
SELECT M.* 
FROM MUSEUM M
LEFT JOIN WORK W
ON M.MUSEUM_ID = W.MUSEUM_ID
WHERE W.MUSEUM_ID IS NULL;
```
-- Output --  
There is no museuems without any painting

3. **How many paintings have an asking price of more than their regular price?**
```sql
SELECT COUNT(WORK_ID)
FROM PRODUCT_SIZE
WHERE SALE_PRICE > REGULAR_PRICE;
```
-- Output --
There is no paintings have an asking price of more than their regular price.


4. **Identify the paintings whose asking price is less than 50% of its regular price**
```sql
SELECT work_id
FROM PRODUCT_SIZE
WHERE SALE_PRICE > REGULAR_PRICE / 2;
```
-- Output --
There are almost 1,10,289 paintings whose asking price is less than 50% of its regular price.

5. **Which canva size costs the most?**
```sql
SELECT C.LABEL, P.SALE_PRICE
FROM PRODUCT_SIZE P
LEFT JOIN CANVAS_SIZE C
ON P.SIZE_ID = C.SIZE_ID
ORDER BY SALE_PRICE DESC
LIMIT 1;
```
-- Output --
| Label                   | Sale Price |
|-------------------------|------------|
| 48" x 96" (122 cm x 244 cm) | 1115   |

