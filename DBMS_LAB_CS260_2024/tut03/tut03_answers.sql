-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 
--Table creation and inserting values
--Server 8.0.36
--Kindly Remove comments if the file doesn't work
CREATE TABLE `students` (
  `student_id` BIGINT,
  `first_name` VARCHAR(1024),
  `last_name` VARCHAR(1024),
  `age` BIGINT,
  `city` VARCHAR(1024),
  `state` VARCHAR(1024),
  PRIMARY KEY (student_id)
);

INSERT INTO `students` (`student_id`,`first_name`,`last_name`,`age`,`city`,`state`)
VALUES
(1,'Rahul','Sharma',21,'Delhi','Delhi'),
(2,'Pooja','Patel',20,'Mumbai','Maharashtra'),
(3,'Krishna','Singh',22,'Lucknow','Uttar Pradesh'),
(4,'Anjali','Reddy',23,'Hyderabad','Telangana'),
(5,'Suresh','Kumar',21,'Bangalore','Karnataka'),
(6,'Riya','Gupta',22,'Kolkata','West Bengal'),
(7,'Rajesh','Mehta',20,'Ahmedabad','Gujarat'),
(8,'Kavita','Desai',21,'Pune','Maharashtra'),
(9,'Arjun','Mishra',22,'Jaipur','Rajasthan'),
(10,'Divya','Choudhary',20,'Chandigarh','Punjab'),
(11,'Akash','Bansal',21,'Indore','Madhya Pradesh'),
(12,'Mohit','Verma',22,'Ludhiana','Punjab'),
(13,'Jyoti','Chauhan',20,'Nagpur','Maharashtra'),
(14,'Varun','Rao',23,'Visakhapatnam','Andhra Pradesh'),
(15,'Nisha','Tiwari',21,'Patna','Bihar');

CREATE TABLE `instructors` (
  `instructor_id` BIGINT,
  `first_name` VARCHAR(1024),
  `last_name` VARCHAR(1024),
  `email` VARCHAR(1024),
  PRIMARY KEY (instructor_id)
);

INSERT INTO `instructors` (`instructor_id`,`first_name`,`last_name`,`email`)
VALUES
(1,'Dr. Akhil','Singh','drsingh@example.com'),
(2,'Dr. Neha','Agarwal','dragarwal@example.com'),
(3,'Dr. Nitin','Warrier','drwarrier@example.com');

CREATE TABLE `courses` (
  `course_id` BIGINT,
  `course_name` VARCHAR(1024),
  `credit_hours` BIGINT,
  `instructor_id` BIGINT,
  PRIMARY KEY (course_id),
  FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
  
);

INSERT INTO `courses` (`course_id`,`course_name`,`credit_hours`,`instructor_id`)
VALUES
(101,'Mathematics',3,1),
(102,'Physics',4,2),
(103,'History',3,3),
(104,'Chemistry',4,1),
(105,'Computer Science',3,2);


CREATE TABLE `enrollments` (
  `enrollment_id` BIGINT,
  `student_id` BIGINT,
  `course_id` BIGINT,
  `enrollment_date` VARCHAR(1024),
  `grade` VARCHAR(1024),
  PRIMARY KEY (enrollment_id),
   FOREIGN KEY (student_id) REFERENCES students(student_id),
   FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO `enrollments` (`enrollment_id`,`student_id`,`course_id`,`enrollment_date`,`grade`)
VALUES
(1,1,101,'2022-09-01','A'),
(2,2,102,'2022-09-03','B+'),
(3,3,104,'2022-09-05','A-'),
(4,4,103,'2022-09-07','B'),
(5,5,105,'2022-09-10','A');



--Queries start here

--Query 1
select first_name, last_name from students;

--Query 2
select course_name, credit_hours from courses;

--Query 3
select first_name, last_name, email from instructors;

--Query 4
select student_id, course_name, grade from students 
left join enrollments
using (student_id)
left join courses
using (course_id);

--Query 5
select first_name, last_name, city
from students;

--Query 6
SELECT course_name, CONCAT(first_name, ' ', last_name) AS instructor_name
 FROM courses
 JOIN instructors
 USING (instructor_id);

--Query 7
select first_name, last_name, age
 from students;

--Query 8
select student_id, course_name, enrollment_date
 from students
 left join enrollments
 using (student_id)
 left join courses
 using (course_id);

--Query 9
select concat(first_name,' ',last_name) as instructor_name, email
 from instructors;

--Query 10
select course_name, credit_hours
 from courses;

--Query 11
select first_name, last_name, email
 from instructors
 join courses
 using (instructor_id)
 where course_name = 'Mathematics';

--Query 12
select student_id, course_name, grade
 from students
 join enrollments
 using (student_id)
 join courses
 using (course_id)
 where grade = 'A';

--Query 13
select first_name, last_name, state
   from students
   join enrollments
   using (student_id)
   join courses
   using (course_id)
   where course_name = 'Computer Science';

--Query 14
 select student_id, course_name, enrollment_date
 from students 
 join enrollments
 using (student_id)
 join courses
 using (course_id)
 where grade = 'B+';

--Query 15
select concat(first_name,' ',last_name) as instructor_names, email
 from instructors
 join courses
 using (instructor_id)
 where credit_hours>3;
