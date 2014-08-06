-- create database
DROP DATABASE IF EXISTS Multibranch_Library;

CREATE DATABASE Multibranch_Library;

USE Multibranch_Library;

-- create branch table
DROP TABLE IF EXISTS Branch;

CREATE TABLE Branch
( BCode char(2),
  Librarian  varchar(255),
  Address varchar(255),
  PRIMARY KEY(BCode)
);

-- insert data to branch table
INSERT INTO Branch(BCode, Librarian, Address) VALUES('B1', 'John Smith', '2 Anglesea Rd');
INSERT INTO Branch(BCode, Librarian, Address) VALUES('B2', 'Mary Jones', '34 Pearse St');
INSERT INTO Branch(BCode, Librarian, Address) VALUES('B3', 'Francis Owens', 'Grange X');

-- create titles table
DROP TABLE IF EXISTS Titles;

CREATE TABLE Titles
( Title varchar(255),
  Author varchar(255),
  Publisher varchar(255),
  PRIMARY KEY(Title)
);

-- insert data to titles table
INSERT INTO Titles(Title, Author, Publisher) VALUES('Susannah', 'Ann Brown', 'Macmillan');
INSERT INTO Titles(Title, Author, Publisher) VALUES('How To Fish', 'Amy Fly', 'Stop Press');
INSERT INTO Titles(Title, Author, Publisher) VALUES('A History of Dublin', 'David Little', 'Wiley');
INSERT INTO Titles(Title, Author, Publisher) VALUES('Computers', 'Blaise Pascal', 'Applewoods');
INSERT INTO Titles(Title, Author, Publisher) VALUES('The Wife', 'Ann Brown', 'Macmillan');

-- create holdings table
DROP TABLE IF EXISTS Holdings;

CREATE TABLE Holdings
( Branch char(2),
  Title varchar(255),
  copies int,
  FOREIGN KEY(Branch) REFERENCES Branch(BCode),
  FOREIGN KEY(Title) REFERENCES Titles(Title)
);

-- insert data to holdings table
INSERT INTO Holdings(Branch, Title, copies) VALUES('B1', 'Susannah', 3);
INSERT INTO Holdings(Branch, Title, copies) VALUES('B1', 'How to Fish', 2);
INSERT INTO Holdings(Branch, Title, copies) VALUES('B1', 'A History of Dublin', 1);
INSERT INTO Holdings(Branch, Title, copies) VALUES('B2', 'How to Fish', 4);
INSERT INTO Holdings(Branch, Title, copies) VALUES('B2', 'Computers', 2);
INSERT INTO Holdings(Branch, Title, copies) VALUES('B2', 'The Wife', 3);
INSERT INTO Holdings(Branch, Title, copies) VALUES('B3', 'A History of Dublin', 1);
INSERT INTO Holdings(Branch, Title, copies) VALUES('B3', 'Computers', 4);
INSERT INTO Holdings(Branch, Title, copies) VALUES('B3', 'Susannah', 3);
INSERT INTO Holdings(Branch, Title, copies) VALUES('B3', 'The Wife', 1);

-- all library books published by  Macmillan
SELECT Title, Author FROM Titles WHERE Publisher = 'Macmillan';
+----------+-----------+
| Title    | Author    |
+----------+-----------+
| Susannah | Ann Brown |
| The Wife | Ann Brown |
+----------+-----------+

-- branches that hold any books by Ann Brown (using a nested subquery)
SELECT Branch FROM Holdings WHERE Title IN (SELECT Title FROM Titles WHERE Author = 'Ann Brown');
+--------+
| Branch |
+--------+
| B1     |
| B2     |
| B3     |
| B3     |
+--------+

-- branches that hold any books by Ann Brown (without using a nested subquery)
SELECT Branch FROM Holdings, Titles WHERE Holdings.Title = Titles.Title AND Author = 'Ann Brown';
+--------+
| Branch |
+--------+
| B1     |
| B3     |
| B2     |
| B3     |
+--------+

-- the total number of books held at each branch.
SELECT Branch, SUM(copies) AS 'No_of_Books' FROM Holdings GROUP BY Branch;
+--------+-------------+
| Branch | No_of_Books |
+--------+-------------+
| B1     |           6 |
| B2     |           9 |
| B3     |           9 |
+--------+-------------+
