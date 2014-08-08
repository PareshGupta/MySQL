-- create database bank
DROP DATABASE IF EXISTS bank;
CREATE DATABASE bank;
USE bank;

-- create table accounts
DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts
( id int AUTO_INCREMENT,
  account_no bigint,
  balance float,
  PRIMARY KEY(id, account_no)
);

INSERT INTO accounts VALUES(1, 119900480901, 25000);
INSERT INTO accounts VALUES(2, 119900480912, 15000);
INSERT INTO accounts VALUES(3, 119900480911, 15700);
INSERT INTO accounts VALUES(4, 119900480931, 10000);
INSERT INTO accounts VALUES(5, 119900480903, 50000);

+----+--------------+---------+
| id | account_no   | balance |
+----+--------------+---------+
|  1 | 119900480901 |   25000 |
|  2 | 119900480912 |   15000 |
|  3 | 119900480911 |   15700 |
|  4 | 119900480931 |   10000 |
|  5 | 119900480903 |   50000 |
+----+--------------+---------+

-- create table users
DROP TABLE IF EXISTS users;

CREATE TABLE users
( id int AUTO_INCREMENT,
  name varchar(255),
  email varchar(255),
  account_id int,
  PRIMARY KEY(id),
  FOREIGN KEY(account_id) REFERENCES accounts(id)
);

INSERT INTO users VALUES(1, 'Paresh', 'paresh@vinsol.com', 1);
INSERT INTO users VALUES(2, 'Ankur', 'ankur@vinsol.com', 2);
INSERT INTO users VALUES(3, 'Bipin', 'bipin@vinsol.com', 3);
INSERT INTO users VALUES(4, 'Tanny', 'tanny@vinsol.com', 4);
INSERT INTO users VALUES(5, 'Deva', 'deva@vinsol.com', 5);

+----+--------+-------------------+---------------+
| id | name   | email             | account_id    |
+----+--------+-------------------+---------------+
|  1 | Paresh | paresh@vinsol.com |             1 |
|  2 | Ankur  | ankur@vinsol.com  |             2 |
|  3 | Bipin  | bipin@vinsol.com  |             3 |
|  4 | Tanny  | tanny@vinsol.com  |             4 |
|  5 | Deva   | deva@vinsol.com   |             5 |
+----+--------+-------------------+---------------+

-- userA is depositing Rs 1000/- his account
BEGIN;
SET autocommit = 0;
UPDATE accounts INNER JOIN users ON accounts.id = users.account_id
SET accounts.balance = accounts.balance + 1000
WHERE users.name = 'Paresh';
COMMIT;

+----+--------------+---------+
| id | account_no   | balance |
+----+--------------+---------+
|  1 | 119900480901 |   26000 |
|  2 | 119900480912 |   15000 |
|  3 | 119900480911 |   15700 |
|  4 | 119900480931 |   10000 |
|  5 | 119900480903 |   50000 |
+----+--------------+---------+

-- userA is withdrawing Rs 500/-
BEGIN;
SET autocommit = 0;
UPDATE accounts INNER JOIN users ON accounts.id = users.account_id
SET accounts.balance = accounts.balance - 500
WHERE users.name = 'Tanny';
COMMIT;

+----+--------------+---------+
| id | account_no   | balance |
+----+--------------+---------+
|  1 | 119900480901 |   26000 |
|  2 | 119900480912 |   15000 |
|  3 | 119900480911 |   15700 |
|  4 | 119900480931 |    9500 |
|  5 | 119900480903 |   50000 |
+----+--------------+---------+

-- userA is transferring Rs 200/- to userB's account
BEGIN;
SET autocommit = 0;
UPDATE accounts INNER JOIN users
ON accounts.id = users.account_id 
SET accounts.balance = accounts.balance - 200
WHERE users.name = 'Bipin';

UPDATE accounts INNER JOIN users
ON accounts.id = users.account_id
SET accounts.balance = accounts.balance + 200
WHERE users.name = 'Deva';
COMMIT;

+----+--------------+---------+
| id | account_no   | balance |
+----+--------------+---------+
|  1 | 119900480901 |   26000 |
|  2 | 119900480912 |   15000 |
|  3 | 119900480911 |   15500 |
|  4 | 119900480931 |    9500 |
|  5 | 119900480903 |   50200 |
+----+--------------+---------+
