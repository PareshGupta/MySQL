Q1: What do different columns in the output of EXPLAIN mean? What possible values can those have? What is the meaning of those values?

Ans1: 
/*
EXPLAIN SELECT * FROM Locations, Sandwiches;
+----+-------------+------------+------+---------------+------+---------+------+------+-------------------+
| id | select_type | table      | type | possible_keys | key  | key_len | ref  | rows | Extra             |
+----+-------------+------------+------+---------------+------+---------+------+------+-------------------+
|  1 | SIMPLE      | Locations  | ALL  | NULL          | NULL | NULL    | NULL |    4 |                   |
|  1 | SIMPLE      | Sandwiches | ALL  | NULL          | NULL | NULL    | NULL |   10 | Using join buffer |
+----+-------------+------------+------+---------------+------+---------+------+------+-------------------+
*/

1) id : The SELECT identifier. This is the sequential number of the SELECT within the query.
        The value can be NULL if the row refers to the union result of other rows.

2) select_type : The type of query with possible values:
    SIMPLE : Simple SELECT query without any subqueries or UNIONs
    PRIMARY : Outermost Select query in a JOIN
    DERIVED : Derived table SELECT (subquery in FROM clause)
    SUBQUERY : First SELECT in a subquery
    DEPENDENT SUBQUERY : Subquery which is dependent upon on outer query
    UNCACHEABLE SUBQUERY : Subquery which is not cacheable
    UNION : the SELECT is the second or later statement of a UNION
    DEPENDENT UNION : the second or later SELECT of a UNION is dependent on an outer query
    UNION RESULT : the SELECT is a result of a UNION

3) table : The name of the table to which the row of output refers.

4) type : This type describes how MySQL joins the tables. Possible values:
    system : The table has only one row. This is a special case of the const join type.

    const : The table has at most one matching row, which is read at the start of the query. Because there is only one
            row, values from the column in this row can be regarded as constants by the rest of the optimizer.

    eq_ref : One row is read from this table for each combination of rows from the previous tables. Other than the system
             and const types, this is the best possible join type. It is used when all parts of an index are used by the join and the index is a PRIMARY KEY or UNIQUE NOT NULL index.

    ref : All rows with matching index values are read from this table for each combination of rows from the previous
          tables.

    fulltext : The join is performed using a FULLTEXT index.

    index_merge : This join type indicates that the Index Merge optimization is used. In this case, the key column in the
                  output row contains a list of indexes used, and key_len contains a list of the longest key parts for the indexes used.

    unique_subquery : This type replaces ref for some IN subqueries. unique_subquery is just an index lookup function that
                      replaces the subquery completely for better efficiency.

    index_subquery : This join type is similar to unique_subquery. It replaces IN subqueries, but it works for nonunique
                    indexes.

    range : Only rows that are in a given range are retrieved, using an index to select the rows. The key column in the
            output row indicates which index is used. The key_len contains the longest key part that was used. The ref column is NULL for this type.

    index : The index join type is the same as ALL, except that the index tree is scanned.

    ALL : A full table scan is done for each combination of rows from the previous tables. This is normally not good if
          he table is the first table not marked const, and usually very bad in all other cases. Normally, you can avoid ALL by adding indexes that enable row retrieval from the table based on constant values or column values from earlier tables.

5) possible_keys : The possible_keys column indicates which indexes MySQL can choose from use to find the rows in this
                   table. Note that this column is totally independent of the order of the tables as displayed in the output from EXPLAIN. That means that some of the keys in possible_keys might not be usable in practice with the generated table order. In fact, this column can often help in optimizing queries since if the column is NULL, it indicates no relevant indexes could be found.

6) key : indicates the actual index used by MySQL. This column may contain an index that is not listed in the
         possible_key column. MySQL optimizer always look for an optimal key that can be used for the query. While joining many tables, it may figure out some other keys which is not listed in possible_key but are more optimal.

7) key_len : indicates the length of the index the Query Optimizer chose to use. i.e. a key_len value of x means it
             requires memory to store x characters.

8) ref : The ref column shows which columns or constants are compared to the index named in the key column to select rows
         from the table.

9) rows : The rows column indicates the number of rows MySQL believes it must examine to execute the query.

10) Extra : This column contains additional information about how MySQL resolves the query.

