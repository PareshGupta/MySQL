# Create Table with the 3 columns
  CREATE TABLE testing_table
  ( name varchar(255),
    contact_name varchar(255),
    roll_no varchar(255)
  );

  +--------------+--------------+------+-----+---------+-------+
  | Field        | Type         | Null | Key | Default | Extra |
  +--------------+--------------+------+-----+---------+-------+
  | name         | varchar(255) | YES  |     | NULL    |       |
  | contact_name | varchar(255) | YES  |     | NULL    |       |
  | roll_no      | varchar(255) | YES  |     | NULL    |       |
  +--------------+--------------+------+-----+---------+-------+

# Delete column name
  ALTER TABLE testing_table DROP COLUMN name;

  +--------------+--------------+------+-----+---------+-------+
  | Field        | Type         | Null | Key | Default | Extra |
  +--------------+--------------+------+-----+---------+-------+
  | contact_name | varchar(255) | YES  |     | NULL    |       |
  | roll_no      | varchar(255) | YES  |     | NULL    |       |
  +--------------+--------------+------+-----+---------+-------+

# Rename column contact_name
  ALTER TABLE testing_table CHANGE COLUMN contact_name username varchar(255);

  +----------+--------------+------+-----+---------+-------+
  | Field    | Type         | Null | Key | Default | Extra |
  +----------+--------------+------+-----+---------+-------+
  | username | varchar(255) | YES  |     | NULL    |       |
  | roll_no  | varchar(255) | YES  |     | NULL    |       |
  +----------+--------------+------+-----+---------+-------+

# Add new column first_name, last_name
  ALTER TABLE testing_table
  ADD COLUMN first_name varchar(255), ADD COLUMN last_name varchar(255);

  +------------+--------------+------+-----+---------+-------+
  | Field      | Type         | Null | Key | Default | Extra |
  +------------+--------------+------+-----+---------+-------+
  | username   | varchar(255) | YES  |     | NULL    |       |
  | roll_no    | varchar(255) | YES  |     | NULL    |       |
  | first_name | varchar(255) | YES  |     | NULL    |       |
  | last_name  | varchar(255) | YES  |     | NULL    |       |
  +------------+--------------+------+-----+---------+-------+

# Change column roll_no datatype 
  ALTER TABLE testing_table MODIFY COLUMN roll_no int;

  +------------+--------------+------+-----+---------+-------+
  | Field      | Type         | Null | Key | Default | Extra |
  +------------+--------------+------+-----+---------+-------+
  | username   | varchar(255) | YES  |     | NULL    |       |
  | roll_no    | int(11)      | YES  |     | NULL    |       |
  | first_name | varchar(255) | YES  |     | NULL    |       |
  | last_name  | varchar(255) | YES  |     | NULL    |       |
  +------------+--------------+------+-----+---------+-------+
