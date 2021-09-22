/* Documentation reference for this script: https://docs.snowflake.com/en/user-guide/script-data-load-transform-json.html */

/* Select/use database and schema */
USE DATABASE "EWRR";
USE SCHEMA "EWRR"."STAGING_SCHEMA";

/* Create a target relational table for the JSON data. The table is temporary, meaning it persists only for   */
/* the duration of the user session and is not visible to other users.                                        */

CREATE OR REPLACE TABLE yelp_user (
    user_id TEXT,
    name TEXT,
    review_count INT,
    yelping_since DATETIME,
    useful INT,
    funny INT,
    cool INT,
    elite TEXT,
    friends TEXT,
    fans INT,
    average_stars NUMERIC(1,2),
    compliment_hot INT,
    compliment_more INT,
    compliment_profile INT,
    compliment_cute INT,
    compliment_list INT,
    compliment_note INT,
    compliment_plain INT,
    compliment_cool INT,
    compliment_funny INT,
    compliment_writer INT,
    compliment_photos INT
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

PUT file:///home/andi-ml/Documents/projects/UD-DA-Module-2/UD-DA-How-Weather-affects-Restaurant-Ratings/data/yelp_data/yelp_dataset/yelp_academic_dataset_user.json @sf_tut_stage;

/* Load the JSON data into the relational table.                                                              */
/*                                                                                                            */
/* A SELECT query in the COPY statement identifies a numbered set of columns in the data files you are        */
/* loading from. Note that all JSON data is stored in a single column ($1).                                   */

COPY INTO yelp_user(user_id, name, review_count, yelping_since, useful, funny, cool, elite, friends, fans, average_stars,
                    compliment_hot, compliment_more, compliment_profile, compliment_cute, compliment_list, compliment_note,
                    compliment_plain, compliment_cool, compliment_funny, compliment_writer, compliment_photos)
    FROM (SELECT parse_json($1):user_id
                 parse_json($1):name,
                 parse_json($1):review_count,
                 parse_json($1):yelping_since,
                 parse_json($1):useful,
                 parse_json($1):funny,
                 parse_json($1):cool,
                 parse_json($1):elite,
                 parse_json($1):friends,
                 parse_json($1):fans,
                 parse_json($1):average_stars,
                 parse_json($1):compliment_hot,
                 parse_json($1):compliment_more,
                 parse_json($1):compliment_profile,
                 parse_json($1):compliment_cute,
                 parse_json($1):compliment_list,
                 parse_json($1):compliment_note,
                 parse_json($1):compliment_plain,
                 parse_json($1):compliment_cool,
                 parse_json($1):compliment_funny,
                 parse_json($1):compliment_writer,
                 parse_json($1):compliment_photos
          FROM @sf_tut_stage/yelp_academic_dataset_user.json.gz t)
    ON_ERROR = 'continue';

/* Query the relational table                                                                                 */
/* SELECT * from yelp_user;                                                                                   */
