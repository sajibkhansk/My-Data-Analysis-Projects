use painting;
SELECT * FROM artist; -- 421
SELECT * FROM canvas_size; -- 200
SELECT * FROM image_link; -- 14775
SELECT * FROM museum; -- 57
SELECT * FROM museum_hours; -- 351
SELECT * FROM  subject; -- 6771
SELECT * FROM work; -- 14776
SELECT * FROM product_size; -- 110347

-- Q1: Fetch all the paintings which are not displayed on any museums

SELECT * FROM WORK
WHERE MUSEUM_ID IS NULL; 

-- Q2: Are there museuems without any paintings

SELECT M.* 
FROM MUSEUM M
LEFT JOIN WORK W
ON M.MUSEUM_ID = W.MUSEUM_ID
WHERE W.MUSEUM_ID IS NULL; -- There is no museuems without any painting

-- Q3: How many paintings have an asking price of more than their regular price? 
SELECT COUNT(WORK_ID)
FROM PRODUCT_SIZE
WHERE SALE_PRICE > REGULAR_PRICE; -- 0

-- Q4: Identify the paintings whose asking price is less than 50% of its regular price

SELECT work_id
FROM PRODUCT_SIZE
WHERE SALE_PRICE > REGULAR_PRICE / 2; 

-- Q5: Which canva size costs the most ?

SELECT C.LABEL, P.SALE_PRICE
FROM PRODUCT_SIZE P
LEFT JOIN CANVAS_SIZE C
ON P.SIZE_ID = C.SIZE_ID
ORDER BY SALE_PRICE DESC
LIMIT 1;

-- Q6: Delete duplicate records from work, product_size, subject and image_link tables

-- DELETING FROM WORK TABLE
DELETE FROM WORK
WHERE WORK_ID IN (
    SELECT WORK_ID
    FROM (
        SELECT 
            WORK_ID, 
            ROW_NUMBER() OVER (PARTITION BY WORK_ID) AS RowNum
        FROM 
            WORK
    ) AS Subquery
    WHERE RowNum > 1
);

-- DELETING FROM PRODUCT_SIZE TABLE
DELETE FROM PRODUCT_SIZE
WHERE (WORK_ID, SIZE_ID) IN (
    SELECT WORK_ID, SIZE_ID
    FROM (
        SELECT 
            WORK_ID, 
            SIZE_ID,
            ROW_NUMBER() OVER (PARTITION BY WORK_ID, SIZE_ID ORDER BY WORK_ID) AS RowNum
        FROM 
            PRODUCT_SIZE
    ) AS Subquery
    WHERE RowNum > 1
);

-- DELETING FROM SUBJECT TABLE

DELETE FROM SUBJECT
WHERE (WORK_ID, SUBJECT) IN (
    SELECT WORK_ID, SUBJECT
    FROM (
        SELECT 
            WORK_ID, 
            SUBJECT,
            ROW_NUMBER() OVER (PARTITION BY WORK_ID, SUBJECT ORDER BY WORK_ID) AS RowNum
        FROM 
            SUBJECT
    ) AS Subquery
    WHERE RowNum > 1
);

-- DELETING FROM IMAGE_LINK TABLE

DELETE FROM IMAGE_LINK
WHERE (WORK_ID, URL, thumbnail_small_url, thumbnail_large_url) IN (
    SELECT WORK_ID, URL, thumbnail_small_url, thumbnail_large_url
    FROM (
        SELECT 
            WORK_ID, 
            URL, 
            thumbnail_small_url, 
            thumbnail_large_url,
            ROW_NUMBER() OVER (PARTITION BY WORK_ID, URL, thumbnail_small_url, thumbnail_large_url ORDER BY WORK_ID) AS RowNum
        FROM 
            IMAGE_LINK
    ) AS Subquery
    WHERE RowNum > 1
);

-- Q7: Identify the museums with invalid city information in the given dataset
SELECT * FROM museum
WHERE  city REGEXP '^[0-9]';

