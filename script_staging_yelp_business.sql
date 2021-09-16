/* Documentation reference for this script: https://docs.snowflake.com/en/user-guide/script-data-load-transform-json.html */

/* Select/use database and schema */
USE DATABASE "EWRR";
USE SCHEMA "EWRR"."STAGING_SCHEMA";

/* Create a target relational table for the JSON data. The table is temporary, meaning it persists only for   */
/* the duration of the user session and is not visible to other users.                                        */

CREATE OR REPLACE TABLE yelp_business (
    business_id string,
    name string,
    address string,
    city string,
    state string,
    postal_code string,
    latitude string,
    longitude string,
    stars string,
    review_count string,
    is_open string,
    attributes_NoiseLevel string,
    attributes_BikeParking string,
    attributes_RestaurantsAttire string,
    attributes_BusinessAcceptsCreditCards string,
    attributes_BusinessParking string,
    attributes_RestaurantsReservations string,
    attributes_GoodForKids string,
    attributes_RestaurantsTakeOut string,
    attributes_Caters string,
    attributes_WiFi string,
    attributes_RestaurantsDelivery string,
    attributes_HasTV string,
    attributes_RestaurantsPriceRange2 string,
    attributes_Alcohol string,
    attributes_Music string,
    attributes_BusinessAcceptsBitcoin string,
    attributes_GoodForDancing string,
    attributes_DogsAllowed string,
    attributes_BestNights string,
    attributes_RestaurantsGoodForGroups string,
    attributes_OutdoorSeating string,
    attributes_HappyHour string,
    attributes_RestaurantsTableService string,
    attributes_GoodForMeal string,
    attributes_WheelchairAccessible string,
    attributes_Ambience string,
    categories string,
    hours_Monday string,
    hours_Tuesday string,
    hours_Wednesday string,
    hours_Thursday string,
    hours_Friday string,
    hours_Saturday string,
    hours_Sunday string
);

/* Create a named file format with the file delimiter set as none and the record delimiter set as the new     */
/* line character.                                                                                            */
/*                                                                                                            */
/* When loading semi-structured data (e.g. JSON), you should set CSV as the file format type (default value). */
/* You could use the JSON file format, but any error in the transformation would stop the COPY operation,     */
/* even if you set the ON_ERROR option to continue or skip the file.                                          */

CREATE OR REPLACE FILE FORMAT sf_tut_csv_format
    FIELD_DELIMITER = NONE
    RECORD_DELIMITER = '\\n';

/* Create a temporary internal stage that references the file format object.                                  */
/* Similar to temporary tables, temporary stages are automatically dropped at the end of the session.         */

CREATE OR REPLACE TEMPORARY STAGE sf_tut_stage
    FILE_FORMAT = sf_tut_csv_format;

/* Stage the data file.                                                                                       */
/*                                                                                                            */
/* Note that the example PUT statement references the macOS or Linux location of the data file.               */

PUT file:///home/andi-ml/Documents/projects/UD-DA-Module-2/UD-DA-How-Weather-affects-Restaurant-Ratings/data/yelp_data/yelp_dataset/yelp_academic_dataset_business_test.json @sf_tut_stage;


/* Load the JSON data into the relational table.                                                              */
/*                                                                                                            */
/* A SELECT query in the COPY statement identifies a numbered set of columns in the data files you are        */
/* loading from. Note that all JSON data is stored in a single column ($1).                                   */

COPY INTO yelp_business(business_id, name, address, city, state, postal_code, latitude, longitude, stars,
                        review_count, is_open, attributes_NoiseLevel, attributes_BikeParking, attributes_RestaurantsAttire,
                        attributes_BusinessAcceptsCreditCards, attributes_BusinessParking, attributes_RestaurantsReservations,
                        attributes_GoodForKids, attributes_RestaurantsTakeOut, attributes_Caters, attributes_WiFi,
                        attributes_RestaurantsDelivery, attributes_HasTV, attributes_RestaurantsPriceRange2, attributes_Alcohol,
                        attributes_Music, attributes_BusinessAcceptsBitcoin, attributes_GoodForDancing, attributes_DogsAllowed,
                        attributes_BestNights, attributes_RestaurantsGoodForGroups, attributes_OutdoorSeating,
                        attributes_HappyHour, attributes_RestaurantsTableService, attributes_GoodForMeal,
                        attributes_WheelchairAccessible, attributes_Ambience, categories,
                        hours_Monday, hours_Tuesday, hours_Wednesday, hours_Thursday, hours_Friday, hours_Saturday, hours_Sunday)
    FROM (SELECT parse_json($1):business_id,
                 parse_json($1):name,
                 parse_json($1):address,
                 parse_json($1):city,
                 parse_json($1):state,
                 parse_json($1):postal_code,
                 parse_json($1):latitude,
                 parse_json($1):longitude,
                 parse_json($1):stage,
                 parse_json($1):review_count,
                 parse_json($1):is_open,
                 parse_json($1):attributes.NoiseLevel,
                 parse_json($1):attributes.BikeParking,
                 parse_json($1):attributes.RestaurantsAttire,
                 parse_json($1):attributes.BusinessAcceptsCreditCards,
                 parse_json($1):attributes.BusinessParking,
                 parse_json($1):attributes.RestaurantsReservations,
                 parse_json($1):attributes.GoodForKids,
                 parse_json($1):attributes.RestaurantsTakeOut,
                 parse_json($1):attributes.Caters,
                 parse_json($1):attributes.WiFi,
                 parse_json($1):attributes.RestaurantsDelivery,
                 parse_json($1):attributes.HasTV,
                 parse_json($1):attributes.RestaurantsPriceRange2,
                 parse_json($1):attributes.Alcohol,
                 parse_json($1):attributes.Music,
                 parse_json($1):attributes.BusinessAcceptsBitcoin,
                 parse_json($1):attributes.GoodForDancing,
                 parse_json($1):attributes.DogsAllowed,
                 parse_json($1):attributes.BestNights,
                 parse_json($1):attributes.RestaurantsGoodForGroups,
                 parse_json($1):attributes.OutdoorSeating,
                 parse_json($1):attributes.HappyHour,
                 parse_json($1):attributes.RestaurantsTableService,
                 parse_json($1):attributes.GoodForMeal,
                 parse_json($1):attributes.WheelchairAccessible,
                 parse_json($1):attributes.Ambience,
                 parse_json($1):categories,
                 parse_json($1):hours.Monday,
                 parse_json($1):hours.Tuesday,
                 parse_json($1):hours.Wednesday,
                 parse_json($1):hours.Thursday,
                 parse_json($1):hours.Friday,
                 parse_json($1):hours.Saturday,
                 parse_json($1):hours.Sunday
          FROM @sf_tut_stage/yelp_academic_dataset_business_test.json.gz t)
    ON_ERROR = 'continue';

/* Query the relational table                                                                                 */

SELECT * from yelp_business;



/* HELP                                                                                                                 */
/*                                                                                                                      */
/* COPY INTO home_sales(city, state, zip, sale_date, price)                                                             */
/*  FROM (SELECT SUBSTR(parse_json($1):location.state_city,4), SUBSTR(parse_json($1):location.state_city,1,2),          */
/*                parse_json($1):location.zip, to_timestamp_ntz(parse_json($1):sale_date), parse_json($1):price         */
/*         FROM @sf_tut_stage/sales.json.gz t)                                                                          */
/*   ON_ERROR = 'continue';                                                                                             */
