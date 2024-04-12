-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 
-- Create the departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(50),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

-- Create the employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Create the projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    budget DECIMAL(15, 2),
    start_date DATE,
    end_date DATE
);

--Procedure 1
CREATE PROCEDURE CalculateAverageSalary(departmentID INT)
BEGIN
    DECLARE avgSalary DECIMAL(10,2);
    
    SELECT AVG(salary) INTO avgSalary
    FROM employees
    WHERE department_id = departmentID;
    
    SELECT avgSalary AS AverageSalary;
END;

--Procedure 2
CREATE PROCEDURE UpdateEmployeeSalary(empID INT, percentageIncrease DECIMAL(5,2))
BEGIN
    UPDATE employees
    SET salary = salary * (1 + percentageIncrease / 100)
    WHERE emp_id = empID;
END;

--Procedure 3
CREATE PROCEDURE ListEmployeesInDepartment(departmentID INT)
BEGIN
    SELECT emp_id, first_name, last_name, salary
    FROM employees
    WHERE department_id = departmentID;
END;


--Procedure 4
CREATE PROCEDURE CalculateTotalProjectBudget(projectID INT)
BEGIN
    DECLARE totalBudget DECIMAL(10,2);
    
    SELECT budget INTO totalBudget
    FROM projects
    WHERE project_id = projectID;
    
    SELECT totalBudget AS TotalBudget;
END;

--Procedure 5
CREATE PROCEDURE FindHighestSalaryEmployee(departmentID INT)
BEGIN
    DECLARE highestSalary DECIMAL(10,2);
    DECLARE employeeID INT;
    
    SELECT emp_id, MAX(salary) INTO employeeID, highestSalary
    FROM employees
    WHERE department_id = departmentID;
    
    SELECT emp_id, first_name, last_name, salary
    FROM employees
    WHERE emp_id = employeeID;
END;

--Procedure 6
CREATE PROCEDURE ListProjectsDueInDays(days INT)
BEGIN
    DECLARE currentDate DATE;
    SET currentDate = CURDATE();
    
    SELECT project_id, project_name, end_date
    FROM projects
    WHERE end_date <= DATE_ADD(currentDate, INTERVAL days DAY);
END;

--Procedure 7
CREATE PROCEDURE CalculateTotalSalaryExpenditure(departmentID INT)
BEGIN
    DECLARE totalExpenditure DECIMAL(10,2);
    
    SELECT SUM(salary) INTO totalExpenditure
    FROM employees
    WHERE department_id = departmentID;
    
    SELECT totalExpenditure AS TotalSalaryExpenditure;
END;

--Procedure 8
CREATE PROCEDURE GenerateEmployeeReport()
BEGIN
    SELECT e.emp_id, e.first_name, e.last_name, e.salary, d.department_name, d.location
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id;
END;

--Procedure 9
CREATE PROCEDURE FindProjectWithHighestBudget()
BEGIN
    SELECT project_id, project_name, budget
    FROM projects
    ORDER BY budget DESC
    LIMIT 1;
END;

--Procedure 10
CREATE PROCEDURE CalculateAverageSalaryAcrossDepartments()
BEGIN
    DECLARE avgSalary DECIMAL(10,2);
    
    SELECT AVG(salary) INTO avgSalary
    FROM employees;
    
    SELECT avgSalary AS AverageSalary;
END;

--Procedure 11
CREATE PROCEDURE AssignNewManager(departmentID INT, newManagerID INT)
BEGIN
    UPDATE departments
    SET manager_id = newManagerID
    WHERE department_id = departmentID;
END;

--Procedure 12
CREATE PROCEDURE CalculateRemainingBudget(projectID INT, actualSpent DECIMAL(10,2))
BEGIN
    DECLARE projectBudget DECIMAL(10,2);
    
    SELECT budget INTO projectBudget
    FROM projects
    WHERE project_id = projectID;
    
    SELECT projectBudget - actualSpent AS RemainingBudget;
END;

--Procedure 13
CREATE PROCEDURE GenerateEmployeesJoinedInYear(joinYear INT)
BEGIN
    SELECT emp_id, first_name, last_name, department_id, salary
    FROM employees
    WHERE YEAR(start_date) = joinYear;
END;


--Procedure 14
CREATE PROCEDURE UpdateProjectEndDate(projectID INT, durationInDays INT)
BEGIN
    DECLARE startDate DATE;
    
    SELECT start_date INTO startDate
    FROM projects
    WHERE project_id = projectID;
    
    UPDATE projects
    SET end_date = DATE_ADD(startDate, INTERVAL durationInDays DAY)
    WHERE project_id = projectID;
END;

--Procedure 15
CREATE PROCEDURE CalculateTotalEmployeesInEachDepartment()
BEGIN
    SELECT d.department_id, d.department_name, COUNT(e.emp_id) AS TotalEmployees
    FROM departments d
    LEFT JOIN employees e ON d.department_id = e.department_id
    GROUP BY d.department_id, d.department_name;
END;
