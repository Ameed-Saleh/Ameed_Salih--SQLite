----🍕 Pizza  Restaurant  Database 🍕----
-- Class Exercise ✅
-- ⭐ Bonus 1 ✅
-- ⭐ Bonus 2 ✅

CREATE TABLE customers (
  id   INTEGER  PRIMARY KEY AUTOINCREMENT,
  name TEXT     NOT NULL,
  phone TEXT    NOT NULL
);
--------------------------------------------
CREATE TABLE orders (
  id      INTEGER  PRIMARY KEY AUTOINCREMENT,
  customer_id INTEGER NOT NULL,
  order_date   datetime NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(id) on DELETE RESTRICT
);
--------------------------------------------
CREATE TABLE pizzas(
  id      INTEGER  PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  base_price REAL NOT NULL
);
--------------------------------------------
CREATE TABLE toppings(
  id      INTEGER  PRIMARY KEY AUTOINCREMENT,
  name TEXT  NOT NULL,
  topping_price REAL NOT NULL
);
--------------------------------------------
CREATE TABLE drinks(
  id      INTEGER  PRIMARY KEY AUTOINCREMENT,
  name TEXT  NOT NULL,
  drink_price REAL NOT NULL
);
--------------------------------------------
CREATE TABLE order_pizzas(
  order_id INTEGER  NOT NULL,
  pizza_id  INTEGER  NOT NULL,
  pizza_qty  INTEGER DEFAULT 1,
  price_at_time REAL NOT NULL,
  PRIMARY KEY (order_id, pizza_id),
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (pizza_id)  REFERENCES pizzas(id)  ON DELETE RESTRICT
);
--------------------------------------------
CREATE TABLE pizza_toppings (
  pizza_id INTEGER  NOT NULL,
  topping_id  INTEGER  NOT NULL,
  PRIMARY KEY (pizza_id, topping_id),
  FOREIGN KEY (pizza_id) REFERENCES pizzas(id) ON DELETE CASCADE,
  FOREIGN KEY (topping_id)  REFERENCES toppings(id)  ON DELETE RESTRICT
);
--------------------------------------------
CREATE TABLE order_drinks(
  order_id INTEGER  NOT NULL,
  drink_id  INTEGER  NOT NULL,
  drink_qty  INTEGER DEFAULT 1,
  price_at_time REAL NOT NULL,
  PRIMARY KEY (order_id, drink_id),
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (drink_id)  REFERENCES drinks(id)  ON DELETE RESTRICT
);

--------------------------------------------------------------------
--------------------------------------------------------------------
INSERT INTO customers(name , phone)
VALUES ('Ameed Saleh ', '050-1234567') ,
	   ('Itamar Peretz', '052-7654321'),
	   ('Noah Cohen', '054-9876543');
--------------------------------------------
INSERT INTO orders(customer_id, order_date)
VALUES (1, '2026-05-29 19:30:00'),
	   (2, '2026-05-29 20:15:00'),
	   (3, '2026-05-29 21:00:00');
--------------------------------------------
INSERT INTO pizzas(name, base_price)
VALUES ('Margherita Pizza', 45.00),
       ('Pepperoni Pizza', 55.00),
	   ('Vegetarian Pizza', 50.00);
--------------------------------------------
INSERT INTO toppings(name, topping_price)
VALUES ('Olives', 2.00),
	   ('Corn', 2.50),
       ('Mushrooms', 3.00),
	   ('Pepperoni', 5.00),
	   ('Peppers', 4.00),
	   ('Extra Cheese', 7.00);
--------------------------------------------
INSERT INTO drinks(name, drink_price)
VALUES ('Coca-Cola', 9.00),
	   ('Coca-Cola Zero', 9.00),
	   ('Sprite', 9.00),
	   ('Sprite Zero', 9.00),
	   ('Fanta', 9.00);
--------------------------------------------
INSERT INTO order_pizzas(order_id, pizza_id, pizza_qty,  price_at_time)
VALUES (1, 1, 2, 12.99), (2, 2, 1, 15.55), (3, 3, 1, 10.75);
--------------------------------------------
INSERT INTO pizza_toppings(pizza_id, topping_id)
VALUES (1, 1), (2, 2), (2, 3);
--------------------------------------------
INSERT INTO order_drinks(order_id, drink_id, drink_qty,  price_at_time)
VALUES (1, 1, 1, 7.50), (2, 3, 2, 8.99), (3, 2, 1, 10.82);

""""""""""""""""""""""""""""""""""""""""""""""""""
-- WHY ON DELETE RESTRICT ?
--1. Customer to Orders (customers 1 -> N orders)
"Prevents deleting a customer if they have existing order, This ensures data integrity and prevents orders that lack a linked customer."

--2. Items to Orders (pizzas, toppings, drinks)
"Prevents deleting any pizza, topping or drink from the menu as long as they are linked to an active order. This preserves the accurate history of past transactions"


-- WHY ON DELETE CASCADE ?
-- I used on delete cascade on the three junction tables

--1. In Order Tables (order_pizzas & order_drinks)
"If an order is deleted from the main orders table theres no reason to keep its items, CASCADE automatically deletes the pizzas and drinks linked to that specific order"

--2. In Pizza Toppings (pizza_toppings)
"If a pizza is removed from the menu, CASCADE deletes the link between that pizza and its toppings, it doesn't delete the actual toppings from the main list it just cleans up the connection"

""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""
--customers
1 : N
--orders

--orders
N : M  ➞ junction TABLE -> order_pizzas
--pizzas

--pizzas
N : M  ➞ junction TABLE -> pizza_toppings
--toppings

--orders
N : M  ➞ junction TABLE -> order_drinks
--drinks
""""""""""""""""""""""""""""""""""""""