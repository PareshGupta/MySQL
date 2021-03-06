DROP DATABASE IF EXISTS customer_order;
CREATE DATABASE customer_order;
USE customer_order;

DROP TABLE IF EXISTS salespersons;
CREATE TABLE salespersons
( id int AUTO_INCREMENT,
  name varchar(255),
  age int,
  salary int,
  PRIMARY KEY(id)
);

INSERT INTO salespersons VALUES(1, 'Abe', 61, 140000);
INSERT INTO salespersons VALUES(2, 'Bob', 34, 44000);
INSERT INTO salespersons VALUES(3, 'Chris', 34, 40000);
INSERT INTO salespersons VALUES(4, 'Dan', 41, 52000);
INSERT INTO salespersons VALUES(5, 'Ken', 57, 115000);
INSERT INTO salespersons VALUES(6, 'Joe', 38, 38000);

+----+-------+------+--------+
| id | name  | age  | salary |
+----+-------+------+--------+
|  1 | Abe   |   61 | 140000 |
|  2 | Bob   |   34 |  44000 |
|  3 | Chris |   34 |  40000 |
|  4 | Dan   |   41 |  52000 |
|  5 | Ken   |   57 | 115000 |
|  6 | Joe   |   38 |  38000 |
+----+-------+------+--------+

DROP TABLE IF EXISTS customers;
CREATE TABLE customers
( id int AUTO_INCREMENT,
  name varchar(255),
  city varchar(255),
  industry_type char(1),
  PRIMARY KEY(id)
);

INSERT INTO customers VALUES(1, 'Samsonic', 'Pleasant', 'J');
INSERT INTO customers VALUES(2, 'Panasung', 'Oaktown', 'J');
INSERT INTO customers VALUES(3, 'Samony', 'Jackson', 'B');
INSERT INTO customers VALUES(4, 'Orange', 'Jackson', 'B');

+----+----------+----------+---------------+
| id | name     | city     | industry_type |
+----+----------+----------+---------------+
|  1 | Samsonic | Pleasant | J             |
|  2 | Panasung | Oaktown  | J             |
|  3 | Samony   | Jackson  | B             |
|  4 | Orange   | Jackson  | B             |
+----+----------+----------+---------------+

DROP TABLE IF EXISTS orders;
CREATE TABLE orders
( id int AUTO_INCREMENT,
  order_date date,
  customer_id int,
  salesperson_id int,
  amount int,
  PRIMARY KEY(id),
  FOREIGN KEY(customer_id) REFERENCES customers(id),
  FOREIGN KEY(salesperson_id) REFERENCES salespersons(id)
);

INSERT INTO orders VALUES(1, '2013-01-08', 1, 2, 540);
INSERT INTO orders VALUES(2, '2013-01-13', 1, 5, 1800);
INSERT INTO orders VALUES(3, '2013-01-17', 4, 1, 460);
INSERT INTO orders VALUES(4, '2013-02-02', 3, 2, 2400);
INSERT INTO orders VALUES(5, '2013-02-03', 2, 4, 600);
INSERT INTO orders VALUES(6, '2013-02-03', 2, 4, 720);
INSERT INTO orders VALUES(7, '2013-03-05', 4, 4, 150);

+----+------------+-------------+----------------+--------+
| id | order_date | customer_id | salesperson_id | amount |
+----+------------+-------------+----------------+--------+
|  1 | 2013-01-08 |           1 |              2 |    540 |
|  2 | 2013-01-13 |           1 |              5 |   1800 |
|  3 | 2013-01-17 |           4 |              1 |    460 |
|  4 | 2013-02-02 |           3 |              2 |   2400 |
|  5 | 2013-02-03 |           2 |              4 |    600 |
|  6 | 2013-02-03 |           2 |              4 |    720 |
|  7 | 2013-03-05 |           4 |              4 |    150 |
+----+------------+-------------+----------------+--------+

--details of all salespeople that have an order with Samsonic
SELECT salespersons.* FROM salespersons
INNER JOIN orders ON orders.salesperson_id = salespersons.id
INNER JOIN customers ON orders.customer_id = customers.id
WHERE customers.name = 'Samsonic'
GROUP BY orders.salesperson_id;

+----+------+------+--------+
| id | name | age  | salary |
+----+------+------+--------+
|  2 | Bob  |   34 |  44000 |
|  5 | Ken  |   57 | 115000 |
+----+------+------+--------+

-- names of salespeople that have 2 or more orders
SELECT salespersons.name FROM salespersons
INNER JOIN orders ON orders.salesperson_id = salespersons.id
INNER JOIN customers ON orders.customer_id = customers.id
GROUP BY orders.salesperson_id
HAVING COUNT(orders.customer_id) >= 2;

+------+
| name |
+------+
| Bob  |
| Dan  |
+------+

-- names of the salespeople whose order has the maximum amount as of now(using joins)
SELECT GROUP_CONCAT(salespersons.name) AS 'person having maximum amount order' FROM salespersons
INNER JOIN orders ON orders.salesperson_id = salespersons.id
GROUP BY orders.amount DESC LIMIT 1;

+------------------------------------+
| person having maximum amount order |
+------------------------------------+
| Bob                                |
+------------------------------------+

--find the industry type all salespeople have got order from in a single column
SELECT salespersons.name, GROUP_CONCAT(DISTINCT customers.industry_type) AS industry_type from salespersons
INNER JOIN orders ON orders.salesperson_id = salespersons.id
INNER JOIN customers ON orders.customer_id = customers.id
GROUP BY salespersons.id;

+------+---------------+
| name | industry_type |
+------+---------------+
| Abe  | B             |
| Bob  | J,B           |
| Dan  | J,B           |
| Ken  | J             |
+------+---------------+

-- get total amount of money salespeople have got orders for
SELECT salespersons.name, SUM(orders.amount) AS maximum_amount_for_order FROM salespersons
INNER JOIN  orders ON orders.salesperson_id = salespersons.id
GROUP BY salespersons.id;

+------+--------------------------+
| name | maximum_amount_for_order |
+------+--------------------------+
| Abe  |                      460 |
| Bob  |                     2940 |
| Dan  |                     1470 |
| Ken  |                     1800 |
+------+--------------------------+

-- get total amount of all the orders got to the salespeople
SELECT SUM(amount) as 'total amount for the orders' FROM orders;

+-----------------------------+
| total amount for the orders |
+-----------------------------+
|                        6670 |
+-----------------------------+

-- get total amount of money for the orders customer got
SELECT customers.name, SUM(orders.amount) AS maximum_amount_for_order FROM customers
INNER JOIN orders ON orders.customer_id = customers.id
GROUP BY customers.id;

+----------+--------------------------+
| name     | maximum_amount_for_order |
+----------+--------------------------+
| Samsonic |                     2340 |
| Panasung |                     1320 |
| Samony   |                     2400 |
| Orange   |                      610 |
+----------+--------------------------+

-- names of salespeople that have not got any order for last 15 days, also show details of their last orders
SET @current_date = '2013-03-06';
SELECT salespersons.name, orders.order_date, orders.amount FROM salespersons
INNER JOIN orders ON orders.salesperson_id = salespersons.id
GROUP BY salespersons.id
HAVING orders.order_date < DATE_SUB(@current_date, INTERVAL 15 DAY);

+------+------------+--------+
| name | order_date | amount |
+------+------------+--------+
| Abe  | 2013-01-17 |    460 |
| Bob  | 2013-01-08 |    540 |
| Dan  | 2013-02-03 |    600 |
| Ken  | 2013-01-13 |   1800 |
+------+------------+--------+

