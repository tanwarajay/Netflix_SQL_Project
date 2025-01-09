-- Easy:-
-- Q1. Display the unique ratings available in the dataset.

SELECT DISTINCT(rating)
FROM netflix
WHERE rating IS NOT NULL;

-- Q2. Find all titles released after 2020.

SELECT title, release_year
FROM netflix
WHERE release_year > 2020;

-- Q3. List all TV shows with their title and director.

SELECT title, director
FROM netflix
WHERE type = 'TV Show';

-- Q4. Retrieve all content directed by "Alex Woo."

SELECT *
FROM netflix
WHERE director ILIKE '%Alex Woo%';

-- Q5. Retrieve the title and release year of all content directed by "Kirsten Johnson."

SELECT title, release_year
FROM netflix
WHERE director ILIKE '%Kirsten Johnson%';

-- Moderate:-
-- Q6. List all unique genres in the dataset.

SELECT DISTINCT(UNNEST(STRING_TO_ARRAY(listed_in, ','))) as genres
FROM netflix;

-- Q7. Count the number of content items grouped by rating.

SELECT rating, COUNT(*)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;

-- Q8. Retrieve all movies with a duration greater than 100 minutes.

SELECT *
FROM netflix
WHERE
	type = 'Movie'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 100;

-- Q9. Find all titles listed under "Dramas" or "Documentaries."

SELECT title, listed_in
FROM netflix
WHERE
	listed_in ILIKE '%Dramas%'
	OR
	listed_in ILIKE '%Documentaries%';

-- Q10. Retrieve titles added in the last 6 months of any year.

SELECT title, date_added
FROM netflix
WHERE EXTRACT(MONTH FROM TO_DATE(date_added, 'Month DD, YYYY')) IN (7, 8, 9, 10, 11, 12);

-- HARD:-
--  Q11. Count the number of movies and TV shows added each year.

SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS added_year,
	COUNT(show_id) AS total_count
FROM netflix
GROUP BY 1
ORDER BY 1 ASC;

-- Q12. List the top 3 directors by the number of content items they directed.

SELECT 
	UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name,
	COUNT(show_id)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

-- Q13. Identify the country that produces the most "TV-14" rated content.

SELECT country_name
FROM
(
	SELECT
		UNNEST(STRING_TO_ARRAY(country, ',')) AS country_name
	FROM netflix
	WHERE rating = 'TV-14'
)
GROUP BY 1
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Q14. 
SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100, 2) as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1;

-- Q15. What percentage of movies or shows are released in each country.
-- considering that some titles are listed under multiple countries

SELECT
	DISTINCT(UNNEST(STRING_TO_ARRAY(country, ','))),
	COUNT(show_id) AS total_content_by_country,
	ROUND(
		COUNT(show_id)::numeric / (SELECT COUNT(show_id) FROM Netflix) * 100, 2
		) AS percentage
FROM netflix
GROUP BY 1
ORDER BY 3 DESC;
