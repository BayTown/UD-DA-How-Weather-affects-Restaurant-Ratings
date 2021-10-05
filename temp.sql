/*SQL queries code that reports the business name, temperature, precipitation, and ratings.*/

/* date, dim_business.name, dim_temperature.normal_min, dim_temperature.normal_max, dim_precipitation.precipitation, fact_review.stars */

SELECT dt.date, fr.review_id, fr.business_id, fr.stars
FROM dim_timestamp AS dt
LEFT JOIN fact_review AS fr ON dt.timestamp=fr.timestamp
ORDER BY dt.date DESC;

SELECT dt.date, db.name, AVG(fr.stars)
FROM fact_review AS fr
LEFT JOIN dim_timestamp AS dt ON fr.timestamp=dt.timestamp
LEFT JOIN dim_business  AS db ON fr.business_id=db.business_id
GROUP BY dt.date, db.name
ORDER BY dt.date DESC;



SELECT TOP 10 *
FROM fact_review
ORDER BY timestamp DESC;

SELECT dt.date, fr.review_id, fr.business_id, fr.stars
FROM fact_review AS fr
LEFT JOIN dim_timestamp AS dt ON fr.timestamp=dt.timestamp
WHERE fr.business_id = 'prFTiCuJhTU7YSPfTDufgw'
AND dt.date LIKE '2021-01-28';

SELECT *
FROM dim_business as db
WHERE db.city like 'Portland'
AND db.state = 'OR';