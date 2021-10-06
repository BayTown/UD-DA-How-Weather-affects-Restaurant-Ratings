/* Select/use database and schema */
USE DATABASE "EWRR";
USE SCHEMA "EWRR"."DWH_SCHEMA";

/*SQL queries code that reports the business name, temperature, precipitation, and ratings.*/
SELECT fr.date, db.name, AVG(fr.stars) AS avg_stars, dte.temp_min, dte.temp_max, dtp.precipitation, dtp.precipitation_normal
FROM fact_review             AS fr
LEFT JOIN dim_business       AS db  ON fr.business_id=db.business_id
LEFT JOIN dim_temperature    AS dte ON fr.date=dte.date
LEFT JOIN dim_precipitation  AS dtp ON fr.date=dtp.date
WHERE db.city='Portland' AND db.state='OR'
GROUP BY fr.date, db.name, dte.temp_min, dte.temp_max, dtp.precipitation, dtp.precipitation_normal
ORDER BY fr.date DESC;
