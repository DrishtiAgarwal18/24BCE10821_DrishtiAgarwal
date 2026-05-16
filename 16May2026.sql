show databases;

drop database shopdb;

create database newdb_fp;

use newdb_fp;

create table CSE(
  sid int8,
  sname varchar(50),
  smarks int1
);

create table EEE(
  sid int8,
  sname varchar(50),
  smarks int1
);

create table MEC(
  sid int8,
  sname varchar(50),
  smarks int1
);

show tables from newdb_fp;

select * from CSE;

insert into CSE values (102,'Anurag',87);
insert into CSE values (104,'Yogesh',34);

select * from EEE;

insert into eee values (256,'Ananya',91);

select * from mec;

insert into mec values (599,'Vishal',74);