s3://bucketsnowflakes4

create or replace databse manage_db;

create or replace schema external_stages;

create or replace stage manage_db.external_stages.aws_stage_errorex
url='s3://bucketsnowflakes4';

list @manage_db.external_stages.aws_stage_errorex;

// Create example table
 CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX
 (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
	--FILES = ('OrderDetails.csv');

    COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
	validation_mode=return_errors;

    COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
	validation_mode=return_20_rows;

    COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
	return_failed_only=true
    validation_mode=return_errors;

    COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
	on_error=continue;

    select * from OUR_FIRST_DB.PUBLIC.ORDERS_EX;

    COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
	on_error=continue
    force=true;

    COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
	on_error=continue;

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
    TRUNCATECOLUMNS =TRUE;

    select * from OUR_FIRST_DB.PUBLIC.ORDERS_EX1;

        COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
	on_error=continue
    size_limit=50000;

        COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
	on_error=continue
    size_limit=56000;

    SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX1;

    SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;

     COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
    ON_ERROR = 'SKIP_FILE';
------------------------working with error records------------------------------------------------------------------------

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
    VALIDATION_MODE = RETURN_ERRORS;


// Storing rejected /failed results in a table
CREATE OR REPLACE TABLE rejected AS 
select rejected_record from table(result_scan(last_query_id()));

select * from rejected;


CREATE OR REPLACE TABLE rejected_values as
SELECT 
SPLIT_PART(rejected_record,',',1) as ORDER_ID, 
SPLIT_PART(rejected_record,',',2) as AMOUNT, 
SPLIT_PART(rejected_record,',',3) as PROFIT, 
SPLIT_PART(rejected_record,',',4) as QUATNTITY, 
SPLIT_PART(rejected_record,',',5) as CATEGORY, 
SPLIT_PART(rejected_record,',',6) as SUBCATEGORY
FROM rejected; 

select * from rejected_values;

UPDATE rejected_values 
  SET PROFIT = 1000 
  WHERE PROFIT = 'two hundred twenty';

UPDATE rejected_values 
  SET PROFIT = 220 
  WHERE PROFIT = 'one thousand';

  COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_AMAZON 
	FROM @MANAGE_DB.external_stages.aws_stage_errorex
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
    ON_ERROR=CONTINUE

INSERT INTO OUR_FIRST_DB.PUBLIC.ORDERS_AMAZON 
    (SELECT * FROM rejected_values)


    SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_AMAZON 

    show tables;

    SELECT * FROM snowflake.account_usage.load_history;

    / Filter on specific table & schema
SELECT * FROM snowflake.account_usage.load_history
  where schema_name='PUBLIC' and
  table_name='ORDERS';
  
  
// Filter on specific table & schema
SELECT * FROM snowflake.account_usage.load_history
  where schema_name='PUBLIC' and
  table_name='ORDERS' and
  error_count > 0;
  
  
// Filter on specific table & schema
SELECT * FROM snowflake.account_usage.load_history
WHERE DATE(LAST_LOAD_TIME) <= DATEADD(days,-1,CURRENT_DATE);


SELECT DATEADD(days,-1,CURRENT_DATE);
