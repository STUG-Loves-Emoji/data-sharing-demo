-- Lets create the base dynamic table

create or replace dynamic table emoji.data.suburbs
TARGET_LAG = "Downstream"
WAREHOUSE = "🎬"
AS
select 
    record_content:emoji as suburb_emoji,
    to_timestamp_ltz(record_metadata:CreateTime::varchar) as createtime,
    record_content:value as suburb
from emoji.kafka_schema.table1 where record_content:type = 'suburb';


-- Let Verify that we have some data in the table
select 
    count(*) as most_popular_suburb,
    suburb_emoji,
    suburb 
from emoji.data.suburbs
group by all
order by 1 desc
;



-- Now lets create the popularity table for the suburbs
create or replace dynamic table emoji.data.suburbs_popularity
TARGET_LAG = "5 minutes"
WAREHOUSE = "🎬"
AS
select 
    count(*) as most_popular_suburb,
    suburb_emoji,
    suburb 
from emoji.data.suburbs
group by all;


-- and we can now see if we have data in there
select * 
from emoji.data.suburbs_popularity
order by most_popular_suburb desc;





---

Dataset of Emoji-Based Suburb Names

This dataset is a collection of suburb names represented entirely by emojis. It provides a unique perspective on geographic locations, offering a creative and visually engaging way to identify neighborhoods. The dataset comprises 44 distinct suburb names, each represented by a combination of expressive emojis.

Potential Use Cases:

Geographic Information Systems (GIS): Integrate emoji-based suburb names into GIS applications for enhanced visualization and accessibility.

Location-Based Services (LBS): Utilize emoji-based suburb names in LBS platforms to provide a more engaging and user-friendly experience.

Linguistics and Semiotics: Research the linguistic and semiotic aspects of emoji-based suburb names, exploring the relationship between emojis and place names.

Creative Writing and Storytelling: Leverage emoji-based suburb names as inspiration for creative writing and storytelling, incorporating them into fictional settings or narratives.

Data Characteristics:

Data Format: CSV (Comma-Separated Values)

Variables: Suburb Name (emoji representation)

Data Size: 44 records

Data Collection Method: Manual curation

Additional Notes:

The dataset is limited to 44 suburbs, but it can be expanded to include more locations.

The dataset can be enriched by incorporating additional information, such as suburb descriptions, coordinates, or demographic data.

The dataset can be used to train machine learning models for tasks such as emoji-based suburb recognition or natural language processing.
