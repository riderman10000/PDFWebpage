SQL - Structured Query Language

#starting and stopping mysql
-mysql server daemon is controlled via a single program, located in INSTALL-DIR/bin directory.
##starting mysql
-the script responsible for starting the mysql daemon is called mysqld_safe, which is located in the install-dir/bin (if downloaded from terminal using command then locate mysqld_safe).
-following command to start 
$: ./mysqld_safe --user=mysql &

- the mysqld_safe script is actually a wrapper around the mysqld server daemon, offering features that are not available by calling mysqld directly,such as run-time logging and automatic restart in case of error.

#stopping 
-use the folloeing command
$: cd install-dir/bin
$: mysqladmin -u root -p shutdown




viewing mysql configuration parameters

$: mysqladmin -u root -p variables
or 
mysql> show variables;

for more statistical information like uptime, queries processed, and total bytes received 
mysql > show status;

#Managing connection loads
-back_log parameter determines the number of connection load. By default this is set to 50.
-we can't just set this to a very high value and assume it will make MYSQL run more efficiently.

#Setting the data directory location
-common practice to place the mysql data dir. in a non standard location.
-using datadir option, can redefine this path. 
$: ./bin/mysqld_safe --datadir=/data/mysql --user=mysql &
-keep in mind that we need to copy or move the mysql permission tables(stored in datadir/mysql) to this new location. because mysql's databases are stored in files, you can do so y using operating system commands that are typical for performing such actions, such as mv and cp.
(but this is not tested yet)

#Setting the default storage engine
-contains several table engines, if we use a particular engine (as of version 4.1.5, the default is MyISAM on linux, and InnoDB on windows), we might want to set is as default by using the --default-storage-engine parameter.

$> ./bin/mysqld_safe --default-table-type=memory

once it is assigned, all subsequent table creation queries will automatically use the memory engine unless otherwise specified.

#Automatically executing SQL commands
-can execte series of command at daemon startup by placing them in a text file and assigning that file name to init_file. 
e.g. file name be mysqlinitcmds.sql 
then assign init_file like so while executing mysqld_safe:
$: ./bin/mysqld_safe --init_file=/usr/local/mysqld/scripts/mysqlinitcmds.sql &

#Setting mysql communication port
-by default , its communicates on port 3306; can be reconfigure it to listen on any other port by using port parameter

#Disabling DNS resolution
-enabling the skip-name-resolve parameter prevents it from resolving hostnames.

#Limiting Connection to the local server
-enabling the skip-networking parameter prevents it from listening for TCP/IPconnection, a wise idea if your mysql installation resides on the same server from which you'll be initiating connection.

#Setting the mysql daemon user
-it should be run as a non-root use, minimize the damage if an attacker were to  ever successfully enter the server via mysql security hole. common practice is to run the server as user mysql, you can run it as any existing user, provided that the user is the owner of the data dir.
e.g. if want to run the daemon using the user mysql:
$> ./bin/mysqld_safe --user=mysql &

#The my.cnf file
-there is an easy way to tweak these startup parameter as well as the behaviors of many sql clients by my.cnf,

-------------------------------------------------------------------------------

#The mysql client 
-need a hostname (-h), username(-u) and password(-p), often you'll want to include the target database name(-D ) to save extra step of executing the use command once entered the client. e.g.
$: mysql -h hostname -u username -p -D databasename

once connecte via the mysql client, can now execute sql commands

- to list of all existing databases:
mysql> SHOW databases;

- to switch (or use )another database
mysql> USE mysql;

- to view all tables in the database
mysql> SHOW tables;

- to view the structure of one of those tables, for instance, the host table
mysql> DESCRIBE host;

-can also execute sql queries such as insert, select, update and delete.
for example, suppose you want to select all values residing in the Host and Usercolumns of the user table, found in the mysql database and order it by the Host:
mysql> SELECT Host, User FROM user ORDER BY Host

#Useful mysql tips
#paging output
$: mysql < queries.sql | more

#Displaying Results vertically
-use \G option to display query results in a vertical option.
mysql>use mysql;
mysql>select * from db\G

#Logging queries
-when working interactively with the mysql client, it can be useful to log all result to a text file so that you can review later.
-can initiate logging with the tee or \T option followed by a file name and if desired prepend with a path.

mysql>\T fileaname.sql
//now work on the data base which will automatically get recorded to the file 
-once logging begin the output exactly as you see it here will be logged to filename.sql . To disable logging at any time during the session, execute notee or \t.


#Getting Server Statistics
-executing the status, or \s, command will retrieve a number of useful statistics regarding the current server status.

