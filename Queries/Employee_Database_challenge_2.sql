-- Deliverable 1: The Number of Retiring Employees by Title

DROP TABLE employees CASCADE;
DROP TABLE departments CASCADE;
DROP TABLE dept_emp CASCADE;
DROP TABLE dept_manager CASCADE;
DROP TABLE salaries CASCADE;
DROP TABLE titles CASCADE;
DROP TABLE retirement_info CASCADE;

-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  FOREIGN KEY (emp_no) REFERENCES dept_emp (emp_no),	
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM dept_manager;

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM dept_emp;

CREATE TABLE titles (
	emp_no INT NOT NULL,
    title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (emp_no) REFERENCES salaries (emp_no),
    PRIMARY KEY (emp_no, title, from_date)
);

DROP TABLE retirement_info CASCADE;
-----------------------------------

--Step_1. Retrieve the emp_no, first_name, and last_name columns from the Employees table.
SELECT emp_no,first_name, last_name
FROM employees

--Step 2. Retrieve the title, from_date, and to_date columns from the Titles table.

SELECT title, from_date, to_date
FROM Titles


--Step_3. Create a new table using the INTO clause.

SELECT emp_no,first_name, last_name
INTO table_1
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')

DROP TABLE table_1 CASCADE;
---------
SELECT * FROM table_1;

SELECT emp_no,title, from_date, to_date
INTO retirement_titles_2
FROM Titles


DROP TABLE retirement_titles_2 CASCADE;
DROP TABLE retirement_titles CASCADE;
DROP TABLE retirement_info_2 CASCADE;

--Step_4. Join both tables on the primary key.
-- Joining departments and dept_manager tables

SELECT table_1.emp_no,
     table_1.first_name,
	 table_1.last_name,
     retirement_titles_2.title,
     retirement_titles_2.from_date,
     retirement_titles_2.to_date
INTO retirement_titles
FROM table_1
INNER JOIN retirement_titles_2
ON table_1.emp_no = retirement_titles_2.emp_no
ORDER BY table_1.emp_no ;

SELECT * FROM retirement_titles;

---Step_8

-- Use Dictinct with Orderby to remove duplicate rows
SELECT emp_no,first_name, last_name, title
FROM retirement_titles

SELECT DISTINCT ON (emp_no) emp_no,
first_name, 
last_name, 
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

SELECT * FROM unique_titles;

SELECT  COUNT(unique_titles.title)
FROM unique_titles
------------------------------------
---Step_15
SELECT  COUNT(unique_titles.title), 
unique_titles.title
INTO retiring_titles
FROM unique_titles
GROUP BY unique_titles.title
ORDER BY COUNT(unique_titles.title) DESC;

SELECT * FROM retiring_titles;

DROP TABLE retiring_titles CASCADE;

---Deliverable 2: The Employees Eligible for the Mentorship Program
--Mentorship Eligibility

--Step_1.Retrieve the emp_no, first_name, last_name, and birth_date columns from the Employees table.
SELECT emp_no,first_name, last_name, birth_date
FROM employees

--Step_2.Retrieve the from_date and to_date columns from the Department Employee table.
SELECT from_date, to_date
FROM dept_emp

--Step_3 Retrieve the title column from the Titles table.
SELECT title
FROM Titles

--Steps_4 Use a DISTINCT ON statement to retrieve the first occurrence of the employee number for each set of rows defined by the ON () clause.
-- Step_5 Create a new table using the INTO clause.
SELECT DISTINCT ON (emp_no) emp_no,
title
INTO unique_titles_2
FROM titles
ORDER BY emp_no;

SELECT * FROM unique_titles_2;

--Step_6 Join the Employees and the Department Employee tables on the primary key. / 
--Step_8 filter the data on the birth_date columns to get all the employees whose birth dates are between January 1, 1965 and December 31, 1965.

--Table_3 Creation: (emp_no, first_name, last_name)
SELECT emp_no,first_name, last_name, birth_date
INTO table_3
FROM employees
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')

DROP TABLE table_3 CASCADE;
SELECT * FROM table_3;

--Table_4 Creation: (from_date, to_date)
SELECT emp_no, from_date, to_date
INTO table_4
FROM dept_emp

SELECT * FROM table_4;
DROP TABLE table_4 CASCADE;

--Table 5 Creation: Join table_3 (emp_no, first_name, last_name) and table_4 (from_date, to_date)
SELECT table_3.emp_no,
     table_3.first_name,
	 table_3.last_name,
	 table_3.birth_date,
     table_4.from_date,
     table_4.to_date
INTO table_5
FROM table_3
INNER JOIN table_4
ON table_3.emp_no = table_4.emp_no
ORDER BY table_3.emp_no ;

SELECT * FROM table_5;
DROP TABLE table_4 CASCADE;

--Step_7 Join the Employees and the Titles tables on the primary key.
--Step_9 Order the table by the employee number.

SELECT table_5.emp_no,
     table_5.first_name,
	 table_5.last_name,
	 table_5.birth_date,
     table_5.from_date,
     table_5.to_date,
	 unique_titles_2.title
INTO mentorship_eligibilty
FROM table_5
INNER JOIN unique_titles_2
ON table_5.emp_no = unique_titles_2.emp_no
WHERE (to_date BETWEEN '9999-01-01' AND '9999-01-01')
ORDER BY table_5.emp_no ;

SELECT * FROM mentorship_eligibilty;
SELECT * FROM table_5;
SELECT * FROM unique_titles;
DROP TABLE mentorship_eligibilty CASCADE;
----------------------

