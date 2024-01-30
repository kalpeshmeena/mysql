USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) FROM director_mapping;
-- no of rows= 3867

SELECT COUNT(*) FROM genre;
-- no of rows= 14662

SELECT COUNT(*) FROM names;
-- no of rows = 25735

SELECT COUNT(*) FROM ratings;
-- no of rows = 7997

SELECT COUNT(*) FROM role_mapping;
-- no of rows = 15615
 
SELECT COUNT(*) FROM movie;
-- no of rows = 7997

-- approach 2 solution 
SELECT 
	'role_mapping' 		AS Table_Name, count(*) No_Of_Rows
FROM 
	role_mapping
UNION
SELECT 
	'movie' 			AS Table_Name, count(*) No_Of_Rows 
FROM 
	movie
UNION
SELECT 
	'genre' 			AS Table_Name, count(*) No_Of_Rows
FROM 
	genre
UNION
SELECT 
	'director_mapping' 	AS Table_Name, count(*) No_Of_Rows
FROM 
	director_mapping
UNION
SELECT 
	'names' 		   	AS Table_Name, count(*) No_Of_Rows 
FROM 
	names
UNION
SELECT 
	'Ratings' 		   	AS Table_Name, count(*) No_Of_Rows 
FROM 
	ratings;

    
/* 	Answer to 1st Question:

	Total Rows in Movie Table are = 7997
	Total Rows in Role_Mapping Table are = 15615
	Total Rows in Genre Table are = 14662
	Total Rows in Ratings Table are = 7997
	Total Rows in Director_Mapping Table are = 3867
	Total Rows in Names Table are = 25737
    
*/

-- *********************************************************************************************************************

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
	SUM(
	CASE 
		WHEN id IS NULL THEN 1
		ELSE 0
	END) AS id_null_count,
	
    SUM(
	CASE 
		WHEN title IS NULL THEN 1
		ELSE 0
	END) AS title_null_count,
    
	SUM(
	CASE 
		WHEN year IS NULL THEN 1
		ELSE 0
	END) AS year_null_count,
    
	SUM(
	CASE 
		WHEN date_published IS NULL THEN 1
		ELSE 0
	END) AS Date_Published_Null_Count,
    
    SUM(
	CASE 
		WHEN duration IS NULL THEN 1
		ELSE 0
	END) AS duration_null_count,
    
    SUM(
	CASE 
		WHEN country IS NULL THEN 1
		ELSE 0
	END) AS country_null_count,
    
    SUM(
	CASE 
		WHEN worlwide_gross_income IS NULL THEN 1
		ELSE 0
	END) AS worlwide_gross_income_null_count,
    
    SUM(
	CASE 
		WHEN languages IS NULL THEN 1
		ELSE 0
	END) AS languages_null_count,
    
    SUM(
	CASE 
		WHEN production_company IS NULL THEN 1
		ELSE 0
	END) AS production_company_null_count
    
From movie;

/* 	Answer to 2nd Question:
	
    Below Columns have NULL values in Movie Table:
		1) country 						- 20 	
        2) worlwide_gross_income 		- 3724 	
        3) languages 					- 194	
        4) production_company 			- 528 	
*/


-- *********************************************************************************************************************

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year,
       Count(title) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY year;

--  In Year 2017 highest no. of movies were released i.e, 3052)

-- Number of movies released each month 

SELECT Month(date_published) AS MONTH_NUM,
       Count(*)              AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY month_num
ORDER  BY month_num;

-- March has highest and December has least no. of films released.

-- *********************************************************************************************************************


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT
	COUNT(id) as Number_Of_Movies,year
FROM
	movie
WHERE 
	(upper(country) LIKE '%INDIA%'
          OR upper(country) LIKE '%USA%')
		AND
    year = 2019;

/* Answer to 4th Question:

	Total 1059 movies released in USA or India in the year 2019.

*/

-- *********************************************************************************************************************


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


SELECT DISTINCT genre
FROM   genre; 

/* Answer to 5th Question:
	
    - There are 13 different types of Genre present in table.
*/
-- *********************************************************************************************************************	


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
       count(mov.id) AS number_of_movies
FROM   movie AS mov
       INNER JOIN genre AS gen
               ON gen.movie_id = mov.id
GROUP  BY genre
ORDER  BY number_of_movies DESC
LIMIT  1; 

/* Answer to 6th Question:

	- Drama genre movies are produced highest(4285) overall.
*/

-- *********************************************************************************************************************	

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH one_genre_movie	AS
	(
		SELECT 
			movie_id 		AS Movie_id,
			COUNT(genre) 	AS Num_Genre
		FROM 
			Genre
		GROUP BY
			movie_id
		HAVING
			Num_Genre = 1
	)
