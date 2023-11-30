# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session

# Write directly to the app
st.title("Movie Emoji Viewer")
st.write(
    """Let's look at the top 3 most popular movies.
    """
)

# Get the current credentials
session = get_active_session()

sql = f"""select *
from emoji.data.movie_details
order by views desc
limit 3
"""

data = session.sql(sql).collect()

for i in data:
    st.title(i["TITLE"])
    st.image(i["POSTER"], width = 400)
    st.caption(i["OVERVIEW"])