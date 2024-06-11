-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and revenue.worldwide gross of the lowest grossing movie (order by ASC), limit 1.

SELECT specs.film_title, specs.release_year, revenue.worldwide_gross
FROM specs
JOIN revenue
ON specs.movie_id = revenue.movie_id
ORDER BY revenue.worldwide_gross ASC
	LIMIT 1;

-- Semi-Tough (1977), 37187139 gross

-- 2. What year has the highest average imdb rating (rating table)?

SELECT AVG(rating.imdb_rating) AS avg_rating, specs.release_year 
FROM rating
JOIN specs
ON rating.movie_id = specs.movie_id
GROUP BY specs.release_year
ORDER BY avg_rating DESC
LIMIT 1;

-- 1991

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT specs.film_title, distributors.company_name, revenue.worldwide_gross
FROM specs
JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
JOIN revenue
USING(movie_id)
WHERE specs.mpaa_rating = 'G'
ORDER BY revenue.worldwide_gross DESC
LIMIT 1;

-- Toy Story 4, Walt Disney

-- 4. Write a query that returns, for each distributor in the distributors table, 
--the distributor name (distributors.company_name) and the number of movies (count(film_title)) associated with that distributor 
-- in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

-- group by distributor 
-- LEFT JOIN to show all the distributors regardless of their movie count from specs 

-- SELECT distributors.company_name AS distributor, COUNT(specs.film_title) AS num_of_movies
-- FROM distributors 
-- LEFT JOIN specs
-- ON distributors.distributor_id = specs.domestic_distributor_id
-- GROUP BY distributors.company_name;


