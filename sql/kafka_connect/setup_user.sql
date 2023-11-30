-- Use a role that can create and manage roles and privileges.
USE ROLE securityadmin;

-- Create a Snowflake role with the privileges to work with the connector.
CREATE ROLE kafka_connector_role_1;

-- Grant privileges on the database.
GRANT USAGE ON DATABASE EMOJI TO ROLE kafka_connector_role_1;

-- Grant privileges on the schema.
use database emoji;
GRANT USAGE ON SCHEMA kafka_schema TO ROLE kafka_connector_role_1;
GRANT CREATE TABLE ON SCHEMA kafka_schema TO ROLE kafka_connector_role_1;
GRANT CREATE STAGE ON SCHEMA kafka_schema TO ROLE kafka_connector_role_1;
GRANT CREATE PIPE ON SCHEMA kafka_schema TO ROLE kafka_connector_role_1;

-- Only required if the Kafka connector will load data into an existing table.
-- GRANT OWNERSHIP ON TABLE existing_table1 TO ROLE kafka_connector_role_1;

-- Only required if the Kafka connector will stage data files in an existing internal stage: (not recommended).
-- GRANT READ, WRITE ON STAGE existing_stage1 TO ROLE kafka_connector_role_1;

-- Grant the custom role to an existing user.
GRANT ROLE kafka_connector_role_1 TO USER KAFKA_CONNECT_EMOJI_USER;

-- Set the custom role as the default role for the user.
-- If you encounter an 'Insufficient privileges' error, verify the role that has the OWNERSHIP privilege on the user.
ALTER USER KAFKA_CONNECT_EMOJI_USER SET DEFAULT_ROLE = kafka_connector_role_1;


-- use database emoji;
-- create schema kafka_schema;