-- Q8: Museum_Hours table has 1 invalid entry. Identify it and remove it
/*
MySQL doesn't have certain pseudo-columns like CTID because 
MySQL and PostgreSQL are different database management systems 
with different architectures and feature sets.
*/

-- Q9:  Fetch the top 10 most famous painting subject


SELECT s.subject, COUNT(*) AS no_of_paintings
FROM work w
JOIN subject s ON s.work_id = w.work_id
GROUP BY s.subject
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Q10:   Identify the museums which are open on both Sunday and Monday. Display museum name, city.

SELECT M.name, m.city FROM MUSEUM M
LEFT JOIN MUSEUM_HOURS H
ON M.MUSEUM_ID = H.MUSEUM_ID
WHERE DAY IN ('Sunday', 'Monday');


-- Q11:   How many museums are open every single day?
-- Pivoted Table for seeing daily opening 
SELECT 
COUNT(CASE WHEN day = 'Saturday' THEN MUSEUM_ID ELSE NULL END) AS Saturday,
COUNT(CASE WHEN day = 'Sunday' THEN MUSEUM_ID ELSE NULL END) AS Sunday,
COUNT(CASE WHEN day = 'Monday' THEN MUSEUM_ID ELSE NULL END) AS Monday,
COUNT(CASE WHEN day = 'Tuesday' THEN MUSEUM_ID ELSE NULL END) AS Tuesday,
COUNT(CASE WHEN day = 'Wednesday' THEN MUSEUM_ID ELSE NULL END) AS Wednesday,
COUNT(CASE WHEN day = 'Thursday' THEN MUSEUM_ID ELSE NULL END) AS Thursday,
COUNT(CASE WHEN day = 'Friday' THEN MUSEUM_ID ELSE NULL END) AS Friday
FROM MUSEUM_HOURS; 

-- Same but without pivoting
SELECT DAY,COUNT(*) AS NO_OF_MUSEUM_OPEN FROM  MUSEUM_HOURS
GROUP BY DAY; 

--  Final Ans
	SELECT 
    COUNT(*)
FROM
    (SELECT 
        museum_id, COUNT(*) AS no_of_museum_opening
    FROM
        museum_hours
    GROUP BY museum_id
    HAVING no_of_museum_opening = 7) x;

-- Q12:  Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)

SELECT m.museum_id, 
       m.name,  
       COUNT(work_id) AS work_shown 
FROM work w
JOIN museum m ON w.museum_id = m.museum_id

GROUP BY 1, 2 
ORDER BY work_shown DESC
LIMIT 5;

-- Q13:  Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
SELECT 
a.artist_id,
full_name,
count(w.work_id) as NO_OF_WORK
FROM work w
JOIN artist a 
ON w.artist_id = a.artist_id
group by a.artist_id, full_name
order by NO_OF_WORK DESC
LIMIT 5;

-- Q14:  Display the 3 least popular canva sizes

SELECT
p.size_id, 
c.label,
count(w.work_id) as work_shown
FROM work w
JOIN product_size p
ON w.work_id = p.work_id
JOIN canvas_size c
ON c.size_id = p.size_id
group by 1,2
order by work_shown
limit 3;

-- Q15: Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day?


with CTE as (
SELECT 
    m.museum_id,
    m.name,
    MAX(HOUR(
    TIMEDIFF(
        STR_TO_DATE(close, '%h:%i:%p'), 
        STR_TO_DATE(open, '%h:%i:%p')
    ) ))AS hour_gap
FROM 
    museum_hours h join 
    museum m
    on m.museum_id = h.museum_id
    group by 1,2)
select * from CTE
order by hour_gap desc
limit 1
; --  'Musée du Louvre' open for 12 hour which is maximum


-- Q16:  Which museum has the most no of most popular painting style?

SELECT 
       m.name, 
       w.style,
       COUNT(work_id) AS work_shown 
FROM work w
JOIN museum m ON w.museum_id = m.museum_id
GROUP BY m.museum_id,m.name, 
       w.style
ORDER BY work_shown DESC
LIMIT 1;

