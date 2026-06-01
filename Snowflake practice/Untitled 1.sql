CREATE or replace STORAGE INTEGRATION mytest_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::136889125076:role/sampleone'
  STORAGE_ALLOWED_LOCATIONS = ('s3://demo-bucket64/csv/');
  

 DESCRIBE INTEGRATION mytest_int;

 create or replace stage manage_db.external_stages.movies_stage
url='s3://demo-bucket64/csv/'
STORAGE_INTEGRATION = mytest_int;

list @manage_db.external_stages.movies_stage;

// Create table first
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.customers (
    Index INT,
    Customer_Id STRING,
    First_Name STRING,
    Last_Name STRING,
    Company STRING,
    City STRING,
    Country STRING,
    Phone1 STRING,
    Phone2 STRING,
    Email STRING,
    Subscription STRING,
    Date TIMESTAMP,
    Website STRING
);


CREATE SCHEMA IF NOT EXISTS MANAGE_DB.file_formats;

// Create file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE    
    FIELD_OPTIONALLY_ENCLOSED_BY = '"';


COPY INTO  OUR_FIRST_DB.PUBLIC.customers
FROM @manage_db.external_stages.movies_stage
FILE_FORMAT = MANAGE_DB.file_formats.csv_fileformat
FILES = ('customers-100 (1).csv')
ON_ERROR = 'continue'

select * from OUR_FIRST_DB.PUBLIC.customers;