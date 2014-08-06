-- create database
DROP DATABASE IF EXISTS user_article;
CREATE DATABASE user_article;
USE user_article;

-- create table users
DROP TABLE IF EXISTS users;

CREATE TABLE users
( id int AUTO_INCREMENT,
  name varchar(255),
  type ENUM('admin', 'normal'),
  PRIMARY KEY(id)
);

INSERT INTO users(name, type) VALUES('Paresh', 'admin');
INSERT INTO users(name, type) VALUES('Tanmay', 'normal');
INSERT INTO users(name, type) VALUES('Sawan', 'normal');
INSERT INTO users(name, type) VALUES('Nitin', 'admin');
INSERT INTO users(name, type) VALUES('Neha', 'normal');

+----+--------+--------+
| id | name   | type   |
+----+--------+--------+
|  1 | Paresh | admin  |
|  2 | Tanmay | normal |
|  3 | Sawan  | normal |
|  4 | Nitin  | admin  |
|  5 | Neha   | normal |
+----+--------+--------+

-- create table categories
DROP TABLE IF EXISTS categories;

CREATE TABLE categories
( id int AUTO_INCREMENT,
  name varchar(255),
  PRIMARY KEY(id)
);

INSERT INTO categories(name) VALUES('Life');
INSERT INTO categories(name) VALUES('Bollywood');
INSERT INTO categories(name) VALUES('Designing');
INSERT INTO categories(name) VALUES('Web Development');

+----+-----------------+
| id | name            |
+----+-----------------+
|  1 | Life            |
|  2 | Bollywood       |
|  3 | Designing       |
|  4 | Web Development |
+----+-----------------+

-- create table articles
DROP TABLE IF EXISTS articles;

CREATE TABLE articles
( id int AUTO_INCREMENT,
  user_id int,
  category_id int,
  title varchar(255),
  PRIMARY KEY(id ,title),
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(category_id) REFERENCES categories(id)
);

INSERT INTO articles(user_id, category_id, title) VALUES(2, 4, 'Ruby Singleton Class');
INSERT INTO articles(user_id, category_id, title) VALUES(1, 3, 'Automobile Designing');
INSERT INTO articles(user_id, category_id, title) VALUES(4, 2, 'Bollywood Now and Then');
INSERT INTO articles(user_id, category_id, title) VALUES(3, 4, 'MySql Transaction');
INSERT INTO articles(user_id, category_id, title) VALUES(5, 1, 'Professional Life');
INSERT INTO articles(user_id, category_id, title) VALUES(1, 1, 'Changes at a certain point in Life');

+----+---------+-------------+------------------------------------+
| id | user_id | category_id | title                              |
+----+---------+-------------+------------------------------------+
|  1 |       2 |           4 | Ruby Singleton Class               |
|  2 |       1 |           3 | Automobile Designing               |
|  3 |       4 |           2 | Bollywood Now and Then             |
|  4 |       3 |           4 | MySql Transaction                  |
|  5 |       5 |           1 | Professional Life                  |
|  6 |       1 |           1 | Changes at a certain point in Life |
+----+---------+-------------+------------------------------------+

-- create table comments
DROP TABLE IF EXISTS comments;

CREATE TABLE comments
( id int AUTO_INCREMENT,
  user_id int,
  article_id int,
  comment_text varchar(255),
  PRIMARY KEY(id),
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(article_id) REFERENCES articles(id)
);

INSERT INTO comments(user_id, article_id, comment_text) VALUES(1, 1, 'good article');
INSERT INTO comments(user_id, article_id, comment_text) VALUES(3, 1, 'very helpful');
INSERT INTO comments(user_id, article_id, comment_text) VALUES(2, 5, 'It depends from person to person');
INSERT INTO comments(user_id, article_id, comment_text) VALUES(1, 4, 'could not able to understand the acid model');
INSERT INTO comments(user_id, article_id, comment_text) VALUES(4, 2, 'great article');
INSERT INTO comments(user_id, article_id, comment_text) VALUES(2, 5, 'not a good one');
INSERT INTO comments(user_id, article_id, comment_text) VALUES(5, 6, 'everyone goes through that point in life');

+----+---------+------------+---------------------------------------------+
| id | user_id | article_id | comment_text                                |
+----+---------+------------+---------------------------------------------+
|  1 |       1 |          1 | good article                                |
|  2 |       3 |          1 | very helpful                                |
|  3 |       2 |          5 | It depends from person to person            |
|  4 |       1 |          4 | could not able to understand the acid model |
|  5 |       4 |          2 | great article                               |
|  6 |       2 |          5 | not a good one                              |
|  7 |       5 |          6 | everyone goes through that point in life    |
+----+---------+------------+---------------------------------------------+

-- select all articles whose author is user3(here it is Sawan)
SELECT users.name, articles.title AS article FROM articles
INNER JOIN users WHERE users.name IN(SELECT name FROM users WHERE id = 3)
AND articles.user_id = users.id;

+-------+-------------------+
| name  | article           |
+-------+-------------------+
| Sawan | MySql Transaction |
+-------+-------------------+

-- select all articles whose author is user3(using variable)
SET @user_id = 3;
SELECT users.name, articles.title AS article FROM articles
INNER JOIN users WHERE users.id = @user_id
AND articles.user_id = users.id;

+-------+-------------------+
| name  | article           |
+-------+-------------------+
| Sawan | MySql Transaction |
+-------+-------------------+

-- For all the articles being selected above, select all the articles and also the comments associated with those articles in a single query
SELECT articles.title AS article, comments.comment_text AS comment FROM comments
INNER JOIN articles WHERE articles.title 
IN(SELECT title FROM articles WHERE user_id = 3)
AND comments.article_id = articles.id;

+-------------------+---------------------------------------------+
| article           | comment                                     |
+-------------------+---------------------------------------------+
| MySql Transaction | could not able to understand the acid model |
+-------------------+---------------------------------------------+

-- select all articles which do not have any comments
SELECT articles.title AS 'article with no comments' FROM articles
LEFT JOIN comments ON articles.id = comments.article_id
WHERE comments.article_id IS NULL;

+--------------------------+
| article with no comments |
+--------------------------+
| Bollywood Now and Then   |
+--------------------------+

-- query to select article which has maximum comments
SELECT articles.title AS 'article with maximum comments', COUNT(comments.article_id) AS 'no. of comments' FROM articles
INNER JOIN comments ON articles.id = comments.article_id
GROUP BY articles.title DESC LIMIT 1;

+-------------------------------+-----------------+
| article with maximum comments | no. of comments |
+-------------------------------+-----------------+
| Ruby Singleton Class          |               2 |
+-------------------------------+-----------------+

-- query to select article which does not have more than one comment by the same user (using left join and group by)
SELECT articles.title AS 'article (having not more than one comment from same user)' FROM articles
LEFT JOIN comments ON articles.id = comments.article_id
GROUP BY articles.title
HAVING COUNT(comments.user_id) = COUNT(DISTINCT comments.user_id);

+-----------------------------------------------------------+
| article (having not more than one comment from same user) |
+-----------------------------------------------------------+
| Automobile Designing                                      |
| Bollywood Now and Then                                    |
| Changes at a certain point in Life                        |
| MySql Transaction                                         |
| Ruby Singleton Class                                      |
+-----------------------------------------------------------+
