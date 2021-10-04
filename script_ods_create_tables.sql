/* SQL-Script to create or replace the tables for the ODS */

/* Select/use database and schema */
USE DATABASE "EWRR";
USE SCHEMA "EWRR"."ODS_SCHEMA";

/* Table dim_business */
CREATE OR REPLACE TABLE dim_business (
    business_id     TEXT            PRIMARY KEY,
    name            TEXT,
    address         TEXT,
    city            TEXT,
    state           TEXT,
    postal_code     INT,
    latitude        FLOAT,
    longitude       FLOAT,
    stars           NUMERIC(3,2),
    review_count    INT,
    is_open         BOOLEAN
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
    compliment_photos   INT,
    CONSTRAINT FK_TI_ID FOREIGN KEY(yelping_since)      REFERENCES  dim_timestamp(timestamp)
);

/* Table dim_tip */
CREATE OR REPLACE TABLE dim_tip (
    tip_id              INT         PRIMARY KEY     IDENTITY,
    user_id             TEXT,
    business_id         TEXT,
    text                TEXT,
    timestamp           DATETIME,
    compliment_count    INT,
    CONSTRAINT FK_US_ID FOREIGN KEY(user_id)        REFERENCES  dim_user(user_id),
    CONSTRAINT FK_BU_ID FOREIGN KEY(business_id)    REFERENCES  dim_business(business_id),
    CONSTRAINT FK_TI_ID FOREIGN KEY(timestamp)      REFERENCES  dim_timestamp(timestamp)
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
    text                BOOLEAN,
    timestamp           DATETIME,
    CONSTRAINT FK_US_ID FOREIGN KEY(user_id)        REFERENCES  dim_user(user_id),
    CONSTRAINT FK_BU_ID FOREIGN KEY(business_id)    REFERENCES  dim_business(business_id),
    CONSTRAINT FK_TI_ID FOREIGN KEY(timestamp)      REFERENCES  dim_timestamp(timestamp)
);

/* Table dim_checkin */
CREATE OR REPLACE TABLE dim_checkin (
    checkin_id          INT     PRIMARY KEY,
    business_id         TEXT,
    date                TEXT,
    CONSTRAINT FK_BU_ID FOREIGN KEY(business_id)    REFERENCES  dim_business(business_id)
);

/* Table dim_covid */
CREATE OR REPLACE TABLE dim_covid (
    covid_id                    INT     PRIMARY KEY,
    business_id                 TEXT,
    highlights                  TEXT,
    delivery_or_takeout         TEXT,
    grubhub_enabled             TEXT,
    call_to_action_enabled      TEXT,
    request_a_quote_enabled     TEXT,
    covid_banner                TEXT,
    temporary_closed_until      TEXT,
    virtual_services_offered    TEXT,
    CONSTRAINT FK_BU_ID         FOREIGN KEY(business_id)    REFERENCES  dim_business(business_id)
);