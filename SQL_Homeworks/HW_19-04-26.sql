--Topic 4 — Column Aliases with AS →
DROP TABLE movies;
CREATE TABLE movies (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  genre TEXT NOT NULL,
  year INTEGER NOT NULL,
  rating REAL,
  minutes INTEGER
);

INSERT INTO movies (id, title, genre, year, rating, minutes) VALUES
  (1, 'Metro Rush', 'Action', 2005, 7.9, 118),
  (2, 'Quiet Lake', 'Drama', 2012, 8.1, 124),
  (3, 'Night Pulse', 'Horror', 2018, 6.8, 95),
  (4, 'Skyline Code', 'Action', 2021, 7.4, 109),
  (5, 'Tiny Planet', 'Family', 2010, 7.1, 86);


-- Select title, genre, and year with aliases: movie_name, type, release_year
-- Add computed column rating_bucket = rating * 10 and alias it
-- Sort by rating_bucket descending, then movie_name ascending
SELECT
  title AS movie_name,
  genre AS type,
  year AS release_year,
  rating*10 AS rating_bucket
FROM movies
ORDER by rating_bucket DESC , movie_name ASC;
--movie_name     type    release_year  rating_bucket

--Quiet Lake     Drama	   2012	          81.0
--Metro Rush	 Action	   2005	          79.0
--Skyline Code	 Action	   2021	          74.0
--Tiny Planet	 Family	   2010	          71.0
--Night Pulse	 Horror	   2018	          68.0


-- Try a second version without aliases and compare readability
SELECT * FROM movies
ORDER by rating DESC , title ASC;
--2	Quiet Lake	   Drama	2012	8.1	  124
--1	Metro Rush	   Action	2005	7.9	  118
--4	Skyline Code   Action	2021	7.4	  109
--5	Tiny Planet	   Family	2010	7.1	  86
--3	Night Pulse	   Horror	2018	6.8	  95




--Topic 5 — DISTINCT →
DROP TABLE movies_1;
CREATE TABLE movies_1 (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  genre TEXT NOT NULL,
  year INTEGER NOT NULL,
  language TEXT NOT NULL
);

INSERT INTO movies_1 (id, title, genre, year,language) VALUES
  (1, 'Metro Rush', 'Action', 2005, 'English'),
  (2, 'Quiet Lake', 'Drama', 2012, 'English'),
  (3, 'Night Pulse', 'Horror', 2018, 'Spanish'),
  (4, 'Skyline Code', 'Action', 2021, 'English'),
  (5, 'Tiny Planet', 'Family', 2010, 'French'),
  (6, 'Silver Track', 'Thriller', 2016, 'Spanish'),
  (7, 'Golden Path', 'Drama', 2016, 'French');

--Return the languages (no duplicaiton)
SELECT DISTINCT language
FROM movies_1;
--English
--Spanish
--French


--Return the years (no duplicaiton) where genre is Drama or Action
SELECT DISTINCT year
FROM movies_1
WHERE genre = 'Drama' or genre = 'Action';
--2005
--2012
--2021
--2016


--Return genre-language pairs (no duplicaiton) sorted by language
SELECT DISTINCT genre, language
FROM movies_1
ORDER by language;
--Action	English
--Drama	English
--Family	French
--Drama	French
--Horror	Spanish
--Thriller	Spanish


--Bonus: return count of distinct genres using COUNT(DISTINCT genre)
SELECT count(DISTINCT genre)
FROM movies_1;
--5


--Topic 6 — Netflix Practice Lab →

--Use DISTINCT to list all values from type
SELECT DISTINCT type
FROM netflix_movies_detailed_up_to_2025;

--Use DISTINCT to list 20 non-empty cast entries from Action movies
SELECT DISTINCT title, genres, "cast"
FROM netflix_movies_detailed_up_to_2025
WHERE type = 'Movie'
  AND genres LIKE '%Action%'
  AND "cast" IS NOT NULL
LIMIT 20;


--Find 5 action movies released after 2015
SELECT title, genres, release_year
FROM netflix_movies_detailed_up_to_2025
WHERE type = 'Movie'
  AND genres LIKE '%Action%'
  AND release_year > 2015
ORDER BY release_year DESC
LIMIT 5;

--Sort by highest rating first
SELECT title, rating
FROM netflix_movies_detailed_up_to_2025
ORDER BY rating DESC;

--Alias output columns as movie and score
SELECT
  title AS movie,
  rating AS score
FROM  netflix_movies_detailed_up_to_2025;

--Bonus: find drama titles where cast is NULL
SELECT title,genres,"cast"
FROM netflix_movies_detailed_up_to_2025
WHERE type = 'Movie'
  AND genres LIKE '%Drama%'
  AND "cast" IS  NULL;



