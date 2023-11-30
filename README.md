# Data Sharing Demo

## This is the repository for the Share Sharing Demo for the Perth STUG Build Event 2023-11-30

## What you'll build

![Alt text](images/Demo-Setup.png)

#### What you'll need to setup the demo locally

- A Snowflake account [Get started for free](https://www.snowflake.com/en/)
- An instance of Kafka with the ability to setup Kafka Connect with the [Snowflake connector](https://docs.snowflake.com/en/user-guide/kafka-connector)

## Step 1 - Setup Kafka User and Schema

- Create the user account for the Kafka Connect user. _KAFKA_CONNECT_EMOJI_USER_
- [Generate the Key Pair for authentication](https://docs.snowflake.com/en/user-guide/kafka-connector-install#using-key-pair-authentication-key-rotation)
- [Set the public key for the account](sql/kafka_connect/setup_public_key.sql)
- Follow the [instructions](https://docs.snowflake.com/en/user-guide/kafka-connector-install) to install the Snowflake Kafka Connect
- [SQL File to create the role.](sql/kafka_connect/setup_user.sql)
- Edit the [sample](sql/kafka_connect/config.json) Kafka Connect configuration file

## Step 2 - Activate the connector.

```
curl -X POST -H "Content-Type: application/json" --data @/tmp/config.json http://localhost:8083/connectors
```

- To remove the connector

```
curl -X DELETE http://localhost:8083/connectors/EmojiDesignsData
```

## Step 3 - Setup the sample data and generator
