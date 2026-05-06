
CREATE TABLE drivers (
  id     INTEGER PRIMARY KEY,
  name   TEXT    NOT NULL,
  car_id INTEGER,
  FOREIGN KEY (car_id) REFERENCES cars(id)
);
INSERT INTO drivers VALUES
  (1,'Dana',1),
  (2,'Omar',2),
  (3,'Noa',NULL),
  (4,'Liam',3),
  (5,'Rina',NULL);


CREATE TABLE cars (
  id    INTEGER PRIMARY KEY,
  model TEXT    NOT NULL,
  price REAL    NOT NULL
);
INSERT INTO cars VALUES
  (1,'Toyota Corolla',22000),
  (2,'Honda Civic',24000),
  (3,'Ford Focus',19000),
  (4,'Tesla Model 3',42000);


--1. Write a FULL OUTER JOIN to show all drivers and all cars in one result set
SELECT d.name , c.model , c.price
FROM   drivers d
FULL OUTER JOIN cars c ON d.car_id = c.id;

--2. From the full-outer result, find only the unmatched rows on EITHER side — drivers with no car AND cars with no driver — add a WHERE clause
SELECT d.name , c.model , c.price
FROM   drivers d
FULL OUTER JOIN cars c ON d.car_id = c.id
WHERE  c.id IS NULL
    OR d.car_id is NULL;


--3. Use COALESCE to replace NULL car prices with 0 for drivers who have no car assigned
SELECT
  d.name,
  c.model,
  COALESCE(c.price, 0) AS price
FROM drivers d
FULL OUTER JOIN cars c ON d.car_id = c.id;


--4. Which single join type lets you find drivers WITHOUT a car AND cars WITHOUT a driver in one query?

--answer: The single join type is the FULL OUTER JOIN.
--A LEFT or RIGHT JOIN only returns unmatched rows from one table

--LEFT JOIN: Shows all drivers, but ignores cars without drivers.
SELECT d.name
FROM   drivers d
LEFT JOIN cars c ON d.car_id = c.id
WHERE  c.id IS NULL;
-- Noa , Rina

--RIGHT JOIN: Shows all cars, but ignores drivers without cars.
SELECT c.model
FROM   drivers d
RIGHT JOIN cars c  ON d.car_id = c.id
WHERE  d.id IS NULL;
--Tesla Model 3