--source --  s3://bucketsnowflakes4

--target -- order tables

CREATE or replace DATABASE MANAGE_DB;

CREATE SCHEMA MANAGE_DB.external_stages;

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage_errorex
URL='s3://bucketsnowflakes4'


LIST @MANAGE_DB.external_stages.aws_stage_errorex;



 // Create example table
 CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

    COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
	--FILES = ('OrderDetails.csv')

    COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
    VALIDATION_MODE = RETURN_ERRORS;

    COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
    VALIDATION_MODE = RETURN_2_ROWS 

    COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
    RETURN_FAILED_ONLY = TRUE 
    VALIDATION_MODE = RETURN_ERRORS

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
    ON_ERROR =CONTINUE



    SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX 


        COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
    ON_ERROR =CONTINUE
    FORCE=TRUE 


// Create example table
 CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX1 (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(3),
    SUBCATEGORY VARCHAR(30));


    
    COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX1 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
    ON_ERROR =CONTINUE
    TRUNCATECOLUMNS =TRUE 


        SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX1


COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX1
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
    ON_ERROR =CONTINUE
    SIZE_LIMIT = 56000



    COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
    ON_ERROR = 'SKIP_FILE'

---------------------------------working with error records----------------------------

 // Create example table
 CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_AMAZON (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));



COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_AMAZON 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
    VALIDATION_MODE = RETURN_ERRORS 

01c3e5b2-0001-ae3a-000e-30a2000ac58a

// Storing rejected /failed results in a table
CREATE OR REPLACE TABLE rejected AS 
select rejected_record from table(result_scan(last_query_id()));

  SELECT REJECTED_RECORD FROM rejected;

  INSERT INTO rejected
select rejected_record from table(result_scan(last_query_id()));

SELECT * FROM rejected;


    CREATE OR REPLACE TABLE rejected_values as
SELECT 
SPLIT_PART(rejected_record,',',1) as ORDER_ID, 
SPLIT_PART(rejected_record,',',2) as AMOUNT, 
SPLIT_PART(rejected_record,',',3) as PROFIT, 
SPLIT_PART(rejected_record,',',4) as QUATNTITY, 
SPLIT_PART(rejected_record,',',5) as CATEGORY, 
SPLIT_PART(rejected_record,',',6) as SUBCATEGORY
FROM rejected; 

SELECT * FROM rejected_values ;

UPDATE rejected_values 
  SET PROFIT = 1000 
  WHERE PROFIT = 'one thousand';


         COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_AMAZON 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
    ON_ERROR=CONTINUE

INSERT INTO OUR_FIRST_DB.PUBLIC.ORDERS_AMAZON 
    (SELECT * FROM rejected_values)


    SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_AMAZON 


--So first you have to run validation mode equal to written errors. So this way 
--you'll get the errors. You need to take that error and keep it into one table.
--sIt's like rejected or rejected values or something with the help of result scan ------with the latest query ID. Then you have to split it into multiple parts and you
--shave to update the data. Okay. Then you have to load that data into your original table.



    SELECT OBJECT_CONSTRUCT(*) FROM OUR_FIRST_DB.PUBLIC.ORDERS_AMAZON 
    
USE snowflake.account_usage

SHOW TABLES;
    
SELECT * FROM snowflake.account_usage.load_history

// Filter on specific table & schema
SELECT * FROM snowflake.account_usage.load_history
  where schema_name='PUBLIC' and
  table_name='ORDERS'
  
  
// Filter on specific table & schema
SELECT * FROM snowflake.account_usage.load_history
  where schema_name='PUBLIC' and
  table_name='ORDERS' and
  error_count > 0
  
  
// Filter on specific table & schema
SELECT * FROM snowflake.account_usage.load_history
WHERE DATE(LAST_LOAD_TIME) <= DATEADD(days,-1,CURRENT_DATE)


SELECT DATEADD(days,-1,CURRENT_DATE)

