create database aws_int
create schema external_stages 
use schema public

create storage integration aws_integrate
type = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::136889125076:role/awsinttest'
STORAGE_ALLOWED_LOCATIONS = ('s3://totestsnow/csv/')

describe storage integration aws_integrate

create or replace stage aws_int.external_stages.aws_int1
url = 's3://totestsnow/csv/'
STORAGE_INTEGRATION = aws_integrate

list @aws_int.external_stages.aws_int1



CREATE OR REPLACE TABLE customers (
    index             NUMBER,
    customer_id       VARCHAR(50),
    first_name        VARCHAR(100),
    last_name         VARCHAR(100),
    company           VARCHAR(200),
    city              VARCHAR(100),
    country           VARCHAR(100),
    phone_1           VARCHAR(50),
    phone_2           VARCHAR(50),
    email             VARCHAR(200),
    subscription_date DATE,
    website           VARCHAR(300)
    );

    CREATE OR REPLACE FILE FORMAT csv_format
    TYPE = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER = 1
    NULL_IF = ('', 'NULL')
    EMPTY_FIELD_AS_NULL = TRUE
    DATE_FORMAT = 'YYYY-MM-DD';


COPY INTO customers
FROM @aws_int.external_stages.aws_int1
FILE_FORMAT = (FORMAT_NAME = 'csv_format')
ON_ERROR = 'CONTINUE'; 

select * from customers


