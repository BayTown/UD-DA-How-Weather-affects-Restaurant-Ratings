/* SQL-Script to create or replace the tables for the ODS */

/* Select/use database and schema */
USE DATABASE "EWRR";
USE SCHEMA "EWRR"."DWH_SCHEMA";

/* Table dim_business */
CREATE OR REPLACE TABLE dim_business (
    business_id                     TEXT            PRIMARY KEY,
    name                            TEXT,
    address                         TEXT,
    city                            TEXT,
    state                           TEXT,
    postal_code                     INT,
    latitude                        FLOAT,
    longitude                       FLOAT,
    stars                           NUMERIC(3,2),
    review_count                    INT,
    is_open                         BOOLEAN,
    checkin_date                    TEXT,
    covid_highlights                TEXT,
    covid_delivery_or_takeout       TEXT,
    covid_grubhub_enabled           TEXT,
    covid_call_to_action_enabled    TEXT,
    covid_request_a_quote_enabled   TEXT,
    covid_banner                    TEXT,
    covid_temporary_closed_until    TEXT,
    covid_virtual_services_offered  TEXT
);

/* Table dim_timestamp */
CREATE OR REPLACE TABLE dim_timestamp (
    timestamp           DATETIME    PRIMARY KEY,
    date                DATE,
    day                 INT,
    week                INT,
    month               INT,
    year                INT 
);

/* Table dim_user */
CREATE OR REPLACE TABLE dim_user (
    user_id             TEXT            PRIMARY KEY,
    name                TEXT,
    review_count        INT,
    yelping_since       DATETIME,
    useful              INT,
    funny               INT,
    cool                INT,
    elite               TEXT,
    friends             TEXT,
    fans                INT,
    average_stars       NUMERIC(3,2),
    compliment_hot      INT,
    compliment_more     INT,
    compliment_profile  INT,
    compliment_cute     INT,
    compliment_list     INT,
    compliment_note     INT,
    compliment_plain    INT,
    compliment_cool     INT,
    compliment_funny    INT,
    compliment_writer   INT,
    compliment_photos   INT
);

/* Table dim_temperature */
CREATE OR REPLACE TABLE dim_temperature (
    date                        DATE     PRIMARY KEY,
    temp_min                    FLOAT,
    temp_max                    FLOAT,
    temp_normal_min             FLOAT,
    temp_normal_max             FLOAT
);

/* Table dim_precipitation */
CREATE OR REPLACE TABLE dim_precipitation (
    date                        DATE     PRIMARY KEY,
    precipitation               FLOAT,
    precipitation_normal        FLOAT
);

/* Table fact_review */
CREATE OR REPLACE TABLE fact_review (
    review_id           TEXT        PRIMARY KEY,
    user_id             TEXT,
    business_id         TEXT,
    stars               NUMERIC(3,2),
    useful              BOOLEAN,
    funny               BOOLEAN,
    cool                BOOLEAN,
    text                TEXT,
    timestamp           DATETIME,
    date                DATE,
    CONSTRAINT FK_US_ID FOREIGN KEY(user_id)        REFERENCES  dim_user(user_id),
    CONSTRAINT FK_BU_ID FOREIGN KEY(business_id)    REFERENCES  dim_business(business_id),
    CONSTRAINT FK_TI_ID FOREIGN KEY(timestamp)      REFERENCES  dim_timestamp(timestamp),
    CONSTRAINT FK_TE_ID FOREIGN KEY(date)           REFERENCES  dim_temperature(date),
    CONSTRAINT FK_PR_ID FOREIGN KEY(date)           REFERENCES  dim_precipitation(date)
);