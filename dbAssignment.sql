--1. Create a departments table with the following constraints: 
--		dept_id (Primary Key, auto-increment). 
--		dept_name (Must be unique, cannot be NULL). 

CREATE TABLE departments(
	dept_id SERIAL PRIMARY KEY,
	dept_name VARCHAR(25) UNIQUE NOT NULL
	);	

--2. Create an employees table with constraints: 
--		emp_id (Primary Key, auto-increment). 
--		emp_name (Cannot be NULL). 
--		email (Must be unique). 
--		salary (Cannot be NULL, must be positive). 
--		dept_id (Foreign Key referencing departments.dept_id). 


CREATE TABLE employees(
	emp_id SERIAL PRIMARY KEY,
	emp_name VARCHAR(20) NOT NULL,
	email VARCHAR(30) UNIQUE,
	salary INTEGER NOT NULL CHECK (salary>0),
	dept_id INTEGER REFERENCES departments(dept_id)
	);

--3. Create a projects table: 
--		project_id (Primary Key, auto-increment). 
--		project_name (Cannot be NULL). 
--		dept_id (Foreign Key referencing departments.dept_id).

CREATE TABLE projects(
	project_id SERIAL PRIMARY KEY,
	project_name VARCHAR(20) NOT NULL,
	dept_id INTEGER REFERENCES departments(dept_id)
	);

--4.

--Insert Data in departments table:

INSERT INTO departments(dept_name) values ('HR');
INSERT INTO departments(dept_name) values ('Sales');
INSERT INTO departments(dept_name) values ('Finance');
INSERT INTO departments(dept_name) values ('Marketing');
INSERT INTO departments(dept_name) values ('Design');
INSERT INTO departments(dept_name) values ('Admininstration');
INSERT INTO departments(dept_name) values ('Quality Assurance');

SELECT * FROM departments;

--Insert Data in employees table:

INSERT INTO employees(emp_name,email,salary,dept_id) values ('Johnson','johnson@gmail.com',50000,2);
INSERT INTO employees(emp_name,email,salary,dept_id) values ('Dharani','dharani@gmail.com',45000,3);
INSERT INTO employees(emp_name,email,salary,dept_id) values ('Jack','jack@gmail.com',90000,3);
INSERT INTO employees(emp_name,email,salary,dept_id) values ('Ayisha','ayisha@gmail.com',35000,5);
INSERT INTO employees(emp_name,email,salary,dept_id) values ('David','david@gmail.com',38000,1);
INSERT INTO employees(emp_name,email,salary,dept_id) values ('Shalini','shalini@gmail.com',64000,2);
INSERT INTO employees(emp_name,email,salary,dept_id) values ('Charlin','charlin@gmail.com',58000,5);
INSERT INTO employees(emp_name,email,salary,dept_id) values ('Henry','henry@gmail.com',47000,4);
INSERT INTO employees(emp_name,email,salary,dept_id) values ('Janani','janani@gmail.com',60000,3);
INSERT INTO employees(emp_name,email,salary,dept_id) values ('Aswini','aswini@gmail.com',83000,1);

SELECT * FROM employees;

--Insert Data in projects table:

INSERT INTO projects(project_name,dept_id) values ('Project1',4);
INSERT INTO projects(project_name,dept_id) values ('Project2',1);
INSERT INTO projects(project_name,dept_id) values ('Project3',3);
INSERT INTO projects(project_name,dept_id) values ('Project4',4);
INSERT INTO projects(project_name,dept_id) values ('Project5',5);
INSERT INTO projects(project_name,dept_id) values ('Project6',2);
INSERT INTO projects(project_name,dept_id) values ('Project7',1);
INSERT INTO projects(project_name,dept_id) values ('Project8',6);

SELECT * FROM projects;

--5.INNER JOIN: List all employees along with their department names.

SELECT emp_id,emp_name,email,salary,dept_name FROM employees INNER JOIN departments ON employees.dept_id = departments.dept_id;

--6.LEFT JOIN: Show all departments and employees, including departments with no employees. 

SELECT emp_id,emp_name,email,salary,dept_name FROM employees LEFT JOIN departments ON employees.dept_id = departments.dept_id;

