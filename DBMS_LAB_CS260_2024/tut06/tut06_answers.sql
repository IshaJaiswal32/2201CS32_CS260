-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 
-- Create students table
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    city VARCHAR(50)
);

-- Create instructors table
CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

-- Create courses table
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

-- Create enrollments table
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO students (student_id, first_name, last_name, age, city) VALUES
	('1', 'Rahul', 'Kumar', '20', 'Delhi'),
	('2', 'Neha', 'Sharma', '22', 'Mumbai'),
	('3', 'Krishna', 'Singh', '21', 'Bangalore'),
	('4', 'Pooja', 'Verma', '23', 'Kolkata'),
	('5', 'Rohan', 'Gupta', '22', 'Hyderabad');

INSERT INTO instructors (instructor_id, first_name, last_name) VALUES
	('1', 'Dr. Akhil', 'Singh'),
	('2', 'Dr. Neha', 'Agarwal'),
	('3', 'Dr. Nitin', 'Warrier');

INSERT INTO courses (course_id, course_name, instructor_id) VALUES
	('101', 'Mathematics', '1'),
	('102', 'Physics', '2'),
	('103', 'History', '3'),
	('104', 'Chemistry', '1'),
	('105', 'Computer Science', '2');

INSERT INTO enrollments (enrollment_id, student_id, course_id, grade) VALUES
	('1', '1', '101', 'A'),
	('2', '2', '102', 'B+'),
	('3', '3', '104', 'A-'),
	('4', '4', '103', 'B'),
	('5', '5', '105', 'A');


--Query 1
select first_name, last_name, course_name
from students
join enrollments
using (student_id)
join courses
using (course_id);      

--Query 2
select course_name, student_id, grade
from courses
join enrollments
using (course_id);

--Query 3
select s.first_name, s.last_name, course_name, concat(i.first_name," ",i.last_name) as instructors
from students s
join enrollments
using (student_id)
join courses
using (course_id)
join instructors i
using (instructor_id);

--Query 4
select first_name, last_name, age, city
from students
join enrollments
using (student_id)
join courses
using (course_id)
where course_name="Mathematics";

--Query 5
select course_name, concat(first_name," ",last_name) as instructors
from courses
join instructors
using (instructor_id);

--Query 6
select first_name, last_name, grade, course_name
from students
join enrollments
using (student_id)
join courses
using (course_id);

--Query 7
select student_id, first_name, last_name, age
from students
join enrollments
using (student_id)
group by student_id
having count(course_id)>1;

--Query 8
select course_name, count(student_id) as no_of_students
from courses
join enrollments
using (course_id)
group by course_id;

--Query 9
select s.student_id, first_name, last_name, age
from students s
left join enrollments e
on s.student_id = e.student_id
where e.course_id is null;

--Query 10
SELECT c.course_name,
       CASE
           WHEN avg_grade >= 3.85 THEN 'A'
           WHEN avg_grade >= 3.50 THEN 'A-'
           WHEN avg_grade >= 3.15 THEN 'B+'
           WHEN avg_grade >= 2.85 THEN 'B'
           WHEN avg_grade >= 2.50 THEN 'B-'
           -- Add more ranges and corresponding letter grades as needed
           ELSE 'C'
       END AS average_letter_grade
FROM (
    SELECT e.course_id,
           AVG(CASE e.grade
               WHEN 'A' THEN 4.0
               WHEN 'A-' THEN 3.7
               WHEN 'B+' THEN 3.3
               WHEN 'B' THEN 3.0
               WHEN 'B-' THEN 2.7
               -- Add more letter grades and corresponding numerical values as needed
               ELSE NULL
           END) AS avg_grade
    FROM enrollments e
    GROUP BY e.course_id
) AS avg_grades
JOIN courses c ON avg_grades.course_id = c.course_id;


--Query 11
select first_name, last_name, course_name
from students 
join enrollments
using (student_id)
join courses
using (course_id)
where grade in ('A+','A','B+');

--Query 12
select first_name, last_name, course_name
from instructors
join courses
using (instructor_id)
where last_name regexp "^S";

--Query 13
select s.first_name, s.last_name, s.age
from students s
join enrollments
using (student_id)
join courses
using (course_id)
join instructors i
using (instructor_id)
where i.first_name = "Dr. Akhil";

--Query 14
SELECT c.course_name,
       MAX(e.grade) AS max_grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;


--Query 15
select first_name, last_name, age, course_name
from students
join enrollments
using (student_id)
join courses
using (course_id)
order by course_name;
