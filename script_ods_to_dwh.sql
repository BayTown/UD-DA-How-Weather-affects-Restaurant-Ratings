/* SQL-Script to move relevant data form ods to dwh */

/* Select/use database and schema */
USE DATABASE "EWRR";
USE SCHEMA "EWRR"."DWH_SCHEMA";

TRUNCATE dim_business;
TRUNCATE dim_user;
TRUNCATE dim_timestamp;
TRUNCATE dim_temperature;
TRUNCATE dim_precipitation;
TRUNCATE fact_review;

/* move data from ods to dwh for business data */
INSERT INTO dim_business (business_id, name, address, city, state, postal_code, latitude, longitude, stars,
                         review_count, is_open, checkin_date, covid_highlights, covid_delivery_or_takeout,
                         covid_grubhub_enabled, covid_call_to_action_enabled, covid_request_a_quote_enabled,
                         covid_banner, covid_temporary_closed_until, covid_virtual_services_offered)
SELECT  bu.business_id,
        bu.name,
        lo.address,
        lo.city,
        lo.state,
        lo.postal_code,
        lo.latitude,
        lo.longitude,
        bu.stars,
        bu.review_count,
        bu.is_open,
        ch.date,
        co.highlights,
        co.delivery_or_takeout,
        co.grubhub_enabled,
        co.call_to_action_enabled,
        co.request_a_quote_enabled,
        co.covid_banner,
        co.temporary_closed_until,
        co.virtual_services_offered
FROM ODS_SCHEMA.business        AS bu
LEFT JOIN ODS_SCHEMA.location   AS lo ON bu.location_id=lo.location_id
LEFT JOIN ODS_SCHEMA.checkin    AS ch ON bu.business_id=ch.business_id
LEFT JOIN ODS_SCHEMA.covid      AS co ON bu.business_id=co.business_id;

/* move data from ods to dwh for user data */
INSERT INTO dim_user (user_id, name, review_count, yelping_since, useful, funny, cool, elite, friends, fans,
                      average_stars, compliment_hot, compliment_more, compliment_profile, compliment_cute,
                      compliment_list, compliment_note, compliment_plain, compliment_cool, compliment_funny,
                      compliment_writer, compliment_photos)
SELECT  us.user_id,
        us.name,
        us.review_count,
        us.yelping_since,
        us.useful,
        us.funny,
        us.cool,
        us.elite,
        us.friends,
        us.fans,
        us.average_stars,
        us.compliment_hot,
        us.compliment_more,
        us.compliment_profile,
        us.compliment_cute,
        us.compliment_list,
        us.compliment_note,
        us.compliment_plain,
        us.compliment_cool,
        us.compliment_funny,
        us.compliment_writer,
        us.compliment_photos
FROM ODS_SCHEMA.user AS us;

/* move data from ods to dwh for timestamp data */
INSERT INTO dim_timestamp (timestamp, date, day, week, month, year)
SELECT ti.timestamp, ti.date, ti.day, ti.week, ti.month, ti.year
FROM ODS_SCHEMA.table_timestamp AS ti;

/* move data from ods to dwh for temperature data */
INSERT INTO dim_temperature (date, temp_min, temp_max, temp_normal_min, temp_normal_max)
SELECT te.date, te.temp_min, te.temp_max, te.temp_normal_min, te.temp_normal_max
FROM ODS_SCHEMA.temperature AS te;

/* move data from ods to dwh for precipitation data */
INSERT INTO dim_precipitation (date, precipitation, precipitation_normal)
SELECT pr.date, pr.precipitation, pr.precipitation_normal
FROM ODS_SCHEMA.precipitation AS pr;

/* move data from ods to dwh for review data */
INSERT INTO fact_review (review_id, user_id, business_id, stars, useful, funny, cool, text, timestamp, date)
SELECT  re.review_id,
        re.user_id,
        re.business_id,
        re.stars,
        re.useful,
        re.funny,
        re.cool,
        re.text,
        re.timestamp,
        ti.date
FROM ODS_SCHEMA.review AS re
LEFT JOIN ODS_SCHEMA.table_timestamp AS ti ON re.timestamp=ti.timestamp;