--7.RIGHT JOIN: Show all employees and their respective departments, including employees without a department. 

SELECT emp_id,emp_name,email,salary,dept_name FROM employees RIGHT JOIN departments ON employees.dept_id = departments.dept_id;

--8.FULL OUTER JOIN: List all departments and employees, even if there’s no match between them. 

SELECT emp_id,emp_name,email,salary,dept_name FROM employees FULL JOIN departments ON employees.dept_id = departments.dept_id;

--9.JOIN with multiple tables: List all employees along with their department name and the projects assigned to that department.

SELECT emp_id,emp_name,email,salary,dept_name,project_name FROM employees LEFT JOIN departments ON employees.dept_id=departments.dept_id INNER JOIN projects ON projects.dept_id=departments.dept_id;

--10.Count the total number of employees in each department. 

SELECT COUNT(emp_name),dept_name FROM employees INNER JOIN departments ON employees.dept_id = departments.dept_id group by dept_name;

--11.Find the total salary paid in each department.

SELECT SUM(salary),dept_name FROM employees INNER JOIN departments ON employees.dept_id = departments.dept_id group by dept_name;

--12.Calculate the average salary for each department. 

SELECT AVG(salary),dept_name FROM employees INNER JOIN departments ON employees.dept_id = departments.dept_id group by dept_name;

--13.Find the minimum and maximum salary in the company. 

SELECT MIN(salary) AS Minimum_Salary,MAX(salary)AS Maximum_Salary FROM employees;

--14.List the total number of projects each department is handling. 

SELECT COUNT(project_name),dept_name FROM projects INNER JOIN departments ON projects.dept_id = departments.dept_id group by dept_name;

--15.Show the average salary per department, but only for departments where the average salary is greater than 50,000. 

SELECT AVG(salary),dept_name FROM employees INNER JOIN departments ON employees.dept_id = departments.dept_id group by dept_name HAVING avg(salary)>50000;

--16.Find departments with more than 3 employees. 

SELECT COUNT(emp_name),dept_name FROM employees INNER JOIN departments ON employees.dept_id = departments.dept_id group by dept_name HAVING COUNT(emp_name)>3;

--17.List projects assigned to departments that have at least 2 projects. 

SELECT COUNT(project_name),dept_name FROM projects INNER JOIN departments ON projects.dept_id = departments.dept_id group by dept_name HAVING COUNT(project_name)>=2;

--18.Create a function to calculate bonuses
--		Write a PostgreSQL function that takes an employee’s salary as input and returns the bonus amount (10% of salary).
--		Test the function by selecting all employees and displaying their bonus. 

CREATE OR REPLACE FUNCTION calculate_bonus(emp_salary INTEGER) 
RETURNS INTEGER AS $$
BEGIN
	RETURN (emp_salary)*10/100;
END;
$$ LANGUAGE plpgsql;

SELECT emp_name,salary,calculate_bonus(salary) AS bonus FROM employees;

--19.Create a function to count employees in a department 
--		Write a function that takes a dept_id as input and returns the number of employees in that department. 
--		Test the function by calling it for different department IDs. 

CREATE OR REPLACE FUNCTION count_employees(department_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
	emp_count INTEGER;
BEGIN
	SELECT count(emp_name) INTO emp_count FROM employees where dept_id=department_id;
	RETURN emp_count;
END;
$$ LANGUAGE plpgsql;

SELECT dept_id,dept_name,count_employees(dept_id) FROM departments;

--20.Create a function to check high salaries 
--		Write a function that takes a salary as input and returns "High Salary" if it's above 80,000, "Medium Salary" if it's between 50,000-80,000, and "Low Salary" otherwise. 
--		Test the function by applying it to all employees. 

CREATE OR REPLACE FUNCTION check_salary(emp_salary INTEGER)
RETURNS TEXT AS $$
BEGIN
	IF emp_salary>80000 THEN
		RETURN 'High Salary';
	ELSIF emp_salary>50000 AND emp_salary<80000 THEN	
		RETURN 'Medium Salary';
	ELSE
		RETURN 'Low Salary';
	END IF;
END;
$$ LANGUAGE plpgsql;

SELECT emp_name, salary, check_salary(salary) FROM employees;