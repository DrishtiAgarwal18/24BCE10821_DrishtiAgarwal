use db;
show tables in db;

-- Create Departments Table
CREATE TABLE Departments (
dept_id INT PRIMARY KEY,
dept_name VARCHAR(50) NOT NULL,
location VARCHAR(50)
);
INSERT INTO Departments (dept_id, dept_name, location) VALUES
(10, 'Finance', 'New York'),
(20, 'IT', 'San Francisco'),
(30, 'Sales', 'Chicago'),
(40, 'Marketing', 'Los Angeles');
-- Create Jobs Table
CREATE TABLE Jobs (
job_id INT PRIMARY KEY,
job_title VARCHAR(50),
min_salary DECIMAL(10,2),
max_salary DECIMAL(10,2)
);
INSERT INTO Jobs (job_id, job_title, min_salary, max_salary) VALUES
(1, 'Manager', 80000.00, 150000.00),
(2, 'Developer', 60000.00, 110000.00),
(3, 'Analyst', 50000.00, 90000.00),
(4, 'Intern', 30000.00, 45000.00);
-- Create Employees Table
CREATE TABLE Employees (
emp_id INT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
manager_id INT,
dept_id INT,
job_id INT,
salary DECIMAL(10,2),
hire_date DATE,
FOREIGN KEY (dept_id) REFERENCES Departments(dept_id),
FOREIGN KEY (job_id) REFERENCES Jobs(job_id)
);
INSERT INTO Employees (emp_id, name, manager_id, dept_id, job_id, salary, hire_date) VALUES
-- Top Level Manager
(501, 'Alice', NULL, 10, 1, 120000.00, '2015-01-01'),
-- IT Dept Staff
(503, 'Charlie', 501, 20, 1, 95000.00, '2016-05-20'),
(504, 'David', 503, 20, 2, 85000.00, '2019-11-01'),
(505, 'Eve', 503, 20, 2, 78000.00, '2020-02-15'),
-- Finance Dept Staff
(502, 'Bob', 501, 10, 3, 55000.00, '2018-03-12'),
-- Sales Dept Staff
(506, 'Frank', 501, 30, 3, 52000.00, '2021-06-21'),
-- Marketing (unassigned to manager for complexity)
(507, 'Grace', NULL, 40, 2, 72000.00, '2022-08-10');


-- Questions:

select * from departments;
select * from jobs;
select * from employees;

#1.[JOINS] List the name of each employee along with their job title and department name.
select e.name,j.job_title,d.dept_name 
from employees e 
join jobs j 
on e.job_id = j.job_id
join departments d
on e.dept_id = d.dept_id
order by e.emp_id asc;

#2.[SUBQUERY] Find all employees whose salary is higher than the average salary of the 'IT' department.
select e.emp_id ,e.name, e.salary
from employees e 
where e.salary > (
select avg(salary)
from employees e1
join departments d
on e1.dept_id = d.dept_id 
where d.dept_name = 'it'
);

#3.[GROUP BY] Calculate the total salary expenditure for each department name (not ID).
select d.dept_name, sum(e.salary) as total_salary_expenditure
from employees e
join departments d
on e.dept_id = d.dept_id
group by d.dept_name;

#4.[HAVING] Display departments that have more than 2 employees and an average salary above 70,000.
select d.dept_name , count(emp_id), avg(e.salary)
from departments d 
join employees e
on d.dept_id = e.dept_id 
group by d.dept_name
having count(e.emp_id) > 2 and avg(e.salary)>70000;

#5.[SELF JOIN] Retrieve a list of employee names and their respective manager's names.
select e.name as employee_name, m.name as manager_name 
from employees e
left join employees m 
on e.manager_id = m.emp_id;

#6.[ORDER BY] Find the top 3 highest-paid employees and list them in descending order.
select e.name, e.salary 
from employees e 
order by e.salary desc
limit 3;

#7.[JOINS + WHERE] Find all Developers working in the 'San Francisco' location.
select e.name , j.job_title, d.location
from employees e
join jobs j 
on e.job_id = j.job_id 
join departments d 
on e.dept_id = d.dept_id 
where j.job_title = 'Developer' and d.location = 'San Francisco';

