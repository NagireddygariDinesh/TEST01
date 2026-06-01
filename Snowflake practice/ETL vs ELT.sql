create database vitech_dev;

use database vitech_dev;

create schema vitech_dev.orders;
create schema vitech_dev.loans;

--s3://bucketsnowflakes3 
---s3://bucketsnowflakes3/Loan_payments_data.csv

CREATE TABLE   vitech_dev.LOANS.LOAN_PAYMENT  (
   Loan_ID  STRING,
   loan_status  STRING,
   Principal  STRING,
   terms  STRING,
   effective_date  STRING,
   due_date  STRING,
   paid_off_time  STRING,
   past_due_days  STRING,
   age  STRING,
   education  STRING,
   Gender  STRING);

select * from vitech_dev.loans.loan_payment;

copy into vitech_dev.loans.loan_payment
from 's3://bucketsnowflakes3/Loan_payments_data.csv'
file_format=(type='csv', skip_header=1, field_delimiter=',');

select loan_id, 
        principal,
        terms,
        (principal*terms) as total_amount,
        coalesce(past_due_days,0)
        from vitech_dev.loans.loan_payment;

------------------------------------------------------------------------------------------------------------
--ETL
--s3://bucketsnowflakes3
-- 1) create stage

create or replace stage vitech_dev.loans.loans_stage
url='s3://bucketsnowflakes3/Loan_payments_data.csv';

--2) list the stage

list @vitech_dev.loans.loans_stage;

--3) create target table in snowflake

CREATE OR REPLACE TABLE   vitech_dev.LOANS.LOAN_PAYMENT_V1  (
   Loan_ID  STRING,
   loan_status  STRING,
   Principal  STRING,
   terms  STRING) ;
--4) transform

COPY INTO vitech_dev.LOANS.LOAN_PAYMENT_V1 (Loan_ID,loan_status,Principal,terms)
FROM 
 (SELECT $1 , 
       $2 ,
       $3,
       $4 FROM @vitech_dev.LOANS.LOANS_STAGE )
file_format= (type = csv field_delimiter=',' skip_header=1) ;

select * from vitech_dev.loans.loan_payment_v1;

CREATE OR REPLACE TABLE   vitech_dev.LOANS.LOAN_PAYMENT_V2  (
   Loan_ID  STRING,
   loan_status  STRING,
   Principal  STRING,
   terms  STRING ,
   GENDER STRING
   ) ;


  
COPY INTO vitech_dev.LOANS.LOAN_PAYMENT_V2 (Loan_ID,loan_status,Principal,terms,GENDER)
FROM 
 (SELECT $1 , 
       $2 ,
       $3,
       $4,
       $11 
       FROM @vitech_dev.LOANS.LOANS_STAGE )
file_format= (type = csv field_delimiter=',' skip_header=1) ;

select * from vitech_dev.loans.loan_payment_v2;

--------------------------------------------------------------------------------------------------
	TASK :
	
  --s3 url --- s3://bucketsnowflakes3/OrderDetails.csv
  ---ddl
  CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

    
--1) ELT

--create table
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID string,
    AMOUNT string,
    PROFIT string,
    QUANTITY string,
    CATEGORY string,
    SUBCATEGORY string
    );

--copy command

copy into our_first_db.public.orders
from 's3://bucketsnowflakes3/OrderDetails.csv'
file_format= (type = csv field_delimiter=',' skip_header=1) ;

select * from our_first_db.public.orders;

---------------------------------------------------------------------------------------------------------------
--ETL
--1) create stage

create or replace stage our_first_db.public.orders_stage
url='s3://bucketsnowflakes3/OrderDetails.csv';

list @our_first_db.public.orders_stage;

create or replace table our_first_db.public.orders_v1
(
ORDER_ID string,
    AMOUNT string,
    PROFIT string,
    QUANTITY string,
    CATEGORY string,
    SUBCATEGORY string
    );

copy into our_first_db.public.orders_v1
from @our_first_db.public.orders_stage
file_format= (type = csv field_delimiter=',' skip_header=1) ;

select * from our_first_db.public.orders_v1;