SELECT
	COUNT(movie_id) AS single_genre_movies
FROM 
	one_genre_movie;


/* Answer to 7th Question:
	
	There are total 3289 movies belongs to 1 Genre.
    
*/


-- *********************************************************************************************************************	


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       Round(Avg(duration), 2) AS avg_duration
FROM   movie AS mov
       INNER JOIN genre AS gen
               ON gen.movie_id = mov.id
GROUP  BY genre
ORDER  BY avg_duration DESC; 

/* Answer to 8th Question:

	- The Action movies have highest average duration 112.88
    - And Horror movies have lowest average duration 92.72
	- Drama movies have average duration of 106.77
    
*/
-- *********************************************************************************************************************


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_summary AS
(
   SELECT  
      genre,
	  Count(movie_id)                            AS movie_count ,
	  Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
   FROM       genre                                 
   GROUP BY   genre 
   )
SELECT *
FROM   genre_summary
WHERE  genre = "THRILLER" ;

/* Answer to 9th Question:
	 
     - Genre Thriller is ranked at 3 in terms of movies produced overall
*/
-- *********************************************************************************************************************



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS min_median_rating
FROM   ratings; 

/* Answer to 10th Question:
	Min_Avg_Rating 		= 1.0
    Max_Avg_Rating 		= 10.0
	Min_Total_Votes 	= 100
    Max_Total_Votes 	= 725138
    Min_Median_Rating 	= 1
    Max_Median_Rating 	= 10

*/
-- *********************************************************************************************************************


    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT *
FROM   (SELECT m.title                       AS title,
               r.avg_rating                  AS avg_rating,
               rank()
                 OVER (
                   ORDER BY avg_rating DESC) AS movie_rank
        FROM   ratings AS r
               INNER JOIN movie AS m
                       ON r.movie_id = m.id) AS A
WHERE  movie_rank <= 10; 
 
 
/* Answer to 11th Question:

	There are 14 movies which have top 10 ranked.
*/
-- *********************************************************************************************************************


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT
	median_rating 	AS median_rating,
    COUNT(movie_id) AS movie_count
FROM
	ratings
GROUP BY
	median_rating
ORDER BY 
	movie_count;

/* Answer to 12th Question:
	
	 - Median rating 7 has highest number of movies 2257 and 1 has lowest number of movies 94.

*/
-- *********************************************************************************************************************



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
       Count(movie_id)                     AS movie_count,
       rank()
         OVER(
           ORDER BY Count(movie_id) DESC ) AS prod_company_rank
FROM   ratings AS rat
       INNER JOIN movie AS mov
               ON mov.id = rat.movie_id
WHERE  avg_rating > 8
       AND production_company IS NOT NULL
GROUP  BY production_company; 

/* Answer to 13th Question:

	-- production house has produced the most number of hit movies are
		1) Dream Warrior Pictures - 3 Movies
        2) National Theatre Live - 3 Movies

-- **************************************************************************************************************

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT genre,
       Count(mov.id) AS movie_count
FROM   movie AS mov
       INNER JOIN genre AS gen
               ON gen.movie_id = mov.id
       INNER JOIN ratings AS rat
               ON rat.movie_id = mov.id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC;

/* Answer to 14th question:

	- There are 24 Drama genre movies from USA which are released in March 2017
	  and votes are more than 1000
	- There is 1 Family genre movies released in USA which are released in March 2017
	  and votes are more than 1000
      
*/
-- ********************************************************************************************************************* 


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


	SELECT title,
       avg_rating,
       genre
FROM   movie AS mov
       INNER JOIN genre AS gen
               ON gen.movie_id = mov.id
       INNER JOIN ratings AS rat
               ON rat.movie_id = mov.id
WHERE  avg_rating > 8
       AND title LIKE 'THE%'
ORDER  BY avg_rating DESC; 

/* Answer to 15th question:

	- There are 8 movies which starts with word "The" whose avg_rating is more than 8.
	- The "The Brighton Miracle" has highest rating 9.5. 
 */     
-- ********************************************************************************************************************* 


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT Count(id) AS no_of_movies,
       median_rating
FROM   movie m
       LEFT JOIN ratings r
              ON m.id = r.movie_id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP  BY median_rating; 

/* Answer to 16th question:

	- -- There are 361 movies that released between 1 April 2018 and 1 April 2019 and were given a median rating of 8.
      
*/

-- ********************************************************************************************************************* 


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
   country, 
   sum(total_votes) as total_votes
FROM movie AS mov
	INNER JOIN ratings as rat
          ON mov.id=rat.movie_id
WHERE lower(country) = 'germany' or lower(country) = 'italy'
GROUP BY country;

/* Answer to 17th question:

-- From the output we can see that German movies have more votes than Italian movies. 

-- country   total_votes
-- Germany	 106710
-- Italy	 77965
*/

