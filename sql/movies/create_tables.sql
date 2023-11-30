-- Lets create the base dynamic table

create or replace dynamic table emoji.data.movies
TARGET_LAG = "Downstream"
WAREHOUSE = "🎬"
AS
select 
    record_content:emoji::varchar as movie_emoji,
    to_timestamp_ltz(record_metadata:CreateTime::varchar) as createtime,
    record_content:value::varchar as movie_name
from emoji.kafka_schema.table1 where record_content:type = 'movie';


-- Let Verify that we have some data in the table
select 
    count(*) as most_popular_movie,
    movie_emoji,
    movie_name 
from emoji.data.movies
group by all
order by 1 desc
;



-- Now lets create the popularity table for the movies
create or replace dynamic table emoji.data.movie_popularity
TARGET_LAG = "5 minutes"
WAREHOUSE = "🎬"
AS
select 
    count(*) as most_popular_movie,
    movie_emoji,
    movie_name 
from emoji.data.movies
group by all;


-- and we can now see if we have data in there
select * 
from emoji.data.movie_popularity
order by most_popular_movie desc;


-- Now lets enrich the movie details
create or replace dynamic table emoji.data.movie_details
TARGET_LAG = "5 minutes"
WAREHOUSE = "🎬"
AS
select movie_emoji as emoji, src.most_popular_movie as views, meta.* from emoji.data.movie_popularity src
join emoji.movies.tmdb_metadata meta
on lower(src.movie_name) = lower(meta.title)
;


-- and we can now see if we have data in there
select *
from emoji.data.movie_details
order by views desc
;



---

Introducing the Emoji Movie Title Dataset: A Collection of Creative and Enigmatic Movie Titles Represented Entirely by Emojis

This unique dataset showcases the versatility and expressiveness of emojis by capturing the essence of popular movie titles using only these colorful icons. The dataset comprises a diverse range of movie genres, from action-packed blockbusters to heartwarming comedies, all represented through a series of carefully selected emojis.

Dataset Highlights:

Creative and Engaging: The emoji-based representation of movie titles adds a fun and interactive element to the dataset, challenging users to decipher the titles and sparking curiosity.
Diverse Genres: The dataset encompasses a wide variety of movie genres, ensuring that there is something for everyone to enjoy.
Educational Potential: The dataset can be used to enhance vocabulary, improve emoji recognition, and foster creativity.
Potential Use Cases:

Data Visualization: Create visually appealing data visualizations to explore the popularity of different genres or identify patterns in emoji usage.
Machine Learning Applications: Train machine learning models to predict movie titles based on emoji sequences or to generate new emoji-based movie titles.
Educational Resources: Utilize the dataset in educational settings to teach about emojis, genres, and creativity.
Games and Entertainment: Develop interactive games and puzzles that challenge users to decode emoji movie titles.
Dataset Value:

The Emoji Movie Title Dataset offers a novel and engaging way to represent movie titles, providing a valuable resource for researchers, developers, and individuals seeking to explore the creative potential of emojis. With its diverse collection of emoji-based titles, the dataset holds immense potential for educational, entertainment, and research purposes.

Unlock the Power of Emojis and Discover the Hidden World of Emoji Movie Titles

Embrace the creativity and expressiveness of emojis with the Emoji Movie Title Dataset. Let your imagination run wild as you decipher these enigmatic titles and delve into the captivating world of cinema, one emoji at a time.