create table emp (id int, name string);

create transient table emptrans (id int, name string);

create temporary table emp_temp (id int, name string);

show tables;

alter table emp set data_retention_time_in_days=90;

create or replace dynamic table mytab
target_lag='1 minute'
warehouse=compute_wh
refresh_mode=auto
initialize=on_create
as
    select * from emp;

