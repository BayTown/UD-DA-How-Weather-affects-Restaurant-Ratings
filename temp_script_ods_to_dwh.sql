/* SQL-Script to move relevant data form ods to dwh */

/* Select/use database and schema */
USE DATABASE "EWRR";
USE SCHEMA "EWRR"."DWH_SCHEMA";

/*SQL queries code that reports the business name, temperature, precipitation, and ratings.*/
INSERT INTO dwh_avg_rating_per_day_portland (date, business_name, avg_stars, temp_min, temp_max, precipitation, precipitation_normal)
SELECT dti.date, db.name, AVG(fr.stars) AS avg_stars, dte.temp_min, dte.temp_max, dtp.precipitation, dtp.precipitation_normal
FROM ODS_SCHEMA.fact_review             AS fr
LEFT JOIN ODS_SCHEMA.dim_timestamp      AS dti ON fr.timestamp=dti.timestamp
LEFT JOIN ODS_SCHEMA.dim_business       AS db  ON fr.business_id=db.business_id
LEFT JOIN ODS_SCHEMA.dim_temperature    AS dte ON dti.date=dte.date
LEFT JOIN ODS_SCHEMA.dim_precipitation  AS dtp ON dti.date=dtp.date
WHERE db.city='Portland' AND db.state='OR'
GROUP BY dti.date, db.name, dte.temp_min, dte.temp_max, dtp.precipitation, dtp.precipitation_normal
ORDER BY dti.date DESC;


/* Show results */
SELECT * FROM dwh_avg_rating_per_day_portland;