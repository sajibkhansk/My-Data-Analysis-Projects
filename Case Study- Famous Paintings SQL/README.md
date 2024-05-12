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
