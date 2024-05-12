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

6. **Delete duplicate records from work, product_size, subject and image_link tables**
```sql
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

```
-- Output --
All duplicate recrod deleted from selected Table.

7. **Identify the museums with invalid city information in the given dataset**
```sql
SELECT * FROM museum
WHERE  city REGEXP '^[0-9]';
```
-- Output --
| Museum ID | Name                            | Address               | City          | State | Postal  | Country     | Phone            | Website                                                |
|-----------|---------------------------------|-----------------------|---------------|-------|---------|-------------|------------------|--------------------------------------------------------|
| 34        | The State Hermitage Museum      | Palace Square         | Sankt-Peterburg|       | 190000  | Russia      | 7 812 710-90-79 | [https://www.hermitagemuseum.org/wps/portal/hermitage/](https://www.hermitagemuseum.org/wps/portal/hermitage/) |
| 36        | Museum Folkwang                 | Museumsplatz 1        | Essen         |       | 45128   | Germany     | 49 201 8845000  | [https://www.museum-folkwang.de/en](https://www.museum-folkwang.de/en) |
| 37        | Museum of Grenoble              | 5 Pl. de Lavalette    | Grenoble      |       | 38000   | France      | 33 4 76 63 44 44| [https://www.museedegrenoble.fr/1986-the-museum-in-english.htm](https://www.museedegrenoble.fr/1986-the-museum-in-english.htm) |
| 38        | Musée des Beaux-Arts de Quimper| 40 Pl. Saint-Corentin | Quimper       |       | 29000   | France      | 33 2 98 95 45 20| [https://www.mbaq.fr/en/home-3.html](https://www.mbaq.fr/en/home-3.html) |
| 40        | Musée du Louvre                 | Rue de Rivoli         | Paris         |       | 75001   | France      | 33 1 40 20 50 50| [https://www.louvre.fr/en](https://www.louvre.fr/en) |
| 74        | Kröller-Müller Museum           | Houtkampweg 6         | Otterlo       |       | 6731 AW | Netherlands | +31 318 591 241 | [https://krollermuller.nl/en](https://krollermuller.nl/en) |

8. **Museum_Hours table has 1 invalid entry. Identify it and remove it**
```sql
MySQL doesn't have certain pseudo-columns like CTID because 
MySQL and PostgreSQL are different database management systems 
with different architectures and feature sets.
```
9. **Fetch the top 10 most famous painting subject**
```sql
SELECT s.subject, COUNT(*) AS no_of_paintings
FROM work w
JOIN subject s ON s.work_id = w.work_id
GROUP BY s.subject
ORDER BY COUNT(*) DESC
LIMIT 10;
```
-- Output --
| Subject                  | No. of Paintings |
|--------------------------|------------------|
| Portraits                | 1070             |
| Abstract/Modern Art      | 575              |
| Nude                     | 525              |
| Landscape Art            | 495              |
| Rivers/Lakes             | 480              |
| Flowers                  | 457              |
| Still-Life               | 395              |
| Seascapes                | 326              |
| Marine Art/Maritime      | 268              |
| Horses                   | 265              |

10. **Identify the museums which are open on both Sunday and Monday. Display museum name, city.**
```sql
SELECT M.name, m.city FROM MUSEUM M
LEFT JOIN MUSEUM_HOURS H
ON M.MUSEUM_ID = H.MUSEUM_ID
WHERE DAY IN ('Sunday', 'Monday');

```
-- Output --
| Name                                           | City          |
|------------------------------------------------|---------------|
| The Museum of Modern Art                      | New York      |
| Pushkin State Museum of Fine Arts             | Moscow        |
| National Gallery of Victoria                  | Melbourne     |
| São Paulo Museum of Art                       | São Paulo     |
| The State Hermitage Museum                    | 2             |
| The Metropolitan Museum of Art                | New York      |
| Museum Folkwang                               | 45128         |
| Museum of Grenoble                            | 38000         |
| Musée des Beaux-Arts de Quimper              | 29000         |
| Nelson-Atkins Museum of Art                   | Kansas City   |
| Musée du Louvre                               | 75001         |
| National Maritime Museum                      | London        |
| Museum of Fine Arts Boston                    | Boston        |
| Rijksmuseum                                   | Amsterdam     |
| Israel Museum                                 | Jerusalem     |
| Kunsthaus Zürich                              | Zurich        |
| National Gallery of Art                       | Washington    |
| National Gallery                              | London        |
| Mauritshuis Museum                            | Den Haag      |
| Musée d'Orsay                                 | Paris         |
| The Prado Museum                              | Madrid        |
| The Barnes Foundation                         | Philadelphia  |
| Hungarian National Gallery                    | Budapest      |
| Cleveland Museum Of Art                       | Cleveland     |
| Museum of Fine Arts, Houston                  | Houston       |
| The J. Paul Getty Museum                      | Los Angeles   |
| Thussen-Bornemisza Museum                     | Madrid        |
| Van Gogh Museum                               | Amsterdam     |
| The Phillips Collection                       | Washington    |
| Toledo Museum of Art                          | Toledo        |
| Los Angeles County Museum of Art              | Los Angeles   |
| Solomon R. Guggenheim Museum                  | New York      |
| The Tate Gallery                              | London        |
| Indianapolis Museum of Art                    | Indianapolis  |
| Museum of Fine Arts of Nancy                  | Nancy         |
| Fine Arts Museums of San Francisco Legion of Honor | San Francisco |
| Smithsonian American Art Museum               | Washington    |
| Philadelphia Museum of Art                    | Philadelphia  |
| The Art Institute of Chicago                  | Chicago       |
| Saint Louis Art Museum                        | St. Louis     |
| Uffizi Gallery Italy                          | Firenze       |
| Ohara Museum of Art                           | Kurashiki     |
| Musée Marmottan Monet                         | Paris         |
| Walters Art Museum                            | Baltimore     |
| Kröller-Müller Museum                         | 6731 AW Otterlo |
| National Museum                               | Cardiff       |
| Columbus Museum of Art                        | Columbus      |
| Kimbell Art Museum                            | Fort Worth    |
| Walker Art Gallery                            | Liverpool     |
| National Museum of Art Architecture and Design| Oslo          |
| Dallas Museum of Art                          | Dallas        |
| Museum of Fine Arts                           | Bern          |
| Army Museum                                   | Paris         |
| Chrysler Museum of Art                       | Norfolk       |
| National Gallery Prague                       | Nové Měst     |
| Norton Simon Museum                           | Pasadena      |
| Courtauld Gallery                             | Stran         |

10. **Which canva size costs the most?**
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
