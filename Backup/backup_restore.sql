-- create backup for Multibranch_Library database
mysqldump -u root -p Multibranch_Library > backup.sql

-- create restored database
DROP DATABASE IF EXISTS restored;
CREATE DATABASE restored;

-- restore backup file to restored database
mysql -u root -p restored < backup.sql
