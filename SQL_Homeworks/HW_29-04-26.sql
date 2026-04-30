DROP TABLE sales;
CREATE TABLE sales (
  id        INTEGER PRIMARY KEY,
  rep_name  TEXT    NOT NULL,
  region    TEXT    NOT NULL,
  product   TEXT    NOT NULL,
  amount    REAL,
  sale_date TEXT    NOT NULL
);

INSERT INTO sales (id, rep_name, region, product, amount, sale_date) VALUES
  (1,  'Dana', 'North', 'Laptop', 1200.00, '2026-01-10'),
  (2,  'Omar', 'South', 'Phone',   650.00,  '2026-01-12'),
  (3,  'Dana', 'North', 'Tablet', NULL,     '2026-01-15'),
  (4,  'Noa',  'East',  'Laptop', 1350.00, '2026-01-18'),
  (5,  'Omar', 'South', 'Laptop', 1100.00, '2026-01-20'),
  (6,  'Dana', 'North', 'Phone',   720.00,  '2026-01-22'),
  (7,  'Noa',  'East',  'Phone',   690.00,  '2026-01-25'),
  (8,  'Liam', 'West',  'Tablet', 480.00,  '2026-01-28'),
  (9,  'Liam', 'West',  'Laptop', 1050.00, '2026-02-01'),
  (10, 'Omar', 'South', 'Tablet', NULL,     '2026-02-03');

-- Topic 5 — ALTER TABLE →
--1. Add a TEXT column called tier to the sales table, then fill it: 'high' where amount > 1000, 'low' otherwise
ALTER TABLE sales
ADD COLUMN tier TEXT;

UPDATE sales
SET    tier = 'high' WHERE amount > 1000;

UPDATE sales
SET   tier = 'low' WHERE amount <= 1000;

--2. Add a REAL column called tax with DEFAULT 0, then update it to amount * 0.07 where amount IS NOT NULL
ALTER TABLE sales
ADD COLUMN tax REAL DEFAULT 0;

UPDATE sales
SET    tax = amount * 0.07;

--3. Rename the sales table to sales_backup, then rename it back to sales
ALTER TABLE sales RENAME TO sales_backup;
-- rename it back
ALTER TABLE sales_backup RENAME TO sales;

--4. Rename the column product to item
ALTER TABLE sales
RENAME COLUMN product TO item;


--5. Drop the tier column you created in step 1, then run PRAGMA table_info(sales) to verify it is gone
ALTER TABLE sales
DROP COLUMN tier;

PRAGMA table_info(sales);
--0	id      	INTEGER
--1	rep_name	TEXT
--2	region	    TEXT
--3	item	    TEXT
--4	amount	    REAL
--5	sale_date	TEXT
--6	tax	        REAL


-- ⭐ BONUS ⭐ Topic 6 — Advanced & Mistakes →:
--1. Use COALESCE to show revenue per rep — replace any NULL total with 0
SELECT
  rep_name,
  COALESCE(SUM(amount), 0) AS revenue
FROM sales
GROUP BY rep_name;

--2. Show average amount per product, rounded to 2 decimal places, sorted highest first
SELECT
  product,
  ROUND(AVG(amount), 2) AS average_price
FROM sales
GROUP BY product
ORDER BY average_price DESC;

--3. For each rep show: total sales, count of Phone sales, count of sales above 1000
SELECT
  rep_name,
  SUM(amount) AS total_sales,
  COUNT(CASE WHEN product = 'Phone' THEN 1 END) AS phone_sales,
  COUNT(CASE WHEN amount > 1000 THEN 1 END) AS sales_above_1000
FROM sales
GROUP BY rep_name;

--4. Write the "Mistake 1" query (non-grouped column) — observe the result, then fix it
-- Wrong
-- 'product' not in GROUP BY
SELECT
  rep_name,
  product,
  SUM(amount) AS total_sales
FROM sales
GROUP BY rep_name;

-- Fixed ✓
-- add 'product' to GROUP BY
SELECT
  rep_name,
  product,
  SUM(amount) AS total_sales
FROM sales
GROUP BY rep_name, product;


--5. Build the full report from Query 4: COALESCE + ROUND + COUNT(CASE WHEN) + HAVING + ORDER BY alias
SELECT
  rep_name,
  COALESCE(SUM(amount), 0) AS revenue,
  ROUND(AVG(COALESCE(amount, 0)), 2) AS average_price,
  COUNT(CASE WHEN product = 'Phone' THEN 1 END) AS phone_sales,
  COUNT(CASE WHEN amount > 1000 THEN 1 END) AS sales_above_1000
FROM sales
GROUP BY rep_name
HAVING revenue > 1500
ORDER BY revenue DESC;



