source: S3   url -?  url='s3://bucketsnowflakes3'
target: snowflake 

use database our_first_db;
				  
	---CREATE STAGE   1 
	CREATE OR REPLACE STAGE   OUR_FIRST_DB.PUBLIC.ORDERS_STAGE
      URL =	's3://bucketsnowflakes3';
	
	--LIST OUT THE STAGE  2
	LIST @OUR_FIRST_DB.PUBLIC.ORDERS_STAGE; 
				  
	---3 CREATE TABLE 			  
	CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));
	
	
	--LOAD THE DATA  4 
	COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS 
	FROM @OUR_FIRST_DB.PUBLIC.ORDERS_STAGE 
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
	FILES = ('OrderDetails.csv');
	 
	-- PATTERN=('.*ORDER.*')

select * from OUR_FIRST_DB.PUBLIC.ORDERS;

----------------------------------------------------------------------------------------------
copy into orders
from @orders_stage
files=('orders.csv')
file_format=(type= 'csv', field_delimiter=',', skip_header1)
---or we can write pattern= ('.*orders.*) to select all files that contain its name as orders
----------------------------------------------------------------------------------------------

list @OUR_FIRST_DB.PUBLIC.ORDER_STg1;
----------------------------------------------------------------------------------------------

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_V5 (
  Loan_ID STRING,
  loan_status STRING,
  Principal STRING,
  terms STRING,
  effective_date STRING,
  due_date STRING,
  paid_off_time STRING,
  past_due_days STRING,
  age STRING,
  education STRING,
  Gender STRING);

--creating internal STAGE

  CREATE OR REPLACE STAGE OUR_FIRST_DB.PUBLIC.MY_INT_STAGE ;
  LIST @OUR_FIRST_DB.PUBLIC.MY_INT_STAGE;

  COPY INTO OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_V5 
	FROM @OUR_FIRST_DB.PUBLIC.MY_INT_STAGE 
	FILE_FORMAT = (TYPE='CSV',SKIP_HEADER=1,FIELD_DELIMITER=',')
	FILES = ('Loan_Payments.csv');
 
    SELECT *  FROM OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_V5;

--------------------ASSIGNMENT-------------------------

Load Data Into Loan Payments
    CREATE OR REPLACE STAGE OUR_FIRST_DB.PUBLIC.ORDERS_STAGE_v1
      URL =    's3://bucketsnowflakes3';

list @OUR_FIRST_DB.PUBLIC.ORDERS_STAGE_v1;

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_V6 (
  Loan_ID STRING,
  loan_status STRING,
  Principal STRING,
  terms STRING,
  effective_date STRING,
  due_date STRING,
  paid_off_time STRING,
  past_due_days STRING,
  age STRING,
  education STRING,
  Gender STRING);

  copy into OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_V6
        from @OUR_FIRST_DB.PUBLIC.ORDERS_STAGE_v1
        file_format = (type= 'csv', Field_delimiter=',', skip_header=1)
        files= ('Loan_payments_data.csv');

  select * from OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_V6;