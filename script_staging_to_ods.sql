/* SQL-Script to load staging data to ods */

/* Select/use database and schema */
USE DATABASE "EWRR";
USE SCHEMA "EWRR"."ODS_SCHEMA";


/* Truncate tables */
TRUNCATE dim_business;
TRUNCATE dim_timestamp;
TRUNCATE dim_user;
TRUNCATE dim_tip;


/* Loading business data from staging to ods */
INSERT INTO dim_business (business_id, name, address, city, state, postal_code,
                          latitude, longitude, stars, review_count, is_open)
SELECT  yb.business_id, yb.name, yb.address, yb.city, yb.state, yb.postal_code,
        yb.latitude, yb.longitude, yb.stars, yb.review_count, yb.is_open
FROM STAGING_SCHEMA.yelp_business as yb
WHERE yb.business_id NOT IN (SELECT business_id FROM dim_business);


/* Insert timestamps - yelping_since - from user table to timestamps table */
INSERT INTO dim_timestamp (timestamp, date, day, week, month, year)
SELECT yu.yelping_since,
       DATE(yu.yelping_since),
       DAY(yu.yelping_since),
       WEEK(yu.yelping_since),
       MONTH(yu.yelping_since),
       YEAR(yu.yelping_since)
FROM STAGING_SCHEMA.yelp_user as yu
WHERE yu.yelping_since NOT IN (SELECT timestamp FROM dim_timestamp);


/* Loading user data from staging to ods */
INSERT INTO dim_user (user_id, name, review_count, yelping_since, useful, funny, cool, elite, friends,
                      fans, average_stars, compliment_hot, compliment_more, compliment_profile, compliment_cute,
                      compliment_list, compliment_note, compliment_plain, compliment_cool, compliment_funny,
                      compliment_writer, compliment_photos)
       
SELECT yu.user_id, yu.name, yu.review_count, yu.yelping_since, yu.useful, yu.funny, yu.cool, yu.elite, yu.friends,
       yu.fans, yu.average_stars, yu.compliment_hot, yu.compliment_more, yu.compliment_profile, yu.compliment_cute,
       yu.compliment_list, yu.compliment_note, yu.compliment_plain, yu.compliment_cool, yu.compliment_funny,
       yu.compliment_writer, yu.compliment_photos
FROM STAGING_SCHEMA.yelp_user as yu
WHERE yu.user_id NOT IN (SELECT user_id FROM dim_user);


/* Insert timestamps - timestamp - from tip table to timestamps table */
INSERT INTO dim_timestamp (timestamp, date, day, week, month, year)
SELECT yt.timestamp,
       DATE(yt.timestamp),
       DAY(yt.timestamp),
       WEEK(yt.timestamp),
       MONTH(yt.timestamp),
       YEAR(yt.timestamp)
FROM STAGING_SCHEMA.yelp_tip as yt
WHERE yt.timestamp NOT IN (SELECT timestamp FROM dim_timestamp);


/* INSERT tip date from staging to ods */
INSERT INTO dim_tip (user_id, business_id, text, timestamp, compliment_count)
