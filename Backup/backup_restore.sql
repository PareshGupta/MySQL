-- create backup for Multibranch_Library database
mysqldump -u root -p Multibranch_Library > multibranch_library_dump.sql

-- create restored database
DROP DATABASE IF EXISTS restored;
CREATE DATABASE restored;

-- restore backup file to restored database
mysql -u root -p restored < multibranch_library_dump.sql
