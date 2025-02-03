SELECT * FROM artist;

SELECT * FROM canvas_size;

SELECT * FROM image_link

SELECT * FROM museum

SELECT * FROM museum_hours

SELECT * FROM product_size

SELECT * FROM subject

SELECT * FROM work


-- Fetch all the paintings which are not displayed in any museums.
SELECT * FROM museum


-- Are there museums without any paintings?
SELECT museum.name,museum.city
FROM museum
LEFT JOIN work on museum.museum_id = museum.museum_id
WHERE work.museum_id IS NULL;

-- How many paintings have an asking price of more than their regular price?

SELECT COUNT(*) AS paintings_with_higher_price,
FROM product_size
WHERE product_size.regular_price > product_size.sale_price


-- Identify the paintings whose asking price is less than 50% of its regular price.
SELECT product_size.work_id, product_size.sale_price, product_size.regular_price
FROM product_size
WHERE product_size.sale_price <(product_size.regular_price * 0.5);


--5) Which canvas size costs the most?
SELECT canvas_size.size_id, MAX(product_size.sale_price) as max_price
FROM product_size
INNER JOIN canvas_size ON canvas_size.size_id = canvas_size.size_id
GROUP BY canvas_size.size_id
ORDER BY max_price DESC
LIMIT 1


--6) Delete duplicate records from work, product_size, subject, and image_link tables.

WITH cte AS(
SELECT work_id, ROW_NUMBER() OVER (PARTITON BY name,artist_id,style,museum_id ORDER BY work_id) as row_no
FROM work
)
DELETE FROM work
WHERE work_id IN (SELECT work_id FROM cte WHERE row_no > 1);


--7) Identify the museums with invalid city information in the given dataset.

SELECT name, city
FROM museum
WHERE city IS NULL OR city='';

SELECT name, city
FROM museum
WHERE city ~ '[0-9]';  -- This regular expression checks for numbers


--8)Museum_Hours table has 1 invalid entry. Identify it and remove it.
SELECT *
FROM museum_hours
WHERE day NOT SIMILAR TO '[0-9{2}:[0-9]{2}';


--9) Fetch the top 10 most famous painting subjects.
SELECT subject.subject, COUNT(work.work_id) as paintings_count
FROM work
INNER JOIN subject ON subject.subject = subject.subject
GROUP BY subject.subject
ORDER BY paintings_count DESC
LIMIT 10;


--10) Identify the museums which are open on both Sunday and Monday. Display museum name, city.

SELECT museum.name,museum.city
FROM museum
INNER JOIN museum_hours ON museum.museum_id = museum_hours.museum_id
WHERE museum_hours.day IN ('Sunday','Monday')
GROUP BY museum.name, museum.city
HAVING COUNT(DISTINCT museum_hours.day) = 2;


--11) How many museums are open every single day?
SELECT COUNT(DISTINCT museum.museum_id) AS museum_open_every_day
FROM museum
INNER JOIN museum_hours ON museum.museum_id = museum_hours.museum_id
GROUP BY museum.museum_id
HAVING COUNT(DISTINCT museum_hours.day) = 7;


--Which are the top 5 most popular museums? (Popularity is defined based on most number of paintings in a museum)

SELECT museum.name, COUNT(work.work_id) AS no_paintings
FROM museum
INNER JOIN work ON museum.museum_id = work.museum_id
GROUP BY museum.name
ORDER BY no_paintings DESC
LIMIT 5;

--13) Who are the top 5 most popular artists? (Popularity is defined based on the most number of paintings done by an artist)
SELECT artist.full_name, COUNT(work.work_id) as no_paintings
FROM artist
INNER JOIN work ON artist.artist_id = work.artist_id
GROUP BY artist.full_name
ORDER BY no_paintings
DESC LIMIT 5;

--14) Display the 3 least popular canvas sizes.

SELECT canvas_size.label, COUNT(product_size.size_id) AS no_paintings
FROM canvas_size
INNER JOIN product_size 
    ON canvas_size.size_id ~ '^[0-9]+$'  -- Ensures only numeric values are used in canvas_size
    AND product_size.size_id ~ '^[0-9]+$'  -- Ensures only numeric values are used in product_size
    AND canvas_size.size_id::BIGINT = product_size.size_id::BIGINT  -- Safely cast to BIGINT after filtering
GROUP BY canvas_size.label
ORDER BY no_paintings ASC
LIMIT 3;


