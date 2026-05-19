from db import run_query_select, run_update_query
RED = "\033[1;31m"
PURPLE = "\033[1;35m"
CYAN = "\033[0;36m"
RESET = "\033[0;0m"

run_update_query("""DROP TABLE IF EXISTS authors;""")
run_update_query("""DROP TABLE IF EXISTS books;""")

run_update_query("""CREATE TABLE IF NOT EXISTS authors (
    id INTEGER PRIMARY  KEY,
    name TEXT    NOT NULL,
    country   REAL    NOT NULL)""")

run_update_query("""CREATE TABLE IF NOT EXISTS books  (
    id         INTEGER PRIMARY KEY,
    title       TEXT    NOT NULL,  
    author_id    INTEGER ,
    year     INTEGER   NOT NULL,
    FOREIGN KEY (author_id) REFERENCES authors(id))""")

run_update_query("PRAGMA foreign_keys = ON;")

run_update_query("INSERT INTO authors (id, name, country) VALUES (?, ?, ?)", (1, 'George Orwell',  'UK'))
run_update_query("INSERT INTO authors (id, name, country) VALUES (?, ?, ?)", (2, 'Gabriel García Márquez', 'Colombia'))
run_update_query("INSERT INTO authors (id, name, country) VALUES (?, ?, ?)", (3, 'Haruki Murakami',        'Japan'))

run_update_query("INSERT INTO books (id, title, author_id, year) VALUES (?, ?, ?, ?)", (1, '1984',                          1, 1949))
run_update_query("INSERT INTO books (id, title, author_id, year) VALUES (?, ?, ?, ?)", (2, 'Animal Farm',                   1, 1945))
run_update_query("INSERT INTO books (id, title, author_id, year) VALUES (?, ?, ?, ?)", (3, 'One Hundred Years of Solitude', 2, 1967))
run_update_query("INSERT INTO books (id, title, author_id, year) VALUES (?, ?, ?, ?)", (4, 'Norwegian Wood',                3, 1987))


# Query 1 — SELECT all books
print()
books = run_query_select("SELECT * FROM books")
for b in books:
    print(f"{PURPLE}Query 1 ={RESET} {CYAN}{b}{RESET}")


# Query 2 — Books after 1960
print()
books = run_query_select("SELECT * FROM books WHERE year > 1960;")
for y in books:
    print(f"{PURPLE}Query 2 = {RESET} {CYAN}{y}{RESET}")

# Query 3 — INNER JOIN books + authors
print()
answer = run_query_select("SELECT b.title, a.name FROM books b INNER JOIN authors a ON b.author_id = a.id;")
for c in answer:
    print(f"{PURPLE}Query 3 ={RESET} {CYAN}{c}{RESET}")


# Query 4 — Add a book from user input
print()
title    =     input(f"{PURPLE}Enter book title? {RESET} ")
author_id =     input(f"{PURPLE}Enter author ID? {RESET}")
year  =     input(f"{PURPLE}Enter publication year? {RESET}")

try:
    run_update_query(
        "INSERT INTO books VALUES (?, ?, ?)",
        (title, author_id, year)
    )
    print("book added successfully!")
except Exception as e:
    print(f"{RED}Failed to insert:{RESET}", e)