-- Q17:  Identify the artists whose paintings are displayed in multiple countries

 create table  temp (
 SELECT DISTINCT 
        a.full_name AS artist,
        m.country
    FROM 
        work w
    JOIN 
        artist a ON a.artist_id = w.artist_id
    JOIN 
        museum m ON m.museum_id = w.museum_id
);
select 
artist,
count(country) as country
from temp
group by artist
having country > 1
order by country desc;

-- Q18:  Display the country and the city with most no of museums. Output 2 seperate columns to mention the city and country. If there are multiple value, seperate them with comma.
WITH cte_country AS (
    SELECT 
        country,
        COUNT(*) AS country_count,
        RANK() OVER (ORDER BY COUNT(1) DESC) AS country_rank
    FROM 
        museum
    GROUP BY 
        country
),
cte_city AS (
    SELECT 
        city,
        COUNT(1) AS city_count,
        RANK() OVER (ORDER BY COUNT(1) DESC) AS city_rank
    FROM 
        museum
    GROUP BY 
        city
)
SELECT 
    (SELECT GROUP_CONCAT(DISTINCT country) FROM cte_country WHERE country_rank = 1) AS top_country,
    (SELECT GROUP_CONCAT(DISTINCT city) FROM cte_city WHERE city_rank = 1) AS top_city;


-- Q19:  Identify the artist and the museum where the most expensive and least expensive painting is placed. Display the artist name, sale_price, painting name, museum name, museum city and canvas label
-- max(sale_price) as most_expensive_price , min(sale_price)as least_expensive_price



WITH cte AS (
    SELECT 
        w.work_id,
        full_name,
        sale_price,
        w.name AS museum_name,
        m.name,
        m.city,
        c.label,
        MAX(sale_price) OVER () AS max_sale_price,
        MIN(sale_price) OVER () AS min_sale_price
    FROM 
        product_size p 
    JOIN 
        work w ON w.work_id = p.work_id
    JOIN 
        museum m ON m.museum_id = w.museum_id
    JOIN 
        artist a ON a.artist_id = w.artist_id
    JOIN 
        canvas_size c ON c.size_id = p.size_id
)
SELECT 
    *
FROM 
    cte
WHERE 
    sale_price IN (max_sale_price, min_sale_price)
limit 2;



-- Q20:  Which country has the 5th highest no of paintings?
with cte as 
		(select m.country, count(*) as no_of_Paintings
		, rank() over(order by count(*) desc) as rnk
		from museum m
		join work w on m.museum_id= w.museum_id
		group by m.country)
	select country, no_of_Paintings
	from cte 
	where rnk=5;
-- Q21:  Which are the 3 most popular and 3 least popular painting styles?

SELECT 
    style,
    CASE 
        WHEN rnk <= 3 THEN 'Most Popular'
        ELSE 'Least Popular' 
    END AS popularity
FROM (
    SELECT 
        style,
        RANK() OVER (ORDER BY cnt DESC) AS rnk
    FROM (
        SELECT 
            style,
            COUNT(*) AS cnt
        FROM 
            work
        WHERE 
            style IS NOT NULL
        GROUP BY 
            style
    ) AS subquery
) AS ranked_styles
WHERE 
    rnk <= 3
    OR rnk > (SELECT COUNT(DISTINCT style) FROM work WHERE style IS NOT NULL) - 3;


-- Q22:  Which artist has the most no of Portraits paintings outside USA?. Display artist name, no of paintings and the artist nationality.

SELECT 
    full_name AS artist_name,
    nationality,
    no_of_paintings
FROM (
    SELECT 
        a.full_name,
        a.nationality,
        COUNT(*) AS no_of_paintings,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM 
        work w
    JOIN 
        artist a ON a.artist_id = w.artist_id
    JOIN 
        subject s ON s.work_id = w.work_id
    JOIN 
        museum m ON m.museum_id = w.museum_id
    WHERE 
        s.subject = 'Portraits'
        AND m.country != 'USA'
    GROUP BY 
        a.full_name, a.nationality
) x
WHERE 
    rnk = 1;