--15) Which museum is open for the longest during a day? Display museum name, state, and hours open and which day?
SELECT museum.name,museum.state,museum_hours.day,
EXTRACT(HOUR FROM(TO_TIMESTAMP(museum_hours.close,'HH:MI:AM') - TO_TIMESTAMP(museum_hours.open,'HH:MI:AM'))) as total_hours
FROM museum
INNER JOIN museum_hours on museum.museum_id = museum_hours.museum_id
ORDER BY total_hours DESC
LIMIT 1

--16) Which museum has the most number of the most popular painting style?

WITH most_popular_style AS (
SELECT work.style, COUNT(work.work_id) as no_painting
FROM work
GROUP BY work.style
ORDER BY no_painting DESC
LIMIT 1
)

SELECT museum.name, COUNT(work.work_id) as no_painting
FROM museum
INNER JOIN work ON museum.museum_id = work.museum_id
INNER JOIN most_popular_style ON work.style = most_popular_style.style
GROUP BY museum.name
ORDER BY no_painting DESC
LIMIT 1;


--17) Identify the artists whose paintings are displayed in multiple countries.
SELECT artist.full_name, COUNT(DISTINCT museum.country) as no_countries
FROM artist
INNER JOIN work ON artist.artist_id = work.artist_id
INNER JOIN museum ON work.museum_id = museum.museum_id
GROUP BY artist.full_name
HAVING COUNT(DISTINCT museum.country) > 1
ORDER BY no_countries
DESC

--18) Display the country and the city with the most number of museums. Output two separate columns to mention the city and country. If there are multiple values, separate them with a comma.


WITH country_museum_count AS (
    SELECT country, COUNT(*) AS num_museums
    FROM museum
    GROUP BY country
),
city_museum_count AS (
    SELECT city, COUNT(*) AS num_museums
    FROM museum
    GROUP BY city
)
SELECT 
    (SELECT STRING_AGG(country, ', ') 
     FROM country_museum_count 
     WHERE num_museums = (SELECT MAX(num_museums) FROM country_museum_count)) AS most_museums_country,
     
    (SELECT STRING_AGG(city, ', ') 
     FROM city_museum_count 
     WHERE num_museums = (SELECT MAX(num_museums) FROM city_museum_count)) AS most_museums_city;


--19) Identify the artist and the museum where the most expensive and least expensive painting is placed. Display the artist name, sale_price, painting name, museum name, museum city, and canvas label.
WITH price_extremes AS (
    SELECT MAX(sale_price) AS max_price, 
           MIN(sale_price) AS min_price 
    FROM product_size
)
SELECT artist.full_name, product_size.sale_price, work.name AS painting_name, 
       museum.name, museum.city AS museum_city, canvas_size.label AS canvas_label
FROM work
INNER JOIN artist ON work.artist_id = artist.artist_id
INNER JOIN museum ON work.museum_id = museum.museum_id
INNER JOIN product_size ON work.work_id = product_size.work_id  -- Link work to product_size
INNER JOIN canvas_size 
    ON product_size.size_id::BIGINT = canvas_size.size_id::BIGINT  -- Cast both to BIGINT
WHERE product_size.sale_price = (SELECT max_price FROM price_extremes)
   OR product_size.sale_price = (SELECT min_price FROM price_extremes);


--20) Which country has the 5th highest number of paintings?

SELECT museum.country, COUNT(work.work_id) AS num_paintings
FROM work
INNER JOIN museum ON work.museum_id = museum.museum_id
GROUP BY museum.country
ORDER BY num_paintings DESC
LIMIT 1 OFFSET 4;

--21) Which are the 3 most popular and 3 least popular painting styles?

-- Most popular painting styles
SELECT subject.subject, COUNT(work.work_id) AS num_paintings
FROM work
INNER JOIN subject ON work.work_id = subject.work_id
GROUP BY subject.subject
ORDER BY num_paintings DESC
LIMIT 3;

-- Least popular painting styles
SELECT subject.subject, COUNT(work.work_id) AS num_paintings
FROM work
INNER JOIN subject ON work.work_id = subject.work_id
GROUP BY subject.subject
ORDER BY num_paintings ASC
LIMIT 3;


--22) Which artist has the most number of Portrait paintings outside the USA? Display artist name, number of paintings, and the artist nationality

SELECT artist.full_name, COUNT(work.work_id) as num_portraits, artist.nationality
FROM work
INNER JOIN artist ON work.artist_id = artist.artist_id
INNER JOIN subject ON work.work_id = subject.work_id
INNER JOIN museum ON work.museum_id = museum.museum_id 
WHERE subject.subject = 'Portrait'
AND museum.country != 'USA'
GROUP BY artist.full_name,artist.nationality
ORDER BY num_portraits DESC
LIMIT 1
