/* SQL-Script to create or replace the tables for the DWH */

/* Select/use database and schema */
USE DATABASE "EWRR";
USE SCHEMA "EWRR"."DWH_SCHEMA";

/* Table dwh_avg_rating_per_day_portland */
/* Data Warehouse table with average rating per business per day in Portland, Oregon */
CREATE OR REPLACE TABLE dwh_avg_rating_per_day_portland (
    date                    DATE,
    business_name           TEXT,
    avg_stars               FLOAT,
    temp_min                INT,
    temp_max                INT,
    precipitation           FLOAT,
    precipitation_normal    FLOAT
);