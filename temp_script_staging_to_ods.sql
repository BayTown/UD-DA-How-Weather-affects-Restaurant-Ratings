/* SQL-Script to load the data from staging to ODS */

/* Select/use database and schema */
USE DATABASE "EWRR";
USE SCHEMA "EWRR"."ODS_SCHEMA";


TRUNCATE business;
TRUNCATE location;
TRUNCATE table_timestamp;
TRUNCATE user;
TRUNCATE tip;
TRUNCATE checkin;
TRUNCATE covid;
TRUNCATE review;
TRUNCATE temperature;
TRUNCATE precipitation;


/* Loading business data from staging to ods */
INSERT INTO business (business_id, name,  stars, review_count, is_open)
SELECT  yb.business_id, yb.name, yb.address, yb.city, yb.state, yb.postal_code,
        yb.latitude, yb.longitude, yb.stars, yb.review_count, yb.is_open
FROM STAGING_SCHEMA.yelp_business AS yb
WHERE yb.business_id NOT IN (SELECT business_id FROM business);


/* Loading location data from staging to ods*/
INSERT INTO location (address, city, state, postal_code, latitude, longitude)
SELECT DISTINCT yb.address, yb.city, yb.state, yb.postal_code, yb.latitude, yb.longitude
FROM STAGING_SCHEMA.yelp_business AS yb
WHERE yb.business_id NOT IN (SELECT business_id FROM business);


/* Insert timestamps - yelping_since - from user table to timestamps table */
INSERT INTO timestamp (timestamp, date, day, week, month, year)
SELECT yu.yelping_since,
       DATE(yu.yelping_since),
       DAY(yu.yelping_since),
       WEEK(yu.yelping_since),
       MONTH(yu.yelping_since),
       YEAR(yu.yelping_since)
FROM STAGING_SCHEMA.yelp_user AS yu
WHERE yu.yelping_since NOT IN (SELECT timestamp FROM table_timestamp);


/* Loading user data from staging to ods */
INSERT INTO user (user_id, name, review_count, yelping_since, useful, funny, cool, elite, friends,
                      fans, average_stars, compliment_hot, compliment_more, compliment_profile, compliment_cute,
                      compliment_list, compliment_note, compliment_plain, compliment_cool, compliment_funny,
                      compliment_writer, compliment_photos)
       
SELECT yu.user_id, yu.name, yu.review_count, yu.yelping_since, yu.useful, yu.funny, yu.cool, yu.elite, yu.friends,
       yu.fans, yu.average_stars, yu.compliment_hot, yu.compliment_more, yu.compliment_profile, yu.compliment_cute,
       yu.compliment_list, yu.compliment_note, yu.compliment_plain, yu.compliment_cool, yu.compliment_funny,
       yu.compliment_writer, yu.compliment_photos
FROM STAGING_SCHEMA.yelp_user AS yu
WHERE yu.user_id NOT IN (SELECT user_id FROM user);



/* Insert timestamps - timestamp - from tip table to timestamps table */
INSERT INTO table_timestamp (timestamp, date, day, week, month, year)
SELECT yt.timestamp,
       DATE(yt.timestamp),
       DAY(yt.timestamp),
       WEEK(yt.timestamp),
       MONTH(yt.timestamp),
       YEAR(yt.timestamp)
FROM STAGING_SCHEMA.yelp_tip AS yt
WHERE yt.timestamp NOT IN (SELECT timestamp FROM table_timestamp);


/* Insert tip data from staging to ods */
INSERT INTO tip (user_id, business_id, text, timestamp, compliment_count)
SELECT yt.user_id, yt.business_id, yt.text, yt.timestamp, yt.compliment_count
FROM STAGING_SCHEMA.yelp_tip AS yt;


/* Insert checkin data from staging to ods */
INSERT INTO checkin (business_id, date)
SELECT yc.business_id, yc.date
FROM STAGING_SCHEMA.yelp_checkin AS yc;

/* Insert covid data from staging to ods */
INSERT INTO covid (business_id, highlights, delivery_or_takeout, grubhub_enabled,
                       call_to_action_enabled, request_a_quote_enabled, covid_banner,
                       temporary_closed_until, virtual_services_offered)
SELECT yc.business_id, yc.highlights, yc.delivery_or_takeout, yc.grubhub_enabled,
       yc.call_to_action_enabled, yc.request_a_quote_enabled, yc.covid_banner,
       yc.temporary_closed_until, yc.virtual_services_offered
FROM STAGING_SCHEMA.yelp_covid AS yc;

/* Insert timestamps - timestamp - from tip table to timestamps table */
INSERT INTO table_timestamp (timestamp, date, day, week, month, year)
SELECT yr.timestamp,
       DATE(yr.timestamp),
       DAY(yr.timestamp),
       WEEK(yr.timestamp),
       MONTH(yr.timestamp),
       YEAR(yr.timestamp) 
FROM STAGING_SCHEMA.yelp_review AS yr
WHERE yr.timestamp NOT IN (SELECT timestamp FROM table_timestamp);


/* Insert fact data - review - from staging to ods */
INSERT INTO review (review_id, user_id, business_id, stars, useful,
                         funny, cool, text, timestamp)
SELECT  yr.review_id, yr.user_id, yr.business_id, yr.stars, yr.useful,
        yr.funny, yr.cool, yr.text, yr.timestamp
FROM STAGING_SCHEMA.yelp_review AS yr
WHERE yr.review_id NOT IN (SELECT review_id FROM review);

/* Insert temperature data from staging to ods */
INSERT INTO temperature (date, temp_min, temp_max, temp_normal_min, temp_normal_max)
SELECT ct.date, ct.min, ct.max, ct.normal_min, ct.normal_max
FROM STAGING_SCHEMA.climate_temp AS ct;

/* Insert precipitation data from staging to ods */
INSERT INTO precipitation (date, precipitation, precipitation_normal)
SELECT cp.date, TRY_CAST(cp.precipitation AS FLOAT), cp.precipitation_normal
FROM STAGING_SCHEMA.climate_prec AS cp;
