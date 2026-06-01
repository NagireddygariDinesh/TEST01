select * from our_first_db.public.orders_v1;

delete from our_first_db.public.orders_v1 where quantity<5; --9:24 --1055


--Time Travel

--offset

select * from our_first_db.public.orders_v1 at (offset => -60*2760);

--Timestamp

select current_timestamp();

select * from our_first_db.public.orders_v1 before (timestamp => 5/12/2026, 9:24:50 AM);

create table our_first_db.public.test_orders as
    (
     select * from our_first_db.public.orders_v1 at (offset => -60*3000)  
    )

--query Id

select * from our_first_db.public.orders_v1 before (statement => '01c44f8a-0001-b5d6-000e-30a200117376');


alter table our_first_db.public.orders_v1 set data_retention_time_in_days=30;

---------------------------------------------------------------------------------------------------------------

--Zero copy clonning

create table our_first_db.public.orders_v1_clone clone our_first_db.public.orders_v1;

create schema hr.human_resourse_clone clone hr.human_resourse;

create database hr_clone clone hr;

