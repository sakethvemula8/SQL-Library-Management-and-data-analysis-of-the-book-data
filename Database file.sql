--Library Management System P2

--Creating Branch Table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
	branch_id VARCHAR(10) PRIMARY KEY,
	manager_id VARCHAR(10),
	branch_address VARCHAR(15),
	contact_no VARCHAR(20)
	);
	ALTER TABLE branch
	ALTER COLUMN contact_no  TYPE VARCHAR(20);

DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
emp_id VARCHAR(10) PRIMARY KEY,
emp_name VARCHAR(20),
position VARCHAR(15),
salary INT,
branch_id VARCHAR(10)
);
ALTER TABLE employees
ALTER COLUMN salary TYPE FLOAT;

DROP TABLE IF EXISTS books;
CREATE TABLE books
(
isbn VARCHAR(17) PRIMARY KEY,
book_title VARCHAR(65),
category VARCHAR(20),
rental_price FLOAT,
status VARCHAR(10),
author VARCHAR(50),
publisher VARCHAR(50)

);


DROP TABLE IF EXISTS members;
CREATE TABLE members
(
member_id VARCHAR(10) PRIMARY KEY,
member_name VARCHAR(25),
member_address VARCHAR(75),
reg_date DATE
);

DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
issued_id VARCHAR(20) PRIMARY KEY,
issued_member_id VARCHAR(20),  
issued_book_name VARCHAR(80),
issued_date DATE,
issued_book_isbn VARCHAR(75), 
issued_emp_id VARCHAR(20)  

);


DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
return_id VARCHAR(20) PRIMARY KEY,
issued_id VARCHAR(20),
return_book_name VARCHAR(75),
return_date DATE,
return_book_isbn VARCHAR(20)

);

--Foreign key 

ALTER TABLE issued_status 
ADD CONSTRAINT fk_members 
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_book
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id )
REFERENCES branch(branch_id);


ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

ALTER TABLE return_status DROP CONSTRAINT fk_book; 


--Checking if the data is imported properly.
SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM members;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;

--Project task and business problems

--CRUD OPERATIONS 
--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
--Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
SELECT * FROM members;
--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued_status
WHERE issued_id = 'IS121'
--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * FROM employees 
WHERE emp_id = 'E101';
--Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT
    issued_emp_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1
--CTAS
--ask 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
SELECT * FROM book_issued_cnt;

--DATA ANALYSIS 
--Task 7. Retrieve All Books in a Specific Category:
SELECT * FROM books
WHERE category = 'Classic'

SELECT * FROM books
WHERE category = 'History'

--Task 8: Find Total Rental Income by Category:
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1
--Task 9:List Members Who Registered in the Last 180 Days:
INSERT INTO members(member_id,member_name,member_address,reg_date)
VALUES 
('C190', 'JO', '158 Main St', '2025-02-15');
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
--Task 10:List Employees with Their Branch Manager's Name and their branch details:
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id
--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE TABLE books_with_rental_price_above_7 AS
SELECT *FROM books
WHERE rental_price>7;
SELECT * FROM books_with_rental_price_above_7
--Task 12: Retrieve the List of Books Not Yet Returned
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