-- 5. Write a query that returns the five distributors (distributors.company_name) with 
--the highest average movie budget (AVG(revenue.film_budget). 

-- SELECT distributors.company_name AS distributors, AVG(revenue.film_budget) AS avg_budget
-- FROM distributors
-- JOIN specs
-- ON distributors.distributor_id = specs.domestic_distributor_id
-- JOIN revenue
-- USING(movie_id)
-- GROUP BY distributors.company_name
-- ORDER BY AVG(revenue.film_budget) DESC
-- LIMIT 5;

-- 6. How many movies in the dataset (specs.film_title) are distributed by a company (distributors.company_name) 
--which is not headquartered in California (WHERE distributors.headquarters NOT LIKE '%CA%')? 
--Which of these movies has the highest imdb rating?

-- SELECT specs.film_title, distributors.company_name, rating.imdb_rating
-- FROM specs
-- JOIN distributors
-- ON specs.domestic_distributor_id = distributors.distributor_id
-- JOIN rating
-- USING(movie_id)
-- WHERE distributors.headquarters NOT LIKE '%CA%'
-- ORDER BY imdb_rating DESC
-- LIMIT 1;

-- Dirty Dancing 

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
-- FIND the avg rating for ALL movies over 120 mins, then ALL movies under 120s and compare them 

-- option #1

-- SELECT 
 
-- (SELECT AVG(rating.imdb_rating) AS avg_rating 
-- FROM rating 
-- JOIN specs 
-- USING(movie_id)
-- WHERE specs.length_in_min > 120) AS movies_over_120,

-- (SELECT AVG(rating.imdb_rating) AS avg_rating 
-- FROM rating 
-- JOIN specs 
-- USING(movie_id)
-- WHERE specs.length_in_min < 120) AS movies_under_120

-- option #2

-- SELECT AVG(rating.imdb_rating) AS avg_rating, 'movies over 120'
-- FROM rating 
-- JOIN specs 
-- USING(movie_id)
-- WHERE specs.length_in_min > 120

-- UNION 

-- SELECT AVG(rating.imdb_rating) AS avg_rating, 'movies under 120'
-- FROM rating 
-- JOIN specs 
-- USING(movie_id)
-- WHERE specs.length_in_min < 120
-- ;

--option #3 THE SLEEK AND SEXY

-- SELECT 'movies over 2 hours' AS movie_length, AVG(rating.imdb_rating) AS avg_rating
-- FROM rating 
-- JOIN specs 
-- USING(movie_id)
-- WHERE specs.length_in_min >= 120

-- UNION 

-- SELECT 'movies under 2 hours' AS movie_length, AVG(rating.imdb_rating) AS avg_rating
-- FROM rating 
-- JOIN specs 
-- USING(movie_id)
-- WHERE specs.length_in_min < 120
-- ;

-- option #4

-- SELECT (specs.length_in_min / 120) AS hours, AVG(rating.imdb_rating) AS avg_rating
-- FROM specs
-- INNER JOIN rating
-- USING(movie_id)
-- GROUP BY hours
-- ORDER BY hours DESC;

-- ## Joins Exercise Bonus Questions

-- 1.	Find the total worldwide gross and average imdb rating by decade 

-- SELECT SUM(revenue.worldwide_gross) AS total_wwgross, AVG(rating.imdb_rating) AS avg_imdb_rating, specs.release_year/10 ||'0' AS decade
-- 	FROM revenue
-- 	JOIN rating
-- 	USING(movie_id)
-- 	JOIN specs
-- 	USING(movie_id)
-- 	GROUP BY decade
-- 	ORDER BY decade DESC;

--Then alter your query so it returns JUST the second highest average imdb rating and its decade. 
--This should result in a table with just one row.
-- CONCAT ||

-- SELECT SUM(revenue.worldwide_gross) AS total_wwgross, AVG(rating.imdb_rating) AS avg_imdb_rating, specs.release_year/10 ||'0' AS decade
-- 	FROM revenue
-- 	JOIN rating
-- 	USING(movie_id)
-- 	JOIN specs
-- 	USING(movie_id)
-- 	GROUP BY decade
-- 	ORDER BY avg_imdb_rating DESC
-- 	LIMIT 1
-- 	OFFSET 1;


-- 2.	Our goal in this question is to compare the worldwide gross for movies compared to their sequels.   
-- 	a.	Start by finding all movies whose titles end with a space and then the number 2.  

-- SELECT film_title
-- FROM specs
-- WHERE film_title LIKE '% 2%';

-- 	b.	For each of these movies, create a new column showing the original film’s name by removing the last two characters of the film title. 
--For example, for the film “Cars 2”, the original title would be “Cars”. 
-- Hint: You may find the string functions listed in Table 9-10 of https://www.postgresql.org/docs/current/functions-string.html 
--to be helpful for this. 
-- 	c.	Bonus: This method will not work for movies like “Harry Potter and the Deathly Hallows: Part 2”, 
--where the original title should be “Harry Potter and the Deathly Hallows: Part 1”. Modify your query to fix these issues.  

-- SELECT TRIM(' 2' from film_title) AS original, film_title AS sequel
-- FROM specs
-- WHERE film_title LIKE '% 2%';

-- 	d.	Now, build off of the query you wrote for the previous part to pull in worldwide revenue for both the original movie and its sequel. 
--Do sequels tend to make more in revenue? 

-- SELECT TRIM(' 2 ' from original_movie.film_title) AS original_title, sequel_movie.film_title AS sequel_title, revenue.worldwide_gross
-- FROM specs AS original_movie
-- JOIN revenue
-- USING(movie_id)
-- JOIN specs AS sequel_movie
-- USING(movie_id)
-- WHERE sequel_movie.film_title LIKE '% 2%';

--Hint: You will likely need to perform a self-join on the specs table in order to get the movie_id values for 
--both the original films and their sequels. 


--Bonus: A common data entry problem is trailing whitespace. 
--In this dataset, it shows up in the film_title field, where the movie “Deadpool” is recorded as “Deadpool “. 
--One way to fix this problem is to use the TRIM function. 
--Incorporate this into your query to ensure that you are matching as many sequels as possible.


-- 3.	Sometimes movie series can be found by looking for titles that contain a colon. 
--For example, Transformers: Dark of the Moon is part of the Transformers series of films.  
-- 	a.	Write a query which, for each film will extract the portion of the film name that occurs before the colon. 
--For example, “Transformers: Dark of the Moon” should result in “Transformers”.  
--If the film title does not contain a colon, it should return the full film name. 
--For example, “Transformers” should result in “Transformers”. 
--Your query should return two columns, the film_title and the extracted value in a column named series. 
--Hint: You may find the split_part function useful for this task.

SELECT film_title, SPLIT_PART(film_title, ':', 1) AS series
FROM specs;

-- 	b.	Keep only rows which actually belong to a series. 
--Your results should not include “Shark Tale” but should include both “Transformers” and “Transformers: Dark of the Moon”. 
--Hint: to accomplish this task, you could use a WHERE clause which checks whether the film title either contains a colon 
--or is in the list of series values for films that do contain a colon.  

SELECT film_title, SPLIT_PART(film_title, ':', 1) AS series
FROM specs
WHERE film_title LIKE '%:%';

-- 	c.	Which film series contains the most installments?  Star Wars 

SELECT COUNT(film_title), SPLIT_PART(film_title, ':', 1) AS series
FROM specs
WHERE film_title LIKE '%:%'
GROUP BY series;


-- 	d.	Which film series has the highest average imdb rating? --LOTR Which has the lowest average imdb rating? -- Twilight

SELECT COUNT(film_title), SPLIT_PART(film_title, ':', 1) AS series, AVG(rating.imdb_rating)
FROM specs
JOIN rating
USING(movie_id)
WHERE film_title LIKE '%:%'
GROUP BY series
ORDER BY avg DESC;

-- 4.	How many film titles contain the word “the” either upper or lowercase? -- 146

SELECT COUNT(film_title)
FROM specs
WHERE film_title ILIKE '%the%';

--How many contain it twice? three times? four times? 
--Hint: Look at the sting functions and operators here: https://www.postgresql.org/docs/current/functions-string.html 

-- SELECT film_title
-- FROM specs
-- WHERE film_title ILIKE '%the%';

-- 5.	For each distributor, find its highest rated movie. 
--Report the company name, the film title, and the imdb rating. 
--Hint: you may find the LATERAL keyword useful for this question. 
--This keyword allows you to join two or more tables together and to reference columns provided by preceding FROM items in later items. 
--See this article for examples of lateral joins in postgres: https://www.cybertec-postgresql.com/en/understanding-lateral-joins-in-postgresql/ 

-- SELECT company_name, specs.film_title, rating.imdb_rating
-- FROM distributors
-- JOIN specs
-- ON distributors.distributor_id = specs.domestic_distributor_id
-- JOIN rating
-- USING(movie_id);

-- 6.	Follow-up: Another way to answer 5 is to use DISTINCT ON so that your query returns only one row per company. 
-- You can read about DISTINCT ON on this page: https://www.postgresql.org/docs/current/sql-select.html. 

-- 7.	Which distributors had movies in the dataset that were released in consecutive years? 
--For example, Orion Pictures released Dances with Wolves in 1990 and The Silence of the Lambs in 1991. 
-- Hint: Join the specs table to itself and think carefully about what you want to join ON. 

-- SELECT distributors.company_name, s.film_title, p.release_year
-- FROM distributors
-- JOIN specs as s
-- ON distributors.distributor_id = s.domestic_distributor_id
-- JOIN specs as p
-- USING(movie_id)
-- ORDER BY company_name, p.release_year;