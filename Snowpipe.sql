--create s3 integration object 

CREATE OR REPLACE STORAGE INTEGRATION my_s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::479925391880:role/mstech-snowpipe'
  STORAGE_ALLOWED_LOCATIONS = ('s3://mstech-snowdbt-13/csv/');
  

 DESCRIBE INTEGRATION my_s3_int


 CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.EMPLOYEE_SATGE
 URL = 's3://mstech-snowdbt-13/csv/'
 STORAGE_INTEGRATION = my_s3_int

 LIST @MANAGE_DB.EXTERNAL_STAGES.EMPLOYEE_SATGE


 // Create table first

 // Create table first
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.employees (
  id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  location STRING,
  department STRING
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


COPY INTO  OUR_FIRST_DB.PUBLIC.employees
FROM @MANAGE_DB.EXTERNAL_STAGES.EMPLOYEE_SATGE
FILE_FORMAT = MANAGE_DB.file_formats.csv_fileformat




// Create schema to keep things organized
CREATE OR REPLACE SCHEMA MANAGE_DB.pipes




CREATE OR REPLACE pipe MANAGE_DB.pipes.employee_pipe
auto_ingest = TRUE
AS
  COPY INTO  OUR_FIRST_DB.PUBLIC.employees
  FROM @MANAGE_DB.EXTERNAL_STAGES.EMPLOYEE_SATGE
  FILE_FORMAT = MANAGE_DB.file_formats.csv_fileformat

describe  pipe MANAGE_DB.pipes.employee_pipe

SELECT  * FROM OUR_FIRST_DB.PUBLIC.employees



ALTER pipe employee_pipe refresh;