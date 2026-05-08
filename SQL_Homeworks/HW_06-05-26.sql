-- TOPIC 6 -> Self-Join — A Table Joined to Itself
DROP TABLE flights  ;
CREATE TABLE flights (
  id             INTEGER PRIMARY KEY,
  flight_no      TEXT    NOT NULL,
  origin         TEXT    NOT NULL,
  destination    TEXT    NOT NULL,
  prev_flight_id INTEGER,
  FOREIGN KEY (prev_flight_id) REFERENCES flights(id)
);
INSERT INTO flights VALUES
  (1,'TK101','NYC','London',NULL),
  (2,'TK102','London','Dubai',1),
  (3,'TK103','Dubai','Tokyo',2),
  (4,'TK104','Tokyo','Seoul',3),
  (5,'TK105','Tokyo','Sydney',3),
  (6,'AA201','LA','Chicago',NULL),
  (7,'AA202','Chicago','NYC',6),
  (8,'AA203','NYC','Miami',7),
  (9,'AA204','NYC','Boston',7),
  (10,'BA301','Paris','Rome',NULL),
  (11,'LH401','Frankfurt','Berlin',NULL),
  (12,'LH402','Amsterdam','London',11);

--1. Show every flight with its predecessor flight number — use LEFT JOIN so origin flights (no predecessor) appear with NULL
SELECT
    f1.flight_no AS current_flight_number,
    f1.origin,
    f1.destination,
    f2.flight_no AS predecessor_flight_number
FROM flights f1
LEFT JOIN flights f2
    ON f1.prev_flight_id = f2.id;

--2. Show only flights that directly follow 'TK101' (i.e. where the predecessor flight is TK101)
SELECT  f1.flight_no AS current_flight_number,
    f1.origin,
    f1.destination,
	f2.flight_no AS predecessor_flight_number
FROM flights f1
INNER JOIN flights f2
    ON f1.prev_flight_id = f2.id
WHERE f2.flight_no like 'TK101';
--TK102  	London	  Dubai	  TK101


--3. Count how many onward connections each flight has (how many flights list it as predecessor), sorted descending
SELECT
    f1.flight_no,
    COUNT(f2.id) AS onward_connection_count
FROM flights f1
LEFT JOIN flights f2
    ON f1.id = f2.prev_flight_id
GROUP BY f1.id, f1.flight_no
ORDER BY onward_connection_count DESC;

--4. Find flights where the predecessor's destination doesn't match the current flight's origin — a data-inconsistency check
SELECT
    f1.flight_no AS current_flight_number,
    f1.origin AS current_origin,
    f2.flight_no AS predecessor_flight_number,
    f2.destination AS predecessor_destination
FROM flights f1
INNER JOIN flights f2
    ON f1.prev_flight_id = f2.id
WHERE f1.origin != f2.destination;
--LH402	  Amsterdam	  LH401	  Berlin


-- TOPIC 7 -> Joining 3+ Tables
CREATE TABLE customers (
  id    INTEGER PRIMARY KEY,
  name  TEXT    NOT NULL,
  email TEXT    NOT NULL
);
INSERT INTO customers VALUES
  (1,'Alice','alice@mail.com'),
  (2,'Bob','bob@mail.com'),
  (3,'Carol','carol@mail.com'),
  (4,'Dan','dan@mail.com'),
  (5,'Eva','eva@mail.com'),
  (6,'Frank','frank@mail.com');


CREATE TABLE orders (
  id          INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  product_id  INTEGER NOT NULL,
  quantity    INTEGER NOT NULL,
  order_date  TEXT    NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (product_id)  REFERENCES products(id)
);
INSERT INTO orders VALUES
  (1,1,3,2,'2024-01-05'),
  (2,1,7,1,'2024-01-18'),
  (3,2,1,3,'2024-02-02'),
  (4,2,10,1,'2024-02-14'),
  (5,3,5,2,'2024-03-01'),
  (6,4,2,1,'2024-03-15'),
  (7,4,8,4,'2024-03-22'),
  (8,1,4,1,'2024-04-10'),
  (9,5,6,2,'2024-04-18');


CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  product_name TEXT NOT NULL,
  price REAL NOT NULL,
  category TEXT NOT NULL
);
INSERT INTO products VALUES
  (1,'Wireless Mouse',29.99,'Electronics'),
  (2,'USB-C Hub',49.99,'Electronics'),
  (3,'Notebook',5.99,'Stationery'),
  (4,'Gel Pen Set',8.49,'Stationery'),
  (5,'Desk Lamp',34.99,'Furniture'),
  (6,'Whiteboard',59.99,'Furniture'),
  (7,'Coffee Mug',12.99,'Kitchen'),
  (8,'Water Bottle',18.99,'Kitchen'),
  (9,'Backpack',74.99,'Bags'),
  (10,'Tote Bag',22.99,'Bags'),
  (11,'Keyboard',89.99,'Electronics');

--1. List all orders with the customer's name and product name (3-table JOIN: orders + customers + products)
SELECT
	o.id AS order_id,
	c.name  AS customer_name,
    p.product_name,
	o.quantity,
	o.order_date
FROM   orders o
JOIN   customers   c ON o.customer_id = c.id
JOIN   products p ON o.product_id = p.id;

--2. Show only orders for Electronics products — include customer name, product name, and price
SELECT
	c.name  AS customer_name,
    p.product_name,
	p.price
FROM   orders o
JOIN   customers   c ON o.customer_id = c.id
JOIN   products p ON o.product_id = p.id
WHERE p.category = 'Electronics' ;
--Bob	 Wireless Mouse	  29.99
--Dan	 USB-C Hub	      49.99


--3. Find all customers and any orders they have placed — show NULL for customers with no orders
SELECT
    c.name AS customer_name,
    o.id AS order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id;

--4. Count how many orders each product has received (JOIN orders + products, GROUP BY product_name)
SELECT
	p.product_name,
	COUNT(o.id) AS total_orders
FROM products p
LEFT JOIN orders o ON p.id = o.product_id
GROUP by product_name
ORDER BY total_orders DESC;


--5. Find the customer who made the highest total purchase (SUM price × quantity, ORDER BY + LIMIT 1)
SELECT
  c.name AS customer,
  SUM(p.price * o.quantity) AS total_revenue
FROM   customers c
JOIN orders o ON c.id = o.customer_id
JOIN products p ON p.id = o.product_id
GROUP by c.id
ORDER BY total_revenue DESC
LIMIT 1;
-- Dan	 125.95