-- ********************************************************************************************************************* 


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT Sum(CASE
             WHEN NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   names; 



/* Answer to 18th question:

    - Below are the columns for which Null values are present
		- Names 			= 0 Nulls
        - Height 			= 17335 Nulls
        - Date_of_birth 	= 13431 Nulls
        - Known_for_movies 	= 15226 Nulls
*/
-- **************************************************************************************************************

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genres AS
(
           SELECT     genre,
                      Count(mov.id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(mov.id) DESC) AS genre_rank
           FROM       movie                                    AS mov
           INNER JOIN genre                                    AS gen
           ON         gen.movie_id = mov.id
           INNER JOIN ratings AS rat
           ON         rat.movie_id = mov.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 )
SELECT     nam.NAME           AS director_name ,
           Count(dm.movie_id) AS movie_count
FROM       director_mapping   AS dm
INNER JOIN genre gen
using      (movie_id)
INNER JOIN names AS nam
ON         nam.id = dm.name_id
INNER JOIN top_3_genres
using      (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3 ;

/* Answer to 19th question:

	-- the top three directors in the top three genres whose movies have an average rating > 8
-- James Mangold	4
-- Anthony Russo	3
-- Soubin Shahir	3


*/

-- ***********************************************************************************************************************************


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT nam.name        AS actor_name,
       Count(movie_id) AS movie_count
FROM   role_mapping AS rm
       INNER JOIN movie AS mov
               ON mov.id = rm.movie_id
       INNER JOIN ratings AS rat USING(movie_id)
       INNER JOIN names AS nam
               ON nam.id = rm.name_id
WHERE  rat.median_rating >= 8
       AND category = 'actor'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 


/* Answer to 20th question:

    - Top 2 actors with median rating 8 and above with movie count are below
		1)  Mammootty	8
		2)  Mohanlal	5

*/

-- ********************************************************************************************************************* 



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     production_company,
           Sum(total_votes)                            AS vote_count,
           Rank() OVER(ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM       movie                                       AS mov
INNER JOIN ratings                                     AS rat
ON         rat.movie_id = mov.id
GROUP BY   production_company limit 3;


/* Answer to 21th question:

    - Top 3 production house based on their votes are 
		1) Marvel Studios
        2) Twentieth Century Fox
        3) Warner Bros.

*/


-- ************************************************************************************************************************


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.NAME                                                           AS actor_name,
       Sum(r.total_votes)                                               AS total_votes,
       Count(DISTINCT r.movie_id)                                       AS movie_count,
       Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actor_avg_rating,
       Rank()
         OVER (
           ORDER BY Round(Sum(r.avg_rating * r.total_votes) /
         Sum(r.total_votes), 2)
         DESC)                                                          AS actor_rank
FROM   names n
       INNER JOIN role_mapping rm
               ON n.id = rm.name_id
       INNER JOIN ratings r
               ON rm.movie_id = r.movie_id
       INNER JOIN movie m
               ON m.id = r.movie_id
WHERE  rm.category = 'actor'
       AND m.country = 'India'
GROUP  BY n.NAME
HAVING movie_count >= 5; 

/* Answer to 22th question:

    - Vijay Sethupathi, Fahadh Faasil and Yogi Babu are top 3 actors in respective order.

*/

-- ********************************************************************************************************************* 



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_detail AS
 (
  SELECT
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating
  FROM
    movie m
    INNER JOIN ratings r ON m.id = r.movie_id
    INNER JOIN role_mapping rm ON m.id = rm.movie_id
    INNER JOIN names n ON rm.name_id = n.id
  WHERE
    UPPER(rm.category) = 'ACTRESS'
    AND UPPER(m.country) = 'INDIA'
    AND UPPER(m.languages) LIKE '%HINDI%'
  GROUP BY
    n.name
  HAVING
    COUNT(r.movie_id) >= 3
)
SELECT
  *,
  RANK() OVER (ORDER BY actress_avg_rating DESC) AS actress_rank
FROM
  actress_detail
LIMIT 5;

/* Answer to 23th question:

    - The top five actresses in Hindi movies released in India based on their average ratings are
			1) Taapsee Pannu
            2) Kriti Sanon
            3) Divya Dutta
            4) Shraddha Kapoor
            5) Kriti Kharbanda
	- Taapsee Pannu tops the list with 7.74 average rating

*/
-- ********************************************************************************************************************


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_movies
     AS (SELECT DISTINCT title,
                         avg_rating
         FROM   movie AS mov
                INNER JOIN ratings AS rat
                        ON mov.id = rat.movie_id
                INNER JOIN genre AS gen
                        ON gen.movie_id = mov.id
         WHERE  genre LIKE 'THRILLER'
         ORDER  BY avg_rating DESC)
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'one-time-watch movies'
         ELSE 'Flop movies'
       END AS avg_rating_category
FROM   thriller_movies; 

/* Answer to 24th question:

    - Above query displayed all Thriller movies in category according to their Avg_Ratings

*/

-- ********************************************************************************************************************* 




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
       Round(Avg(duration), 2)                                AS avg_duration,
       SUM(Round(Avg(duration), 2))
         over(
           ORDER BY genre ROWS unbounded preceding)           AS running_total_duration,
       Round(Avg(Avg(duration))
               over(
                 ORDER BY genre ROWS unbounded preceding), 2) AS moving_avg_duration
FROM   movie AS m
       inner join genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY genre; 

/* Answer to 25th question:

    - Above query shows the genre-wise running total and moving average of the average movie duratione.
    
*/

-- ********************************************************************************************************************* 




-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top3_genre AS
(
         SELECT   genre,
                  Count(movie_id) AS movie_count
         FROM     genre
         GROUP BY genre
         ORDER BY movie_count DESC limit 3 ), top5_movie AS
(
           SELECT     genre,
                      year,
                      title AS movie_name,
                      worlwide_gross_income,
                      Dense_rank() OVER(partition BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
           FROM       movie m
           INNER JOIN genre g
           ON         m.id = g.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top3_genre) )
SELECT *
FROM   top5_movie
WHERE  movie_rank<=5;

/* Answer to 26th question:

    - Above query gives the five highest-grossing movies of each year that belong to the top three genres
    
*/

-- ********************************************************************************************************************* 



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	production_company 						AS production_company,
    COUNT(m.id) 							AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
FROM
	movie 									AS m
    INNER JOIN
    ratings 								AS r
    ON m.id = r.movie_id
WHERE
	median_rating >= 8
		AND
	production_company IS NOT NULL
		AND
	POSITION(',' IN languages) > 0
GROUP BY
	production_company
LIMIT 2;

/* Answer to 27th question:

    - Star Cinema and Twentieth Century Fox are the top 2 production houses that have produced the highest number of hits.
    
*/

-- ********************************************************************************************************************* 



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
	n.name 									AS actress_name,
    SUM(total_votes) 						AS total_votes,
    COUNT(m.id) 							AS movie_count,
    ROUND(AVG(avg_rating),2) 				AS actress_avg_rating,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) AS actress_rank
FROM
	movie 									AS m
    INNER JOIN
    genre 									AS g
    ON m.id = g.movie_id
    INNER JOIN
    ratings 								AS r
    ON m.id = r.movie_id
    INNER JOIN
    role_mapping 							AS ro
    ON m.id = ro.movie_id
    INNER JOIN
    names 									AS n
    ON ro.name_id = n.id
WHERE
	avg_rating > 8
		AND
	genre = 'Drama'
		AND
	category = 'actress'
GROUP BY
	actress_name
LIMIT 3;

/* Answer to 28th question:

    - he top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre
			1) Parvathy Thiruvothu
            2) Susan Brown
            3) Amanda Lawrence
    
*/

-- ********************************************************************************************************************* 



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH Date_Difference_Summary 		AS
	(
		SELECT
			d.name_id,
            n.name,
			d.movie_id,
            duration,
            r.avg_rating,
            total_votes,
            m.date_published,
            DATEDIFF
			(Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published, movie_id) , date_published)
									AS Date_Difference
		FROM
			movie 					AS m
			INNER JOIN
			director_mapping 		AS d
			ON m.id = d.movie_id
			INNER JOIN
			names 					AS n
			ON d.name_id = n.id
            INNER JOIN
            ratings 				AS r
            ON r.movie_id = m.id
	)
SELECT
	name_id 						AS director_id,
    name 							AS director_name,
    COUNT(movie_id) 				AS number_of_movies,
    ROUND(AVG(Date_Difference),2) 	AS avg_inter_movie_days,
    ROUND(AVG(avg_rating),2) 		AS avg_rating,
    SUM(total_Votes) 				AS total_votes,
    MIN(avg_rating) 				AS min_rating,
    MAX(avg_rating) 				AS max_rating,
    SUM(duration) 					AS total_duration
FROM
	Date_Difference_Summary
GROUP BY
	director_id
ORDER BY
	number_of_movies DESC
LIMIT 9;

/* Answer to 29th question:

    - the following are the top 9 directors (based on number of movies)
			1) Andrew Jones
            2) A.L. Vijay
            3) Sion Sono
            4) Chris Stokes
            5) Sam Liu
            6) Steven Soderbergh
            7) Jesse V. Johnson
            8) Justin Price
            9) Özgür Bakar
            
*/

-- ********************************************************************************************************************* 




