select * from customers

create database user02
create schema testcase

create or replace table user02.testcase.customers
as (select * from snowpipe.testcase.customers)


select * from  user02.testcase.customers
show tables

alter table  user02.testcase.customers
set data_retention_time_in_days = 20;


delete from  user02.testcase.customers
set last_query_id = '01c4afad-0001-c378-000e-30a2001e6cea'

select * from user02.testcase.customers before (statement => '01c4afad-0001-c378-000e-30a2001e6cea')

create or replace table customers_01 as
(select * from user02.testcase.customers before (statement => '01c4afad-0001-c378-000e-30a2001e6cea'))

select * from customers_01
-- Step 1: Query the data as it existed before the DELETE using Time Travel
SELECT * FROM user02.testcase.customers BEFORE (statement => '01c4afad-0001-c378-000e-30a2001e6cea');

-- Step 2: Insert the recovered data back into the table
INSERT INTO user02.testcase.customers 
SELECT * FROM user02.testcase.customers BEFORE (statement => '01c4afad-0001-c378-000e-30a2001e6cea');

insert into user02.testcase.customers (
select * from customers_01
)



select * from user02.testcase.customers
select * from user02.testcase.


