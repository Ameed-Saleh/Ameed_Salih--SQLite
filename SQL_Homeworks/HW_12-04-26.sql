-- Create a new table called STUDENTS with columns and constraints:
ID INT PRIMARY KEY, NAME TEXT NOT NULL, AGE, CITY, GRADE REAL NOT NULL.
CREATE TABLE STUDENTS (
	ID INT PRIMARY KEY ,
	NAME TEXT NOT NULL,
	AGE INT NOT NULL,
	CITY char,
	GRADE REAL NOT NULL
	);
-- Create exactly 4 students that appear in the table below
INSERT INTO STUDENTS (ID, NAME, AGE, CITY, GRADE)
VALUES
(1, 'Noa', 15, 'Tel Aviv', 92.5),
(2, 'Liam', 16, 'Haifa', 88.0),
(3, 'Maya', 15, 'Netanya', 95.0),
(4, 'Omer', 17, 'Jerusalem', 81.5);

---1	Noa	15	Tel Aviv	92.5
---2	Liam	16	Haifa	88
---3	Maya	15	Netanya	95
---4	Omer	17	Jerusalem	81.5


-- select query to display all students and all columns
SELECT *
FROM STUDENTS;
-- select query to show all students only name and grade
SELECT NAME,GRADE
FROM STUDENTS;
-- select query to show all students who got grade above 90
SELECT *
FROM STUDENTS
WHERE GRADE>90;

-- select all students where their name starts with M
SELECT *
FROM STUDENTS
WHERE NAME like 'm%';
--  show the avg grade, max, min
SELECT avg(grade) as avg_grade FROM STUDENTS;
SELECT max(grade) as max_grade FROM STUDENTS;
SELECT min(grade) as min_grade FROM STUDENTS;
--  show all students who got above avg
SELECT *
FROM STUDENTS
WHERE GRADE > (SELECT avg(grade) FROM STUDENTS);

-- Change Liam grade to 90
update STUDENTS
SET GRADE = 90
WHERE name = 'Liam';
-- Delete all students where city starts with "N"
DELETE FROM STUDENTS
WHERE CITY GLOB 'N*';
-- Delete all students with grade 88
DELETE FROM STUDENTS
WHERE GRADE = 88;

---1	Noa	15	Tel Aviv	92.5
---2	Liam	16	Haifa	90
---4	Omer	17	Jerusalem	81.5

--Finally drop the table
DROP Table STUDENTS;

---Execution finished without errors.
---Result: query executed successfully. Took 6ms
---At line 1:
---DROP Table STUDENTS;
