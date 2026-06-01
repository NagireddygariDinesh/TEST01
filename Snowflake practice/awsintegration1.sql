-- Make connection between s3 and snowflake
-- need integration object
-- need IAM roles

create or replace storage integration My_s3_intr
type= external_stage
storage_provider= 's3'
enabled= true
storage_aws_role_arn='arn:aws:iam::479925391880:role/mstech-snowdbt-13-role'
Storage_allowed_locations=('s3://mstech-snowdbt-13/json/');

describe integration My_s3_intr;

arn:aws:iam::640083578061:user/externalstages/cidd6d0000

PD79910_SFCRole=6_f6TuePQQOEUQB0rBMEAS+ZOAS5U=

create or replace stage MANAGE_DB.EXTERNAL_STAGES.JASON_SATGE
url='s3://mstech-snowdbt-13/json/'
storage_integration = my_s3_intr;

list @MANAGE_DB.EXTERNAL_STAGES.JASON_SATGE;
