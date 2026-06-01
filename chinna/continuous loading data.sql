snow pipe

create database snowpipe
create schema testcase

create storage integration snowpipe
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN ='arn:aws:iam::136889125076:role/snowpipe'
STORAGE_ALLOWED_LOCATIONS = ('s3://snowpipetestcase1/csv/')

DESCRIBE STORAGE INTEGRATION SNOWPIPE

CREATE OR REPLACE STAGE SNOWPIPE.TESTCASE.USER01
URL = 's3://snowpipetestcase1/csv/'
STORAGE_INTEGRATION = SNOWPIPE

LIST @SNOWPIPE.TESTCASE.USER01

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
    TYPE                      = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER               = 1
    NULL_IF                   = ('', 'NULL')
    EMPTY_FIELD_AS_NULL       = TRUE
    DATE_FORMAT               = 'YYYY-MM-DD';

    CREATE OR REPLACE TABLE products (
    index         NUMBER,
    name          VARCHAR(300),
    description   VARCHAR(2000),
    brand         VARCHAR(200),
    category      VARCHAR(200),
    price         NUMBER(15, 2),
    currency      VARCHAR(10),
    stock         NUMBER,
    ean           NUMBER(20),
    color         VARCHAR(100),
    size          VARCHAR(100),
    availability  VARCHAR(50),
    internal_id   NUMBER
);

SELECT * FROM CUSTOMERS

CREATE OR REPLACE PIPE SNOWPIPE.TESTCASE.CUSTOMER
AUTO_INGEST = TRUE
AS 
COPY INTO SNOWPIPE.TESTCASE.CUSTOMERS
FROM @SNOWPIPE.TESTCASE.USER01

DESCRIBE PIPE SNOWPIPE.TESTCASE.CUSTOMER

ALTER PIPE SNOWPIPE.TESTCASE.CUSTOMER REFRESH

SELECT * FROM CUSTOMERS

CREATE OR REPLACE PIPE SNOWPIPE.TESTCASE.CUSTOMER_PIPE
    AUTO_INGEST = TRUE
AS
COPY INTO SNOWPIPE.TESTCASE.CUSTOMERS
FROM @SNOWPIPE.TESTCASE.USER01
PATTERN     = '.*[Cc]ustomer.*\.csv'    -- ✅ routes only customer file
FILE_FORMAT = (FORMAT_NAME = 'SNOWPIPE.TESTCASE.csv_format')  -- ✅ was missing
ON_ERROR    = 'CONTINUE';

SHOW PIPES IN SCHEMA SNOWPIPE.TESTCASE;

ALTER PIPE SNOWPIPE.TESTCASE.CUSTOMER_PIPE REFRESH;

SELECT SYSTEM$PIPE_STATUS('SNOWPIPE.TESTCASE.CUSTOMER_PIPE')

SELECT * FROM CUSTOMERS

CREATE OR REPLACE TABLE PRODUCTS AS
SELECT DISTINCT * FROM PRODUCTS;

CREATE OR REPLACE PIPE SNOWPIPE.TESTCASE.products_PIPE
    AUTO_INGEST = TRUE
AS
COPY INTO SNOWPIPE.TESTCASE.products
FROM @SNOWPIPE.TESTCASE.USER01
PATTERN     = '.*[Pp]roducts.*\.csv'    -- ✅ routes only customer file
FILE_FORMAT = (FORMAT_NAME = 'SNOWPIPE.TESTCASE.csv_format')  -- ✅ was missing
ON_ERROR    = 'CONTINUE';

ALTER PIPE SNOWPIPE.TESTCASE.products_PIPE REFRESH

list @SNOWPIPE.TESTCASE.USER01

select * from products
select * from customers
CREATE OR REPLACE TABLE SNOWPIPE.TESTCASE.PRODUCTS AS SELECT DISTINCT * FROM SNOWPIPE.TESTCASE.PRODUCTS

LIST @SNOWPIPE.TESTCASE.USER01 PATTERN = '.*[Pp]eople.*\.csv'
SELECT $1, $2, $3, $4, $5, $6, $7, $8, $9 FROM @SNOWPIPE.TESTCASE.USER01/people-1000.csv (FILE_FORMAT => 'SNOWPIPE.TESTCASE.csv_format') 

CREATE OR REPLACE TABLE SNOWPIPE.TESTCASE.PEOPLE (
    index         NUMBER,
    user_id       VARCHAR(50),
    first_name    VARCHAR(100),
    last_name     VARCHAR(100),
    gender        VARCHAR(20),
    email         VARCHAR(200),
    phone         VARCHAR(50),
    date_of_birth DATE,
    job_title     VARCHAR(200)
);

select * from people

COPY INTO people
FROM @SNOWPIPE.TESTCASE.USER01
PATTERN = '.*[Pp]eople.*\.csv'
FILE_FORMAT = (FORMAT_NAME = 'SNOWPIPE.TESTCASE.csv_format')
ON_ERROR = 'CONTINUE'

select * from people


select 'DINESH' AS NAME , 'IT' AS TYPE

-- Run this directly in Snowflake to confirm
SELECT * FROM PEOPLE LIMIT 5;

SELECT * FROM PEOPLE
WHERE FIRST_NAME = 'Shelia';

SELECT COUNT(*) FIRST_NAME FROM PEOPLE

SELECT * FROM TEST02


select * from customers