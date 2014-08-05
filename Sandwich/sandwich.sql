-- create database
DROP DATABASE IF EXISTS Menu;

CREATE DATABASE Menu;

USE Menu;

-- create table Tastes
DROP TABLE IF EXISTS Tastes;

CREATE TABLE Tastes
( Name varchar(255),
  Filling varchar(255),
  PRIMARY KEY(Name, Filling)
);

-- insert data to the Tastes table
INSERT INTO Tastes(Name, Filling) VALUES('Brown', 'Turkey');
INSERT INTO Tastes(Name, Filling) VALUES('Brown', 'Beef');
INSERT INTO Tastes(Name, Filling) VALUES('Brown', 'Ham');
INSERT INTO Tastes(Name, Filling) VALUES('Jones', 'Cheese');
INSERT INTO Tastes(Name, Filling) VALUES('Green', 'Beef');
INSERT INTO Tastes(Name, Filling) VALUES('Green', 'Turkey');
INSERT INTO Tastes(Name, Filling) VALUES('Green', 'Cheese');

-- create table Locations
DROP TABLE IF EXISTS Locations;

CREATE TABLE Locations
( LName varchar(255),
  Phone int,
  Address varchar(255),
  PRIMARY KEY(LName)
);

-- insert data to the Locations table
INSERT INTO Locations(LName, Phone, Address) VALUES('Lincoln', 6834523, 'Lincoln Place');
INSERT INTO Locations(LName, Phone, Address) VALUES("O'Neill's", 6742134, 'Pearse St');
INSERT INTO Locations(LName, Phone, Address) VALUES('Old Nag', 7678132, 'Dame St');
INSERT INTO Locations(LName, Phone, Address) VALUES('Buttery', 7023421, 'College St');

-- create sandwiche table
DROP TABLE IF EXISTS Sandwiches;

CREATE TABLE Sandwiches
( Location varchar(255),
  Bread varchar(255),
  Filling varchar(255),
  Price float,
  FOREIGN KEY(Location) REFERENCES Locations(LName)
);

-- insert data to the Sandwiche table
INSERT INTO Sandwiches(Location, Bread, Filling, Price) VALUES('Lincoln', 'Rye', 'Ham',  1.25);
INSERT INTO Sandwiches(Location, Bread, Filling, Price) VALUES("O'Neill's", 'White', 'Cheese',  1.20);
INSERT INTO Sandwiches(Location, Bread, Filling, Price) VALUES("O'Neill's", 'Whole', 'Ham',  1.25);
INSERT INTO Sandwiches(Location, Bread, Filling, Price) VALUES('Old Nag', 'Rye', 'Beef',  1.35);
INSERT INTO Sandwiches(Location, Bread, Filling, Price) VALUES('Buttery', 'White', 'Cheese',  1.00);
INSERT INTO Sandwiches(Location, Bread, Filling, Price) VALUES("O'Neill's", 'White', 'Turkey',  1.35);
INSERT INTO Sandwiches(Location, Bread, Filling, Price) VALUES('Buttery', 'White', 'Ham',  1.10);
INSERT INTO Sandwiches(Location, Bread, Filling, Price) VALUES('Lincoln', 'Rye', 'Beef',  1.35);
INSERT INTO Sandwiches(Location, Bread, Filling, Price) VALUES('Lincoln', 'White', 'Ham',  1.30);
INSERT INTO Sandwiches(Location, Bread, Filling, Price) VALUES('Old Nag', 'Rye', 'Ham',  1.40);

-- places where Jones can eat (using a nested subquery)
SELECT Location FROM Sandwiches WHERE Filling IN (SELECT Filling FROM Tastes WHERE Name = 'Jones');
+-----------+
| Location  |
+-----------+
| O'Neill's |
| Buttery   |
+-----------+

-- places where Jones can eat (without using the nested subquery)
SELECT Location FROM Sandwiches, Tastes WHERE Tastes.Filling = Sandwiches.Filling AND Tastes.Name = 'Jones';
+-----------+
| Location  |
+-----------+
| O'Neill's |
| Buttery   |
+-----------+

-- number of people who can eat at each Location
SELECT Location, COUNT(DISTINCT Tastes.Name) AS No_of_Persons FROM Tastes, Sandwiches 
WHERE Tastes.Filling = Sandwiches.Filling
GROUP BY Sandwiches.Location;
+-----------+---------------+
| Location  | No_of_Persons |
+-----------+---------------+
| Buttery   |             3 |
| Lincoln   |             2 |
| O'Neill's |             3 |
| Old Nag   |             2 |
+-----------+---------------+