#8.[GROUP BY] Find the number of employees hired each year.
select year(hire_date), count(emp_id) 
from employees 
group by year(hire_date) 
order by year(hire_date);

#9.[HAVING] List job titles where the maximum salary of an employee in that role is less than 100,000.
select j.job_title, max(e.salary)
from jobs j 
join employees e 
on j.job_id = e.job_id
group by j.job_title 
having max(e.salary) < 100000;

#10.[SUBQUERY] Find the names of employees who work in the same department as 'David'.
select emp_id, name 
from employees 
where dept_id = (
select dept_id 
from employees 
where name='david'
) and name != 'david';

#11.[MULTI-TABLE JOIN] Show all department names even if they have no employees assigned to them.
select d.dept_name , e.name
from departments d 
left join employees e 
on d.dept_id = e.dept_id;

#12.[COMPLEX FILTER] Find employees who were hired between 2018 and 2020 and earn more than 60,000.
select emp_id, name, hire_date, salary
from employees 
where year(hire_date) between 2018 and 2020 and salary > 60000;

#13.[CORRELATED SUBQUERY] Find employees who earn more than the average salary of their own department.
select e.emp_id, e.name , e.salary, d.dept_name
from employees e
join departments d
on e.dept_id = d.dept_id
where e.salary > (
select avg(salary) 
from employees 
where e.dept_id = d.dept_id
);

#14.[JOINS] Find the job title and salary of the employee with ID 504.
select e.emp_id, e.name, j.job_title, e.salary 
from employees e
join jobs j 
on e.job_id = j.job_id 
where e.emp_id = 504;

#15.[GROUP BY] For each manager (by ID), find the minimum salary of the people reporting to them.
select m.name as manager, min(e.salary)
from employees e 
join employees m
on m.emp_id = e.manager_id
group by m.name;

#16.[SUBQUERY] List departments that do not have any 'Analysts'.
select dept_name 
from departments 
where dept_id not in 
(select dept_id from employees e
join jobs j 
on e.job_id = j.job_id 
where j.job_title = 'analyst');

#17.[AGGREGATION] Find the difference between the highest and lowest salary in the company.
select max(salary) - min(Salary) as difference from employees;

#18.[JOIN + ORDER BY] Display employee names and hire dates, sorted by department name (A-Z) and then by salary (High to Low).
select e.name, e.hire_date, d.dept_name, e.salary
from employees e
join departments d
on e.dept_id = d.dept_id 
order by dept_name asc ,e.salary desc;

#19.[HAVING] Identify managers (by ID) who manage more than 2 people.
select m.name, count(e.emp_id)
from employees e 
join employees m 
on e.manager_id = m.emp_id
group by m.name
having count(e.emp_id)>2;

#20.[SUBQUERY] Find the employee(s) with the third-highest salary.
select emp_id, name, salary 
from employees
order by salary desc
limit 1 offset 2;

#21.[LEFT JOIN] List all job titles and the number of employees currently holding that job.
select j.job_title, count(e.emp_id)
from jobs j 
left join employees e
on j.job_id = e.job_id
group by j.job_title;

#22.[JOIN + LIKE] Find employees in the 'Finance' department whose names contain the letter 'i'.
select e.name 
from employees e
join departments d 
on e.dept_id = d.dept_id 
where e.name like '%i%' and d.dept_name = 'finance';

#23.[MATH + GROUP BY] Calculate the 10% bonus amount for each employee and show the total bonus per department.
select d.dept_name, sum(e.salary * 0.1) as total_bonus
from departments d
join employees e 
on d.dept_id = e.dept_id
group by d.dept_name;

#24.[SUBQUERY] List the name of the department that pays the highest total salary.
select d.dept_name, max(e.salary)
from departments d
join employees e 
on d.dept_id = e.dept_id 
group by d.dept_name
limit 1;

#25.[JOINS] Find all employees who report to 'Charlie'.
select e.name 
from employees e 
join employees m 
on e.manager_id = m.emp_id
where m.name = 'charlie';