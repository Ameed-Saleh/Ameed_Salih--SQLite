--1 -> Create a new table called workshop_roster with these field rules:
CREATE TABLE workshop_roster(
	roster_id INTEGER PRIMARY KEY NOT NULL,
	contact_email TEXT UNIQUE,
	display_name TEXT NOT NULL,
	wants_certificate BOOLEAN NOT NULL DEFAULT FALSE,
	start_date DATE NOT NULL,
	last_activity  DATETIME NOT NULL,
	completion_score REAL CHECK (completion_score BETWEEN 0 AND 100),
	group_label  TEXT DEFAULT 'starter'
);

--2 -> Insert exactly 5 rows from the sample table below
INSERT INTO workshop_roster (roster_id, contact_email, display_name,wants_certificate, start_date, last_activity,completion_score, group_label)
VALUES
(1 ,'mika@campus.com' ,	 'Mika',	1 ,	'2026-04-01' , '2026-04-14 08:15:00' , 94.5, 'advanced'),
(2 ,'matan@campus.com' , 'Matan',	1 ,	'2026-04-05' , '2026-04-12 18:20:00' , 82.0, 'advanced'),
(3 ,'nora@campus.com' ,	 'Nora',	0 ,	'2026-04-07' , '2026-04-09 10:00:00' , 74.0, 'starter'),
(4 ,'liam@campus.com' ,	 'Liam',	1 ,	'2026-04-010' , '2026-04-15 07:45:00' , 88.0, 'regular'),
(5 ,'dana@campus.com' ,	 'Dana',	0 ,	'2026-04-11' , '2026-04-11 21:05:00' , 69.5, 'starter');


--3 -> Write these SELECT queries using only lesson 2 material:

--3.1 ->  show all rows and all columns:
SELECT *
FROM workshop_roster;
--1	mika@campus.com	    Mika	1	2026-04-01	2026-04-14 08:15:00	94.5	advanced
--2	matan@campus.com	Matan	1	2026-04-05	2026-04-12 18:20:00	82.0	advanced
--3	nora@campus.com	    Nora	0	2026-04-07	2026-04-09 10:00:00	74.0	starter
--4	liam@campus.com	    Liam	1	2026-04-010	2026-04-15 07:45:00	88.0	regular
--5	dana@campus.com	    Dana	0	2026-04-11	2026-04-11 21:05:00	69.5	starter

--3.2 ->  show only display_name, contact_email, completion_score
SELECT display_name, contact_email, completion_score
FROM workshop_roster;
--Mika	mika@campus.com	    94.5
--Matan	matan@campus.com	82.0
--Nora	nora@campus.com	    74.0
--Liam	liam@campus.com	    88.0
--Dana	dana@campus.com	    69.5

--3.3 -> show rows where wants_certificate = FALSE and last_activity < '2026-04-10'
SELECT *
FROM workshop_roster
WHERE wants_certificate = FALSE
	AND last_activity < '2026-04-10';
--3	nora@campus.com	Nora	0	2026-04-07	2026-04-09 10:00:00	74.0	starter

--3.4 ->  show rows where display_name and contact_email both start with m (use LIKE)
SELECT *
FROM workshop_roster
WHERE display_name LIKE 'M%'
	AND contact_email LIKE 'm%';
--1	mika@campus.com	    Mika	1	2026-04-01	2026-04-14 08:15:00	94.5	advanced
--2	matan@campus.com	Matan	1	2026-04-05	2026-04-12 18:20:00	82.0	advanced

--3.5 -> show rows where completion_score < 85
SELECT *
FROM workshop_roster
WHERE completion_score < 85;
--2	matan@campus.com	Matan	1	2026-04-05	2026-04-12 18:20:00	82.0	advanced
--3	nora@campus.com	    Nora	0	2026-04-07	2026-04-09 10:00:00	74.0	starter
--5	dana@campus.com	    Dana	0	2026-04-11	2026-04-11 21:05:00	69.5	starter

--4 -> Try one insert with duplicate contact_email and explain which constraint blocks it
INSERT INTO workshop_roster (roster_id, contact_email, display_name,wants_certificate, start_date, last_activity,completion_score, group_label)
VALUES (6 ,'mika@campus.com' ,	'Mika',	0 ,	'2026-04-01' , '2026-04-14 08:15:00' , 70.0, 'regular');

-- error: duplicate email (UNIQUE)
--Execution finished with errors.
--Result: UNIQUE constraint failed: workshop_roster.contact_email

--5 -> Try one insert with completion_score = 120 and explain which constraint blocks it
 INSERT INTO workshop_roster (roster_id, contact_email, display_name,wants_certificate, start_date, last_activity,completion_score)
 VALUES (7 ,'ameed@campus.com' ,	'Ameed',	1 ,	'2026-04-01' , '2026-04-14 08:15:00' , 120.0 );

-- error: completion_score must be between 0 AND 100.
--Result: CHECK constraint failed: completion_score BETWEEN 0 AND 100




