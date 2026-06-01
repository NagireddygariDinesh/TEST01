aws s3 bucket 

source : s3://bucketsnowflakes3

target : snowflake table 


1. create stage
2) list stage
3) create table in target(snowflake)
4) load data using copy into command into target table 


create or replace stage hr.human_resourse.Orders_stage
 url='s3://bucketsnowflakes3';

 list @hr.human_resourse.Orders_stage;

 OrderDetails.csv

 CREATE OR REPLACE TABLE hr.human_resourse.ORDERS
 (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
 );

 select * from hr.human_resourse.ORDERS

 copy into hr.human_resourse.ORDERS
    from @hr.human_resourse.Orders_stage
        file_format=(type='csv', Field_delimiter=',', skip_header=1)
        files=('OrderDetails.csv');

  