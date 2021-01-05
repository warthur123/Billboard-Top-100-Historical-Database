CREATE OR REPLACE VIEW `MostLyrics` AS
	SELECT 
		song_name, 
        artist_name, 
        LENGTH(lyrics_text) - LENGTH(REPLACE(lyrics_text, ' ', '')) + 1 AS '# of lyrics'
	FROM lyrics
	JOIN songs USING(song_id)
    JOIN song_artists USING(song_id)
	JOIN artists USING(artist_id)
    ORDER BY LENGTH(lyrics_text) - LENGTH(REPLACE(lyrics_text, ' ', '')) + 1 DESC;

CREATE OR REPLACE VIEW `Top10` AS
	SELECT 
		artist_name, 
        song_name
	FROM (SELECT song_id, week_position FROM weekly_rankings WHERE week_position < 11) top10
	JOIN songs USING(song_id)
    JOIN song_artists USING(song_id)
	JOIN artists USING(artist_id)
	GROUP BY artist_id, song_id;

CREATE OR REPLACE VIEW `FirstWord` AS
	SELECT 
		SUBSTRING(song_name,  1, LOCATE(' ', song_name) - 1) 'First word', 
        COUNT(song_id) '# of songs with same first word in title'
	FROM songs
	WHERE SUBSTRING(song_name,  1, LOCATE(' ', song_name) - 1) != ''
	GROUP BY SUBSTRING(song_name,  1, LOCATE(' ', song_name) - 1)
	ORDER BY COUNT(song_id) DESC;

CREATE OR REPLACE VIEW `BetterThanAvgPeakPos` AS
	SELECT artist_name, song_name, peak_position
    FROM weekly_rankings
    JOIN songs USING(song_id)
    JOIN song_artists USING(song_id)
    JOIN artists USING(artist_id)
    WHERE peak_position < (SELECT AVG(peak_position) FROM weekly_rankings)
    ORDER BY song_name;
	
CREATE OR REPLACE VIEW `ArtistsWith2+Songs` AS 
	SELECT 
		artist_name, 
        COUNT(DISTINCT song_id) AS '# of songs'
	FROM song_artists
	JOIN artists USING(artist_id)
	GROUP BY artist_id
    HAVING COUNT(DISTINCT song_id) > 2
	ORDER BY COUNT(DISTINCT song_id) DESC;