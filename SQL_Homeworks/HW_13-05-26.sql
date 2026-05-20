--06_relations / 05-normalization-2nf.html
--1. Identify which columns have partial dependencies and what they depend on.

-- The composite primary key is (order_id, product_id).
--qty: Depends on both the order and the product -> This is a full dependency (Valid for 2NF).
--customer_name: Depends only on order_id   -> Partial Dependency!
--product_name: Depends only on product_id  -> Partial Dependency!
--unit_price: Depends only on product_id    -> Partial Dependency!


--2. Design a 2NF-compliant schema: customers, products, orders, order_items.
-- the design on -> 2NF.pdf

--3. Write CREATE TABLE statements for all four tables.
CREATE TABLE customers (
  id  INTEGER  PRIMARY KEY AUTOINCREMENT,
  customer_name TEXT     NOT NULL
);

CREATE TABLE products (
  id   INTEGER  PRIMARY KEY,
  product_name TEXT     NOT NULL ,
  unit_price REAL NOT NULL
);

CREATE TABLE orders (
  id   INTEGER  PRIMARY KEY ,
  customer_id  INTEGER NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE order_items(
  product_id INTEGER  NOT NULL,
  order_id  INTEGER  NOT NULL,
  qty INTEGER NOT NULL CHECK (qty > 0),
  PRIMARY KEY (order_id , product_id),
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id)  REFERENCES products(id )
);


--4. Insert the data from the original table into your 2NF schema.

INSERT INTO customers (customer_name)
VALUES ('Alice'),
       ('Bob');

INSERT INTO products (id, product_name, unit_price)
VALUES (42, 'Keyboard', 49.99),
       (77, 'Mouse', 29.99);

INSERT INTO orders (id, customer_id)
VALUES (1001, 1),
	   (1002, 2);

INSERT INTO order_items (order_id, product_id, qty)
VALUES (1001, 42, 2),
	   (1001, 77, 1),
	   (1002, 42, 1);

--5. Write a query to reproduce the original table's data using JOINs.
SELECT
	O.id As order_id,
	p.id As product_id,
	oi.qty,
	c.customer_name,
	p.product_name,
	p.unit_price
FROM order_items oi
JOIN orders o on oi.order_id = o.id
JOIN customers c on o.customer_id = c.id
JOIN products p on oi.product_id = p.id
ORDER by o.id ASC;


--6. Bonus: rename "Keyboard" to "Mechanical Keyboard" — in the bad table vs the 2NF table. How many rows changed in each?
UPDATE products
SET product_name = 'Mechanical Keyboard'
WHERE id = 42;

--"In the 2NF Table we change the word "Mechanical Keyboard" one time,
--but in the original bad table we had to update two different lines (because the name is duplicated in every order)"



-- 06_relations / 06-normalization-3nf.html
--1. Check: is this table in 1NF? Explain why.
-- Yes, each cell contains a single, atomic value (no comma-separated lists or arrays), and all rows are unique.


--2. Check: is this table in 2NF? Explain why (single-column PK).
-- Yes, the primary key (isbn)is a single column, so it is not possible to partially depend columns in the key.


--3. Identify all transitive dependencies in the table.

-- Transitive Dependencies-
-- First dependency (author):
-- The key isbn determines the author_id and this determines the author_name.
-- Second dependency (publisher):
-- The isbn key determines publisher_id and it determines publisher_name and publisher_city.


--4. Design a 3NF schema with tables: books, authors, publishers.
-- the design on -> 3NF.pdf


--5. Write CREATE TABLE statements for all three tables with proper PKs and FKs.
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS publishers;
DROP TABLE IF EXISTS authors;

CREATE TABLE authors (
    author_id TEXT PRIMARY KEY,
    author_name TEXT NOT NULL
);

CREATE TABLE publishers (
    publisher_id TEXT PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    publisher_city TEXT NOT NULL
);

CREATE TABLE books (
    isbn TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    author_id TEXT NOT NULL,
    publisher_id TEXT NOT NULL,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);


--6. Insert the original data into the normalized tables.
INSERT INTO  authors ( author_id, author_name)
VALUES ('A1', 'Jane Doe'),
       ('A2', 'John Smith');

INSERT INTO publishers (publisher_id, publisher_name, publisher_city)
VALUES ('P1', 'TechPress', 'New York'),
       ('P2', 'DataBooks', 'Paris');

INSERT INTO books (isbn , title, author_id, publisher_id)
VALUES ('978-1', 'SQL Mastery','A1', 'P1'),
       ('978-2', 'Python Pro','A2', 'P1'),
       ('978-3', 'Data Viz','A1', 'P2');


--7. Write a query to reproduce all original columns using JOINs.
SELECT
	b.isbn,
	b.title,
	a.author_id,
	a.author_name,
	p.publisher_id,
	p.publisher_name,
	p.publisher_city
FROM books b
JOIN publishers p on b.publisher_id = p.publisher_id
JOIN authors a on b.author_id = a.author_id
ORDER by b.title DESC;


--8. Bonus: Change Jane Doe's name to "Jane Doe-Smith" — how many rows change in the 3NF vs original schema?

UPDATE authors
SET author_name = "Jane Doe-Smith"
WHERE author_name = "Jane Doe";

--In the 3NF scheme: only one row will change (in the authors table).
--but in the original bad table we had to update two different rows ((books 978-1 and 978-3).)"