-- ====== question 2 ====== --
/*
Q2: We use EXPLAIN to optimize slow SQL queries used in our application. Lets say we have a comments table in our application that has a foreign key, user_id, referencing to users table. EXPLAINing the query that finds all the comments made by a user gives us following result.

EXPLAIN SELECT * FROM comments WHERE user_id = 41;

+-------------+------+---------------+---------+-------+---------+-------------+
| select_type | type | key           | key_len | ref   | rows    | Extra       |
+-------------+------+---------------+---------+-------+---------+-------------+
| SIMPLE      | ALL  | NULL          | NULL    | NULL  | 1002345 | Using where |
+-------------+------+---------------+---------+-------+---------+-------------+

mysql> SELECT count(id) FROM comments;

+-----------+
| count(id) |
+-----------+
| 1002345   |
+-----------+
*/

Q2.1) The value under 'rows' column in the output of EXPLAIN query and SELECT query after it are same. What does it mean?

Ans2.1) The row field in EXPLAIN refers to the number of row processed to produce the result. Thus select query searched
        upon the entire set to produce the result set corresponding to user_id = 41.

Q2.2) Is the SELECT query optimal? If no, how do we optimize it?

Ans2.2) No, the select query is not optimal. To select a particular record reffered to by
      where clause in the query will have to search for that record in the entire table of 1002345 records.
      It can be optimized by adding an index to the user_Id column.

-- ====== question 3 ====== --
/*
Lets say in our web application, we can let users comment on photographs and articles. Some of rows in comments table are represented as following:

mysql> SELECT * FROM comments LIMIT 5;

+----+------------------+----------------+---------+
| id | commentable_type | commentable_id | user_id |
+----+------------------+----------------+---------+
| 1  + Article          | 1              | 1       |
+----+------------------+----------------+---------+
| 2  + Photo            | 1              | 1       |
+----+------------------+----------------+---------+
| 3  + Photo            | 2              | 2       |
+----+------------------+----------------+---------+
| 4  + Photo            | 2              | 2       |
+----+------------------+----------------+---------+
| 5  + Article          | 1              | 2       |
+----+------------------+----------------+---------+

When we need to fetch comments of a user on a particular Article or Photo we form a query like:

mysql> EXPLAIN SELECT * FROM comments WHERE commentable_id = 1 AND commentable_type = 'Article' AND user_id = 1;

+-------------+------+---------------+---------+-------+---------+-------------+
| select_type | type | key           | key_len | ref   | rows    | Extra       |
+-------------+------+---------------+---------+-------+---------+-------------+
| SIMPLE      | ALL  | NULL          | NULL    | NULL  | 1000025 | Using where |
+-------------+------+---------------+---------+-------+---------+-------------+

It seems that we do not have any index on any of the columns. And whole comments table is scanned to fetch those comments.
*/

Q3) We decide to index columns in comments table to optimize the SELECT query. What column(s) will you index in which
    order? Ask the exercise creator for a hint if you are confused.

Ans3) The columns user_id, commentable_id and commentable_type should all be indexed. This can be done by-
      ALTER TABLE comments ADD INDEX(user_id, commentable_id, commentable_type);

-- ====== question 4 ====== --
Q4.1) EXPLAIN a SELECT query against one of your databases which employs an INNER JOIN between two tables. What does the
      output look like? What does the values under different columns mean? Do you get only one row in EXPLAIN output?

-- Ans4.1)
-- EXPLAIN SELECT article
-- FROM articles A LEFT JOIN comments C
-- ON(A.id = C.article_id)
-- WHERE comment IS NULL;

-- +----+-------------+-------+------+---------------+------------+---------+----------------+------+-------------+
-- | id | select_type | table | type | possible_keys | key        | key_len | ref            | rows | Extra       |
-- +----+-------------+-------+------+---------------+------------+---------+----------------+------+-------------+
-- | 1  | SIMPLE      | A     | ALL  | NULL          | NULL       | NULL    | NULL           | 6    |             |
-- | 1  | SIMPLE      | C     | ref  | article_id    | article_id | 9       | exercise3.A.id | 1    | Using where |
-- +----+-------------+-------+------+---------------+------------+---------+----------------+------+-------------+
-- 2 rows in set (0.00 sec)

-- 1) id : Id '1' corresponding to both the rows in the EXPLAIN table indicates that there is no subquery.
-- 2) select_type : 'SIMPLE' indicates that there are no sub queries.
-- 3) table : Table column indicates what all tables have been processed for creating the result set
-- 4) type : A full table scan is done for both the tables as no indexing is done
-- 5) possible_key : Keys which can be used for searching on that table.
-- 6) key : Keys that were actually used while querying the data table.
-- 7) key_len : Shows the total values in the key used. This can be an indication if we are using long keys which
--                   require large memory for storage.
-- 8) ref : Shows the keys reffered .These keys have to..
Ans4.1)
EXPLAIN SELECT Orders.O_id, User.FirstName, Orders.Price FROM Orders 
INNER JOIN User ON Orders.User_id = User.UserId 
WHERE User.FirstName IS NULL;