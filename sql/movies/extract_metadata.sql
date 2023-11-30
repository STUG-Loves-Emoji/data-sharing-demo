-- This assumes the raw metadata is in the tmdb_raw table

-- create or replace TABLE EMOJI.MOVIES.TMDB_RAW (
-- 	DATA VARIANT
-- );

-- Use Load Data to upload the sample tmdb_api json

create
or replace table emoji.movies.tmdb_metadata as
SELECT
    data:Results [0] :original_title as original_title,
    concat(
        'https://image.tmdb.org/t/p/original/',
        data:Results [0] :poster_path
    ) as poster,
    to_date(data:Results [0] :release_date) as release_date,
    data:Results [0] :title as title,
    data:Results [0] :overview as overview,
    concat(
        'https://image.tmdb.org/t/p/original/',
        data:Results [0] :backdrop_path
    ) as backdrop_path,
    data:Results [0] :id as id
FROM
    TMDB_RAW
where
    data:Results [0] :original_title is not null;
select
    *
from
    emoji.movies.tmdb_metadata;