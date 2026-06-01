create or replace stage manage_db.external_stages.movies_stage
url='s3://mstech-snowdbt-13/csv/'
STORAGE_INTEGRATION = my_s3_int;

list @manage_db.external_stages.movies_stage;

1. Create stage 
2. List the stage 
3. Create file format 
4. Create Table 
5. Perform copy command 
6. Validate data 


Make a connection between S3 & Snowflake 

1. Create S3 integration object 
2. Need IAM Roles and created with s3 full access
3. Describe integration and copy user ARN & External id 
4. Goto AWS IAM roles and  edit trust relation ships with user ARN & External id 


EXTERNAL ID:  LK54461_SFCRole=4_JtyENVrvEHzRGTfzgLiWjZldPcA=

USER ARN : arn:aws:iam::974916068036:user/externalstages/cieo8c0000


s3://vitech-snowdbt-13/csv/netflix_titles.csv

--create s3 integration object 

CREATE STORAGE INTEGRATION my_s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::479925391880:role/mstech-snowdbt-13-role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://mstech-snowdbt-13/csv/', 's3://mstech-snowdbt-13/json/');
  

 DESCRIBE INTEGRATION my_s3_int

 netflix_titles.csv

 // Create table first
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.movie_titles (
  show_id STRING,
  type STRING,
  title STRING,
  country STRING,
  release_year STRING,
  rating STRING
   )


CREATE SCHEMA  MANAGE_DB.file_formats  
// Create file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE    
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'       


COPY INTO  OUR_FIRST_DB.PUBLIC.movie_titles
FROM @manage_db.external_stages.movies_stage
FILE_FORMAT = MANAGE_DB.file_formats.csv_fileformat
FILES = ('netflix_titles.csv')
ON_ERROR = 'SKIP_FILE'

select top 5 * from OUR_FIRST_DB.PUBLIC.movie_titles;

select count(*) from OUR_FIRST_DB.PUBLIC.movie_titles;