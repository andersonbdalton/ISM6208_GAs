
-- Use ROLLUP to get aggregate of crimes by type by year:
SELECT YEAR_ONLY, CRIMETYPE, COUNT(*) as TOTAL_CRIMES
FROM PEARL_CHICAGO
GROUP BY ROLLUP (YEAR_ONLY, CRIMETYPE);

-- USE CUBE to get crimes per year per arrest status, 
-- as well as the total number of crimes per location description
SELECT YEAR_ONLY, ARREST, LOCATION_DESCRIPTION, COUNT(*) as TOTAL_CRIMES
FROM PEARL_CHICAGO
GROUP BY CUBE (YEAR_ONLY, ARREST), LOCATION_DESCRIPTION
ORDER BY TOTAL_CRIMES DESC;

-- Use both ROLLUP and CUBE to get the total crimes per district, 
-- per description of the crime, and across all descriptions and districts:
SELECT DISTRICT, DESCRIPTION, COUNT(*) as TOTAL_CRIMES
FROM PEARL_CHICAGO
GROUP BY ROLLUP (DISTRICT), CUBE (DESCRIPTION)
ORDER BY TOTAL_CRIMES DESC;

SELECT student_name, score,
       RANK() OVER (ORDER BY score DESC) AS rank,
       DENSE_RANK() OVER (ORDER BY score DESC) AS dense_rank
FROM student_scores;



SELECT * 
FROM bullflix.ML_RATINGS;

SELECT * 
FROM bullflix.movies_vw;

SELECT * 
FROM bullflix.ratings_vw;

/*In this query, the NTILE function is applied to the imdb_rating column 
The NTILE(5) specifies that the ratings will be divided into 5 equal-sized bins. 
The ORDER BY imdb_rating DESC orders the movies based on their IMDb ratings in descending order.
*/

SELECT movie_title, imdb_rating,
       NTILE(5) OVER (ORDER BY imdb_rating DESC) AS rating_bin
FROM bullflix.movies_vw;

/*
bin 1 is from top (9.3) to 8.01
bin 2 is from 8 to 7.1
bin 3 is from 7.2 to 6.6
bin 4 is from 6.6 to 6
bin 5 is from > 6

Using the NTILE function, you can create bins or groups based on specific criteria, 
such as ratings, votes, or any other numeric attribute in your dataset. 
NTILE allows you to analyze and compare movies within each bin, providing insights across different groups.
*/



/*In this query, the CORR function is applied to the imdb_votes and imdb_rating columns. 
CORR is used to calculate the correlation coefficient between the number of IMDb votes and the IMDb rating.
*/

SELECT
    CORR(imdb_votes, imdb_rating) AS vote_rating_correlation,
    CORR(imdb_votes, release_year) AS vote_year_correlation
FROM bullflix.movies_vw;

/*By using the CORR function, you can analyze the relationship between different attributes in your dataset
and uncover patterns or dependencies between variables.
*/

