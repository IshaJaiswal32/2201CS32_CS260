-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(50),
    manager_id INT
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL(10,2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    budget DECIMAL(15,2),
    start_date DATE,
    end_date DATE
);

CREATE TABLE works_on (
    emp_id INT,
    project_id INT,
    hours_worked INT,
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);


INSERT INTO departments (department_id, department_name, location, manager_id) VALUES
	('1', 'Engineering', 'New Delhi', '3'),
	('2', 'Sales', 'Mumbai', '5'),
	('3', 'Finance', 'Kolkata', '4');

INSERT INTO employees (emp_id, first_name, last_name, salary, department_id) VALUES
	('1', 'Rahul', 'Kumar', '60000', '1'),
	('2', 'Neha', 'Sharma', '55000', '2'),
	('3', 'Krishna', 'Singh', '62000', '1'),
	('4', 'Pooja', 'Verma', '58000', '3'),
	('5', 'Rohan', 'Gupta', '59000', '2');

INSERT INTO projects (project_id, project_name, budget, start_date, end_date) VALUES
	('101', 'ProjectA', '100000', '2023-01-01', '2023-06-30'),
	('102', 'ProjectB', '80000', '2023-02-15', '2023-08-15'),
	('103', 'ProjectC', '120000', '2023-03-20', '2023-09-30');

INSERT INTO works_on (emp_id, project_id, hours_worked) VALUES
	('1', '101', '120'),
	('2', '102', '80'),
	('3', '101', '100'),
	('4', '103', '140'),
	('5', '102', '90');

-- Create audit table to log salary updates
CREATE TABLE salary_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


--Trigger 1
DELIMITER //
CREATE TRIGGER increase_salary_on_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 60000 THEN
        SET NEW.salary = NEW.salary * 1.10;
    END IF;
END //
DELIMITER ;


--Trigger 2
DELIMITER //
CREATE TRIGGER prevent_department_deletion
BEFORE DELETE ON departments
FOR EACH ROW
BEGIN
    DECLARE emp_count INT;
    SELECT COUNT(*) INTO emp_count FROM employees WHERE department_id = OLD.department_id;
    
    IF emp_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete department with assigned employees.';
    END IF;
END//
DELIMITER ;

--Trigger 3
DELIMITER //
CREATE TRIGGER log_salary_updates
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary != OLD.salary THEN
        INSERT INTO salary_audit (emp_id, old_salary, new_salary, first_name, last_name)
        VALUES (NEW.emp_id, OLD.salary, NEW.salary, NEW.first_name, NEW.last_name);
    END IF;
END//
DELIMITER;

--Trigger 4
DELIMITER //
CREATE TRIGGER assign_department_on_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary <= 60000 THEN
        SET NEW.department_id = 3;
    END IF;
END//
DELIMITER;

--Trigger 5
DELIMITER //
CREATE TRIGGER update_manager_salary_on_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    DECLARE highest_salary DECIMAL(10,2);
    DECLARE manager_id INT;
    
    SELECT MAX(salary), emp_id INTO highest_salary, manager_id
    FROM employees
    WHERE department_id = NEW.department_id;
    
    IF manager_id IS NOT NULL THEN
        UPDATE employees
        SET salary = highest_salary
        WHERE emp_id = manager_id;
    END IF;
END//
DELIMITER;

--Trigger 6
DELIMITER //
CREATE TRIGGER prevent_department_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    DECLARE has_projects INT;
    SELECT COUNT(*) INTO has_projects
    FROM works_on
    WHERE emp_id = NEW.emp_id;
    
    IF has_projects > 0 AND NEW.department_id != OLD.department_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot change department of an employee working on projects.';
    END IF;
END//
DELIMITER;

--Trigger 7
DELIMITER //
CREATE TRIGGER update_average_salary
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary != OLD.salary THEN
        DECLARE average_salary DECIMAL(10,2);
        
        SELECT AVG(salary) INTO average_salary
        FROM employees
        WHERE department_id = NEW.department_id;
        
        UPDATE departments
        SET average_salary = average_salary
        WHERE department_id = NEW.department_id;
    END IF;
END//
DELIMITER;

--Trigger 8
DELIMITER //
CREATE TRIGGER delete_employee_projects
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    DELETE FROM works_on
    WHERE emp_id = OLD.emp_id;
END//
DELIMITER;

--Trigger 9
DELIMITER //
CREATE TRIGGER prevent_low_salary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    DECLARE min_salary DECIMAL(10,2);
    
    SELECT MIN(salary) INTO min_salary
    FROM employees
    WHERE department_id = NEW.department_id;
    
    IF NEW.salary < min_salary THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot insert employee with salary below minimum for the department.';
    END IF;
END//
DELIMITER;

--Trigger 10
DELIMITER //
CREATE TRIGGER update_department_budget
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    DECLARE old_salary DECIMAL(10,2);
    DECLARE new_salary DECIMAL(10,2);
    DECLARE budget_change DECIMAL(10,2);
    
    SET old_salary = OLD.salary;
    SET new_salary = NEW.salary;
    
    SET budget_change = new_salary - old_salary;
    
    UPDATE departments
    SET total_salary_budget = total_salary_budget + budget_change
    WHERE department_id = NEW.department_id;
END//
DELIMITER;

--Trigger 11

--Trigger 12
DELIMITER //
CREATE TRIGGER prevent_department_without_location
BEFORE INSERT ON departments
FOR EACH ROW
BEGIN
    IF NEW.location IS NULL OR NEW.location = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot insert department without location.';
    END IF;
END//
DELIMITER;

--Trigger 13
DELIMITER //
CREATE TRIGGER update_employee_department_name
AFTER UPDATE ON departments
FOR EACH ROW
BEGIN
    IF NEW.department_name != OLD.department_name THEN
        UPDATE employees
        SET department_name = NEW.department_name
        WHERE department_id = NEW.department_id;
    END IF;
END//
DELIMITER;

--Trigger 14
DELIMITER //
CREATE TRIGGER log_employee_changes
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW
BEGIN
    IF (INSERTING) THEN
        INSERT INTO employee_audit (emp_id, first_name, last_name, salary, department_id, action_type, action_time)
        VALUES (NEW.emp_id, NEW.first_name, NEW.last_name, NEW.salary, NEW.department_id, 'INSERT', CURRENT_TIMESTAMP);
    ELSIF (UPDATING) THEN
        INSERT INTO employee_audit (emp_id, first_name, last_name, salary, department_id, action_type, action_time)
        VALUES (NEW.emp_id, NEW.first_name, NEW.last_name, NEW.salary, NEW.department_id, 'UPDATE', CURRENT_TIMESTAMP);
    ELSIF (DELETING) THEN
        INSERT INTO employee_audit (emp_id, first_name, last_name, salary, department_id, action_type, action_time)
        VALUES (OLD.emp_id, OLD.first_name, OLD.last_name, OLD.salary, OLD.department_id, 'DELETE', CURRENT_TIMESTAMP);
    END IF;
END//
DELIMITER;

--Trigger 15
-- Create a sequence for employee IDs
DELIMITER //
CREATE SEQUENCE emp_id_seq
START WITH 1
INCREMENT BY 1;

-- Use the sequence in the trigger
DELIMITER//
CREATE TRIGGER generate_emp_id
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    SET NEW.emp_id = NEXTVAL(emp_id_seq);
END//
DELIMITER;
