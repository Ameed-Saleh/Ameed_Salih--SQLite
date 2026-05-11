--Topic 3 - One-to-Many (1:N) exercise →
--1. Create a categories table: id PK AUTOINCREMENT, title TEXT UNIQUE NOT NULL.
CREATE TABLE categories (
  id   INTEGER  PRIMARY KEY AUTOINCREMENT,
  title TEXT UNIQUE NOT NULL
);


--2. Create a posts table: id PK AUTOINCREMENT, category_id FK (NOT NULL), title TEXT, views INTEGER DEFAULT 0. Use ON DELETE RESTRICT.
CREATE TABLE posts (
  id      INTEGER  PRIMARY KEY AUTOINCREMENT,
  category_id  INTEGER  NOT NULL,          -- FK, no UNIQUE
  title    TEXT,
  views  INTEGER     DEFAULT 0,
  FOREIGN KEY (category_id ) REFERENCES categories (id)
    ON DELETE RESTRICT   -- prevent deleting dept with employees
);


--3. Insert 3 categories and at least 5 posts spread across the categories.
INSERT INTO categories (title)
VALUES ('Engineering'), ('Lifestyle'), ('Education');

INSERT INTO posts (category_id , title , views)
VALUES
	(1, 'The Rise of AI', 150),
	(2, 'Top 10 Travel Tips', 85),
	(3, 'Learning SQL Fast', 300),
	(1, 'New Smartphone Review', 45),
	(2, 'Morning Routine Hacks', 120),
	(1, 'Future of Quantum Computing', 210),
	(3, 'Mastering Python in 30 Days', 540),
	(2, 'Best Hiking Trails in Europe', 95),
	(3, 'Why History Matters', 110),
	(1, 'Is Your Data Really Safe?', 320);


--4. Query: list all posts with their category title using INNER JOIN.
SELECT
	p.category_id,
	p.title,
	p.views,
	c.title AS category
FROM categories c
INNER JOIN  posts p ON p.category_id = c.id
ORDER by p.category_id ASC;


--5. Query: count posts per category, show categories with 0 posts too (use LEFT JOIN + GROUP BY).
SELECT
  c.title                    AS category,
  COUNT(p.id)                AS post_count
FROM categories c
LEFT JOIN  posts p ON p.category_id = c.id
GROUP BY c.id;


--6. Query: find the category with the highest total views using GROUP BY + ORDER BY + LIMIT 1.
SELECT
  c.title                    AS category,
  sum(p.views) AS total_views
FROM categories c
JOIN  posts p ON p.category_id = c.id
GROUP BY c.id
ORDER BY total_views DESC
LIMIT 1;



--Topic 4 - Many-to-Many (N:M) exercise →
--1. Create orders: id PK AUTOINCREMENT, order_no TEXT UNIQUE, address TEXT NOT NULL, phone TEXT NOT NULL, ordered_at TEXT DEFAULT (date('now')).
CREATE TABLE orders (
  id   INTEGER  PRIMARY KEY AUTOINCREMENT,
  order_no TEXT UNIQUE,
  address TEXT NOT NULL,
  phone TEXT NOT NULL,
  ordered_at TEXT DEFAULT (date('now'))
);


--2. Create products: id PK AUTOINCREMENT, name TEXT NOT NULL, unit_price REAL NOT NULL.
CREATE TABLE products (
  id      INTEGER  PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  unit_price REAL NOT NULL
);


--3. Create sales (junction): order_id FK, product_id FK, qty INTEGER NOT NULL DEFAULT 1, with composite PK (order_id, product_id). (Each row means one product sold in one order.)
CREATE TABLE sales (
  order_id    INTEGER  NOT NULL,
  product_id  INTEGER  NOT NULL,
  qty INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (order_id , product_id),
  FOREIGN KEY (order_id) REFERENCES orders(id) ,
  FOREIGN KEY (product_id)  REFERENCES products(id)
);


--4. Insert sample data
INSERT INTO orders (id, order_no, address, phone, ordered_at)
VALUES
          (1, 'ORD-1001', '12 Lake St, Boston',  '+1-555-0101', '2026-01-05'),
          (2, 'ORD-1002', '12 Lake St, Boston',  '+1-555-0101', '2026-01-07'),
          (3, 'ORD-1003', '88 Pine Ave, Seattle', '+1-555-0202', '2026-01-09'),
          (4, 'ORD-1004', '44 Nile Rd, Cairo',    '+1-555-0303', '2026-01-10'),
          (5, 'ORD-1005', '77 Hill Rd, Austin',   '+1-555-0404', '2026-01-11'); -- no sales rows

INSERT INTO products (id, name, unit_price)
VALUES
  (1, 'Laptop', 1200),
  (2, 'Mouse', 25),
  (3, 'Keyboard', 80),
  (4, 'Webcam', 95),
  (5, 'Monitor', 280),
  (6, 'Desk Lamp', 35),
  (7, 'USB Hub', 40);

INSERT INTO sales (order_id, product_id, qty)
VALUES
  (1, 1, 1),
  (1, 2, 2),
  (1, 3, 1),
  (2, 4, 1),
  (2, 7, 2),
  (3, 5, 1),
  (3, 6, 3),
  (4, 2, 1),
  (4, 7, 1);


--5. Write a query to show each sold product with order_no, address, phone, product_name, qty, unit_price, and line total (qty * unit_price).
SELECT
	o.order_no,
	o.address,
	o.phone,
	p.name AS product_name,
	s.qty,
	p.unit_price,
	(s.qty * p.unit_price) AS line_total
FROM orders o
JOIN sales s ON o.id = s.order_id
JOIN products p ON p.id = s.product_id ;


--6. Write a query to list each order with total item count (SUM(qty)) and total price (SUM(qty * unit_price)).
SELECT
	o.order_no,
	SUM(s.qty) AS total_items ,
	SUM(s.qty * p.unit_price) AS total_price
FROM orders o
JOIN sales s ON o.id = s.order_id
JOIN products p ON p.id = s.product_id
GROUP BY o.id, o.order_no;

--7. Write a query to list each order with all product names in that order.
SELECT
	o.order_no,
	p.name AS product_name
FROM orders o
JOIN sales s ON o.id = s.order_id
JOIN products p ON p.id = s.product_id
ORDER BY o.order_no;

--8. Write a query to calculate each phone (or address) and the sum of all orders.
SELECT
	o.address,
	o.phone,
	sum(s.qty * p.unit_price) AS all_orders
FROM orders o
JOIN sales s ON o.id = s.order_id
JOIN products p ON p.id = s.product_id
GROUP BY o.address, o.phone;

--9. Write a query to show orders that have no products in sales.
SELECT
    o.id,
    o.order_no,
    o.address,
	p.name
FROM orders o
LEFT JOIN sales s ON o.id = s.order_id
LEFT JOIN products p ON p.id = s.product_id
WHERE s.order_id IS NULL;