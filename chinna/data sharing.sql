USE ROLE ACCOUNTADMIN;



CREATE MANAGED ACCOUNT reader_acct1
    ADMIN_NAME = admin, 
    ADMIN_PASSWORD = 'Admin@12345678',
    TYPE = READER;

CREATE SHARE user02_share;

GRANT USAGE ON DATABASE user02 TO SHARE user02_share;

GRANT USAGE ON SCHEMA user02.testcase TO SHARE user02_share;

GRANT SELECT ON TABLE user02.testcase.customers TO SHARE user02_share;

SHOW SHARES;

ALTER SHARE user02_share ADD ACCOUNTS = QD79935;

DESC SHARE user02_share;

SHOW MANAGED ACCOUNTS;

ALTER SHARE user02_share ADD ACCOUNTS = <reader_acct1_locator>;



SHOW SHARES;

CREATE DATABASE shared_db FROM SHARE pd79910.user02_share;

SELECT * FROM shared_db.testcase.customers;