#Preventing accidents 
-if some how deleted an unwanted row by acciden then:
mysql>DELETE FROM subscriberss(//only the name of table attr.);
rather than
mysql>DELETE FROM subscribers WHERE email="test@example.com";

-whoops, just deleted entire subscriber bae. The --safe-updates option prevents such inadvertent mistakes by refusing to exevute any DELETE or UPDATE query thatis not accompained with a WHERE clause. comically, you could also use the --i-am-a-dummy switch for the same purpose!

#Modifying mysql prompt
-to avoid confusion when working with multiple database in multiple server. To make the location obvious, modify the default prompt ro include the hostname. which can be done in several ways:
1. when logging into mysql:

$: mysql -u jason --prompt="(\u@\h) [\d]> " -p corporate

to render the change more permanent, can also make the change in the my.cnf file, under the [mysql] section:

[mysql]
...
prompt=(\u@\h)[\d]>

On linux only, can include the hostname on the prompt via the MYSQL_PS1 environment variable:

$: export MYSQL_PS1 = "(\u@\h) [\d]>"

#Outputting table in data in html and xml
-cool but largely unknown feature of the mysql client , allows one to output query results in xml and html formats, using the --xml (-X) and --html (-H) options, respectively.
e.g. 
suppose you want to create an XML file consisting of the databases found on a given server. you could place the command SHOW DATABASES in a text file and then invoke the mysql client in batch mode, like so:

$:mysql -X < showdb.sql > serverdatabase.xml

#Viewing configuration variable and system status
-to view a comprehensive listing of all server configuration variable via the SHOW VARIABLES command:

mysql> SHOW VARIABLES;

-as of version 5.0.3, this command returns 234 different system variables.
-to view just a particular variable, say the default table type, use this command in conjunction with LIKE :

mysql> SHOW VARIABLES LIKE "table_type";

--------------------------------------------------------------------------

#mysqladmin commands
*CREATE databasename	-creates new database
*DROP databasename 	-deletes an existing database
*extended-status 	-provide extended information regarding server status
*flush-hosts		-flushes the host cache tables. need to use this if a 
			 host IP address changees, use this if the Mysql server
			 daemon receives a number of failed connection req. from
			 a specific host (exact no. is determine by max_connect_error)
			 because that host will be blocked from attempting additional
			 request.
*flush-logs		-closes and reopens all logging files
*flush-status		-reset status variables, setting them to zero
*flush-tables		-closes all open tables and terminates all running table querie
*flush-threads		-purges the thread cache
*flush-privileges	-reload the privilege tables. if you're using the GRANT and
			 REVOKE commands rather than directly modifying the privilege 
			 tables using sql queries, you donot need to use this command.
*kill id[,id2[,idN]] 	-terminates the processes specifie by id, id2 through idN. you 
			 can view the process numbers with the *processlist command.
*old-passwordnew-password
			-changes the password of the uer specified by -u to new-password
			 using the pre-mysql4.1 password-hashing algorithm
*ping 			-verifies that the mysql server is running by pinging
*processlist		-displays a list of all runnning mysql server daemon process
*reload 		-alias of the command flush-privileges
*refresh		-combines the tasks carried out by the commands flush-tables
*shutdown		-shuts the mysql server daemon down.
*status			-outputs various server  statistics.
*start-slave
*stop-slave
*variables
*version
-----------------------------------------------------------------------------------
#mysqldump
-used to export existing table data, table structures or both from the sql server

#mysqlshow
-offers a convenient means for determining which database, tables and columns exit on a given database server.

#mysqlhotcopy
-utility as an improved mysqldump, using various optimization techniques to back up one
or several databases, and writing the data to a file (or files) of the same namev s 
the database that is being backed up.

-----------------------------------------------------------------------

#Available storage engines;
mysql> SHOW ENGINES;

if using older version less than 4.1.2 use 
mysql> SHOW VARIABLES LIKE 'have_%';

#Data types and attributes

#date and time data types
#DATE
-for storing data information.
#DATETIME
-for storing combination of data and time information.
#TIME
-for storing time information and supports a range large enough not only to 
 represent both standard and military-style formats, but also to represent 
 extended time intervals
#TIMESTAMP [DEFAULT][ON UPDATE]
-differs from DATETIME in that mysql default behavior is to automatically update
 it to current dat and time whenever an INSERT or UPDATE operation affecting it
 is executed.

#Numeric data types
#BOOL, BOOLEAN
#BIGINT[(M)]
-offers mysql's largest integer range
INT,MEDIUMINT, SMALLINT, TINYINT, DECIMAL, FLOAT
#string data types
CHAR, VARCHAR, LONGBLOB, LONGTEXT, MEDIUMTEXT, BLOB, TEXT, TINYBLOB,
TINYTEXT, ENUM, SET
#data type attribute
AUTO_INCREMENT, BINARY, DEFAULT, INDEX, NATIONAL, NOTNULL, NULL, PRIMARY KEY, 
UNIQUE, ZEROFILL.
-------------------------------------------------------------------------------
#Working with databases and tables

#Working with databases
-this section is for how to view, create, select and delete Mysql databases.
#viewing databases

mysql> SHOW DATABASES;

-ability to view all the available databases on a given server is affected by user privileges.

#Creating a database
-there are two way to create a database.
1.
mysql> CREATE DATABASE databasename;

2.
$: mysqladmin -u root -p create databasename

-common problem for failed database creation include insufficient or incorrect permission or attempt to create a database that already exists.

#Using a database
- Once the database has been created, you can designated it as the default working database by "using" it, done with the USE command.

mysql> USE databasename;

alternatively,

$: mysql -u root -p databasename

#Deleting a database

mysql> DROP DATABASE databasename;

alternatively,

$: mysqladmin -u root -p drop databasename

-----------------------------------------------------------------------------

#Working with tables

#creating a table
note: contains only the general usage...

CREATE TABLE nameoftable (
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	firstname VARCHAR(25) NOT NULL,
	lastname VARCHAR(25) NOT NULL,
	email VARCHAR(45) NOT NULL,
	phone VARCHAR(10) NOT NULL,
	PRIMARY KEY(id));
- a table must consist of at least one column. can alter the table structure after it has been created.

#Conditionally creating a table
-generates an error if you attempt to create a table that already exists. to 
 avoid error, the CREATE TABLE statemet offers a clause that can be included if
 you want to simply abort the table-creation attempt if the target table already
 exists.

CREATE TABLE IF NOT EXISTS tableName (

///content of the table

);

-one oddity of this action is that the output doesnot specify whether the table
 was created. both variation display the "query ok" message.

#Copying a table

-trivial task to create a new table based on an existiong one . the following 
 query produce an exact copy of the employees table, naming it databasename2.

CREATE TABLE databasename2 SELECT * FROM  databasename;

-an identical table, databasename2, will be added to the database.

-if you need to create table based on just a few columns found in a preexisting 
 table. can do so by simply specifying the columns within the CREATE SELECT
 statement:

CREATE TABLE databasename3 SELECT firstname, lastname FROM databasename;

#Creating a temporary table
-it is useful to create a table which have a certain life time i.e. for the 
 current session. if we want to perform several queries on a subset of a 
 particularly large table. rather than repeatedly run those queries against
 the entire table, we can create a temporary table and run the queries.
the TEMPORARY keyword is use in conjunction with the CREATE TABLE statement.

CREATE TEMPORARY TABLE database_tmp SELECT firstname, lastname FROM databasename;

-temporary table are created just as any other table would be, except that they
 are stored in the operating system designated temporary directory, typically 
 /tmp or /usr/tmp on linux.
- this directory can be override by setting in mysql TMPDIR environment variable

#Viewing a database's available tables

mysql>SHOW TABLES;

#Viewing a table structure

mysql>DESCRIBE tablename;

alternately,
 mysql> SHOW COLUMNS IN tablename;

#Inserting one or more rows into table

INSERT INTO tableName(column1,column2,...)
VALUES (value1,value2,...);

INSERT INTO tableName(company,phone)
VALUES ('futureLab','09993049834');

#Insert statement- insert multiple rows into a table

INSERT INTO tableName(column1, column2, ...)
VALUES 	(value1,value2, ...),
	(value1,value2, ...),
	...);

#Viewing the content of table (sql select statement)

SELECT column1, column2, ... FROM tableName;


#Deleting a table

mysql> DROP TABLE table1;

for multiple

mysql> DROP TABLE table1, table2, table3;

#Altering a table structure

-can alter the table using ALTER statement. 

ALTER TABLE tablename ADD COLUMN birthdate DATE; //birthdate -> columnName , DATE as in data

-by default it is placed at the last position of the table. Can control the 
 postioning of a new column by using an appropriate keyword, including FIRST
 , AFTER and LAST. as:
 ALTER TABLE tablename ADD COLUMN birthdate DATE AFTER lastname;

#Modify the new column as 

 ALTER TABLE tablename CHANGE birthdate DATE NOT NULL;

#Delete the column 

ALTER TABLE tablename DROP columnName;

#the INFORMATION_SCHEMA
- it seems very useful chech this out later.
 

