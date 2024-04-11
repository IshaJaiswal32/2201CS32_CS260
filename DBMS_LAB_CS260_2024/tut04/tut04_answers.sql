-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 
 --table creation and inserting values
 CREATE TABLE projects (
      project_id INT PRIMARY KEY,
          project_name VARCHAR(255),
          budget DECIMAL(10,2),
          start_date DATE,
          end_date DATE
      );

  CREATE TABLE departments (
          department_id INT PRIMARY KEY,
          department_name VARCHAR(255),
          location VARCHAR(255)
      );

  CREATE TABLE employees (
          emp_id INT PRIMARY KEY,
          first_name VARCHAR(255),
          last_name VARCHAR(255),
          salary DECIMAL(10,2),
          department_id INT,
          FOREIGN KEY (department_id) REFERENCES departments(department_id)
      );

  INSERT INTO departments (department_id, department_name, location) VALUES
       ('1', 'Engineering', 'New Delhi'),
       ('2', 'Sales', 'Mumbai'),
       ('3', 'Finance', 'Kolkata');


  INSERT INTO projects (project_id, project_name, budget, start_date, end_date) VALUES
       ('101', 'ProjectA', '100000', '2023-01-01', '2023-06-30'),
       ('102', 'ProjectB', '80000', '2023-02-15', '2023-08-15'),
       ('103', 'ProjectC', '120000', '2023-03-20', '2023-09-30');


  INSERT INTO employees (emp_id, first_name, last_name, salary, department_id) VALUES
       ('1', 'Rahul', 'Kumar', '60000', '1'),
       ('2', 'Neha', 'Sharma', '55000', '2'),
       ('3', 'Krishna', 'Singh', '62000', '1'),
       ('4', 'Pooja', 'Verma', '58000', '3'),
       ('5', 'Rohan', 'Gupta', '59000', '2');

--Query 1
select first_name,last_name
from employees;

--Query 2
select * from departments;

--Query 3
select project_name, budget
from projects;

--Query 4
select first_name, last_name, salary
from employees
join departments
using (department_id)
where department_name = 'Engineering';

--Query 5
select project_name, start_date
from projects;

--Query 6
select first_name, last_name, department_name
from employees
join departments
using (department_id);

--Query 7
select project_name
from projects
where budget>90000;

--Query 8
select sum(budget) as Total_Budeget
from projects;

--Query 9
select first_name, last_name, salary
from employees
where salary>60000;

--Query 10
select project_name, end_date
from projects;

--Query 11
select department_name
from departments
where location="New Delhi";

--Query 12
select avg(salary) as Average_Salary
from employees;

--Query 13
select first_name, last_name, department_name
from employees
join departments
using (department_id)
where department_name = "Finance";

--Query 14
select project_name
from projects
where budget between 70000 and 100000;

--Query 15
select count(emp_id), department_name
from employees
join departments
using (department_id)
group by department_id;
