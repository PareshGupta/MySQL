-- create database vtapp
DROP DATABASE IF EXISTS vtapp;
CREATE DATABASE vtapp;

USE vtapp;

-- create user 
DROP USER 'vtapp_user'@'localhost';
CREATE USER 'vtapp_user'@'localhost' IDENTIFIED BY 'iamthebest';

-- grant permissions to the user
GRANT ALL ON vtapp.* TO 'vtapp_user'@'localhost';
SHOW GRANTS FOR 'vtapp_user'@'localhost';

+-------------------------------------------------------------------------------------------------------------------+
| Grants for vtapp_user@localhost                                                                                   |
+-------------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'vtapp_user'@'localhost' IDENTIFIED BY PASSWORD '*014CB9097FA3B66A517AA64D5F63ACA0171C6FD7' |
| GRANT ALL PRIVILEGES ON `vtapp`.* TO 'vtapp_user'@'localhost'                                                     |
+-------------------------------------------------------------------------------------------------------------------+
