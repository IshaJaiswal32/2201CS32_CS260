-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 
--Query 1
SELECT e.*
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Engineering';

--Query 2
SELECT first_name, salary
FROM employees;

--Query 3
SELECT e.*
FROM employees e
JOIN departments d ON e.emp_id = d.manager_id;

--Query 4
SELECT *
FROM employees
WHERE salary > 60000;

--Query 5
SELECT e.*, d.*
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

--Query 6
SELECT *
FROM employees, projects;

--Query 7
SELECT *
FROM employees e
WHERE e.emp_id NOT IN (
    SELECT d.manager_id
    FROM departments d
);

--Query 8
SELECT *
FROM departments d
NATURAL JOIN projects p;

--Query 9
SELECT department_name, location
FROM departments;

--Query 10
SELECT *
FROM projects
WHERE budget > 100000;

--Query 11
SELECT e.*
FROM employees e
JOIN departments d ON e.emp_id = d.manager_id
WHERE d.department_name = 'Sales';

--Query 12
SELECT e.*
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Engineering'
UNION
SELECT e.*
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';

--Query 13
SELECT e.*
FROM employees e
LEFT JOIN projects p ON e.emp_id = p.emp_id
WHERE p.emp_id IS NULL;

--Query 14
SELECT e.*, p.*
FROM employees e
JOIN projects p ON e.emp_id = p.emp_id;

--Query 15
SELECT *
FROM employees
WHERE salary < 50000 OR salary > 70000;
