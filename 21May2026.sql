use newdb_fp;

create table category(
cid int primary key,
cname varchar(100) not null
);

select * from category;

insert into category values (101,'electronics');
insert into category values (102,'home appliances');

drop table products;

create table products(
pid int primary key,
pname varchar(100) not null,
cid int,
foreign key (cid) references category(cid) on update cascade
);

desc products;

insert into products values (501,'Asus Charger',101);
insert into products values (504,'Wooden Chair',102);

select * from products;
delete from category where cid = 101;

insert into products values (506,'MacBook',101);

update products set pname = 'Apple Macbook' where pid = 506;

#order by - doesn't alter the table only arranges in asc or desc 
use workers;

select * from worker;
select first_name, salary from worker 
where department = 'admin'
order by salary desc ;

#group by 
select count(worker_id) from worker where department = 'admin' or department = 'hr';

select department, count(worker_id) from worker 
group by department
order by count(worker_id) desc;

#q- print how much salary i am spedning for each department 
select department,sum(salary) from worker
group by department
order by sum(salary) asc;

#HAVING CLAUSE
select department,count(worker_id)
from worker 
group by department 
having count(worker_id)>3;

#which department accumulated salary is less than 3 lakh
select department, sum(salary)
from worker
group by department 
having sum(salary)<300000;

#LIMIT,OFFSET
select * from worker limit 4 offset 5;

#SUBQUERY
create table topper(
 id int
);

insert into topper values (1);
insert into topper values (2);
insert into topper values (5);

select * from topper;

select worker_id, first_name, department 
from worker 
where worker_id in (select id from topper);

#q1-print which dept is getting accumulated salary least first two least
select department, sum(salary)
from worker 
group by department
order by sum(salary) asc
limit 2;

#q2-in admin dept, who is getting the second largest salary
select worker_id, first_name, salary
from worker 
where department = 'admin'
order by salary desc 
limit 1 offset 1;

#q3-in each department i want to print the second largest salary person
select first_name, department, salary
from worker w1 
where salary = (
 select salary from worker w2
 where w1.department = w2.department
 order by salary desc
 limit 1 offset 1
);