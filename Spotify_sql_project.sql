-- SQL Project -- Spotify Datasets

CREATE TABLE spotify (
		Artist VARCHAR(255),
		Track VARCHAR(255),
		Album VARCHAR(255),
		Album_type VARCHAR(255),
		Danceability FLOAT,
		Energy FLOAT,
		Loudness FLOAT,
		Speechiness	FLOAT,
		Acousticness FLOAT,
		Instrumentalness FLOAT,	
		Liveness FLOAT,	
		Valence	FLOAT,
		Tempo FLOAT,
		Duration_min FLOAT,
		Title VARCHAR(255),
		Channel VARCHAR(255),	
		Views FLOAT,
		Likes BIGINT,
		Comments BIGINT,
		Licensed BOOLEAN,
		official_video BOOLEAN,
		Stream BIGINT,
		EnergyLiveness FLOAT,
		most_played_on VARCHAR(50)
);

-- EDA

SELECT COUNT(*) FROM spotify;


SELECT COUNT(DISTINCT Artist)
FROM spotify;


SELECT COUNT(DISTINCT Album)
FROM spotify;


SELECT DISTINCT Album_type
FROM spotify;


SELECT COUNT(DISTINCT Title) 
FROM spotify;	


SELECT MAX(duration_min)
FROM spotify;

SELECT MIN(duration_min)
FROM spotify;

SELECT *
FROM spotify
WHERE duration_min =0;

DELETE FROM spotify
WHERE duration_min =0;


SELECT DISTINCT channel
FROM spotify;

SELECT DISTINCT most_played_on
FROM spotify;


-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Basic Level Business Questions

-- Q1: Retrevie the names of all tracks that have more than 1 billion streams.
SELECT *
FROM spotify
WHERE stream > 1000000000;


-- Q2: List all albums along with their respective artists.
SELECT 
    DISTINCT Album,
	Artist
FROM spotify
ORDER BY 1;

-- Q3: Get the total number of comments for tracks where licensed = True.
SELECT 
    SUM(comments) AS total_comments
FROM spotify
WHERE licensed = 'true'

-- Q4 Find all tracks that belong to the album type single.
SELECT *
FROM spotify
WHERE album_type='single';

-- Q5 Count the total number of tracks by each artist.
SELECT 
	Artist,
	COUNT(*) AS total_number
FROM spotify
GROUP BY 1
ORDER BY 2;

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Medium Level Questions

--Q6: Calculate the average danceability of tracks in each album.
SELECT 
	Album,
	AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;

--Q7: Find the top 5 tracks with the highest engery values.
SELECT 
	track,
	MAX(energy) AS highest_energy
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q8: List all tracks along with their views and likes where official_video = True
SELECT 
	track,
	views,
	likes
FROM spotify
WHERE official_video = 'true'


--Q9: For each album, calculate the total views of all associated tracks.
SELECT 
	Album,
	track,
	SUM(views) AS total_views
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC;

--Q10: Retrieve the track names that have been streamed on spotify more than youtube.
SELECT *
FROM(
SELECT 
	track,
	COALESCE(SUM(CASE WHEN most_played_on ='Youtube' THEN stream END),0) AS streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on ='Spotify' THEN stream END),0) AS streamed_on_spotify
FROM spotify
GROUP BY 1
)t1
WHERE streamed_on_spotify>streamed_on_youtube
AND streamed_on_youtube <>0;


-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Advance Questions

--Q11: Find the top 3 most-viewed tracks for each artist using window functions.
WITH ranking_artist AS(
SELECT 
	artist,
	track,
	SUM(views) AS total_views,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rnk
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
) 
SELECT *
FROM ranking_artist
WHERE rnk <=3;


--Q12: write a query to find tracks where the liveness score is above the average.
SELECT 
	track,
	artist,
	liveness
FROM spotify
WHERE liveness> (SELECT AVG(liveness) FROM spotify);


--Q13: Use a With Clause to calculate the difference between the highest an lowest energy values for tracks in each album.
WITH CTE AS(
SELECT 
	Album,
	MAX(energy) AS highest_energy,
	MIN(energy) AS lowest_energy
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy-lowest_energy AS energy_diff
FROM CTE
ORDER BY 2 DESC;

-- -------------------------------------------- Project  end --------------------------------------------------------------------------------------