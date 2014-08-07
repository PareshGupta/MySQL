DROP DATABASE IF EXISTS employee_commission;

CREATE DATABASE employee_commission;
USE employee_commission;

DROP TABLE IF EXISTS departments;
CREATE TABLE departments
( id int AUTO_INCREMENT,
  name varchar(255),
  PRIMARY KEY(id)
);

INSERT INTO departments(name) VALUES('Banking');
INSERT INTO departments(name) VALUES('Insurance');
INSERT INTO departments(name) VALUES('Services');

DROP TABLE IF EXISTS employees;
CREATE TABLE employees
( id int AUTO_INCREMENT,
  department_id int,
  name varchar(255),
  salary int,
  PRIMARY KEY(id),
  FOREIGN KEY(department_id) REFERENCES departments(id)
);

INSERT INTO employees(department_id, name, salary) VALUES(1, 'Chris Gayle', 1000000);
INSERT INTO employees(department_id, name, salary) VALUES(2, 'Michael Clarke', 800000);
INSERT INTO employees(department_id, name, salary) VALUES(1, 'Rahul Dravid', 700000);
INSERT INTO employees(department_id, name, salary) VALUES(2, 'Ricky Ponting', 600000);
INSERT INTO employees(department_id, name, salary) VALUES(2, 'Albie Morkel', 650000);
INSERT INTO employees(department_id, name, salary) VALUES(3, 'Wasim Akram', 750000);

DROP TABLE IF EXISTS commissions;
CREATE TABLE commissions
( id int AUTO_INCREMENT,
  employee_id int,
  amount int,
  PRIMARY KEY(id),
  FOREIGN KEY(employee_id) REFERENCES employees(id)
);

INSERT INTO commissions(employee_id, amount) VALUES(1, 5000);
INSERT INTO commissions(employee_id, amount) VALUES(2, 3000);
INSERT INTO commissions(employee_id, amount) VALUES(3, 4000);
INSERT INTO commissions(employee_id, amount) VALUES(1, 4000);
INSERT INTO commissions(employee_id, amount) VALUES(2, 3000);
INSERT INTO commissions(employee_id, amount) VALUES(4, 2000);
INSERT INTO commissions(employee_id, amount) VALUES(5, 1000);
INSERT INTO commissions(employee_id, amount) VALUES(6, 5000);

--Find the employee who gets the highest total commission
SELECT employees.name, SUM(amount) AS total_amount FROM commissions
INNER JOIN employees WHERE commissions.employee_id = employees.id
GROUP BY employees.id ORDER BY total_amount DESC LIMIT 1;
+-------------+--------------+
| name        | total_amount |
+-------------+--------------+
| Chris Gayle |         9000 |
+-------------+--------------+

--Find employee with 4th Highest salary from employee table
SELECT name, salary FROM employees ORDER BY salary DESC LIMIT 1 OFFSET 3;
+--------------+--------+
| name         | salary |
+--------------+--------+
| Rahul Dravid | 700000 |
+--------------+--------+

--Find department that is giving highest commission
--select departments.name, employees.id from departments inner join employees where departments.id = employees.department_id group by  employees.id

--Find employees getting commission more than 3000
SELECT GROUP_CONCAT(employees.name), commissions.amount 
FROM employees INNER JOIN commissions 
WHERE employees.id = commissions.employee_id 
AND amount > 3000 GROUP BY amount;
+------------------------------+--------+
| GROUP_CONCAT(employees.name) | amount |
+------------------------------+--------+
| Chris Gayle,Rahul Dravid     |   4000 |
| Chris Gayle,Wasim Akram      |   5000 |
+------------------------------+--------+
