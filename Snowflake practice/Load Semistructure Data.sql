// First step: Load Raw JSON

CREATE OR REPLACE stage MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
     url='s3://bucketsnowflake-jsondemo';

list @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE

-- CREATE OR REPLACE file format MANAGE_DB.FILE_FORMATS.JSONFORMAT
--     TYPE = JSON;
    
    
CREATE OR REPLACE table OUR_FIRST_DB.PUBLIC.JSON_RAW (
    raw_file variant);

    -- COPY INTO OUR_FIRST_DB.PUBLIC.JSON_RAW
--     FROM @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
--     file_format= MANAGE_DB.FILE_FORMATS.JSONFORMAT
--     files = ('HR_data.json');
    
   
SELECT * FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

COPY INTO OUR_FIRST_DB.PUBLIC.JSON_RAW
    FROM @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
    FILE_FORMAT=(TYPE=JSON)

SELECT $1:city,
       $1:first_name
       FROM OUR_FIRST_DB.PUBLIC.JSON_RAW



SELECT $1:city:: string as city ,
       $1:first_name :: string as name ,
       $1:job.salary:: float as salary,
       $1:job.title :: string as titile 
       FROM OUR_FIRST_DB.PUBLIC.JSON_RAW


create table hr_data as (
    SELECT $1:city:: string as city ,
       $1:first_name :: string as name ,
       $1:job.salary:: float as salary,
       $1:job.title :: string as titile 
       FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
    )


    select * from hr_data 


     select max(salary) from hr_data


     SELECT raw_file:city:: string as city ,
      raw_file:first_name :: string as name ,
      raw_file:job.salary:: float as salary,
       raw_file:job.title :: string as titile ,
       raw_file:spoken_languages
       FROM OUR_FIRST_DB.PUBLIC.JSON_RAW


    create table hr_datav1 as (   
     SELECT raw_file:city:: string as city ,
      raw_file:first_name :: string as name ,
      raw_file:job.salary:: float as salary,
       raw_file:job.title :: string as titile ,
       raw_file:spoken_languages[0].language :: string as primary_language,
      raw_file:spoken_languages[1].language :: string as secondary_language
       FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
       )

       select * from hr_datav1

SELECT
  hr.value:language::STRING AS language,
  hr.value:level::STRING AS level
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW  ,
LATERAL FLATTEN(input => $1:spoken_languages) hr;

SELECT
  raw_file:id:: int as id ,
  hr.value:language::STRING AS language,
  hr.value:level::STRING AS level
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW,
LATERAL FLATTEN(input => raw_file:spoken_languages) hr;

select
      RAW_FILE:id::STRING as id,
    f.value:language::STRING as language,
   f.value:level::STRING as Level_spoken
from OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f;