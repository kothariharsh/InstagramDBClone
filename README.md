# InstagramDBClone
This repo is a MySQL Instagram Dataset clone and consists a buch of queries that we can use in different scenarios.

Credits: I learned this at The Ultimate MySQL Bootcamp at Udemy.


### Running it first time
1. Download MySQL 8 Software. I recommend you to select legacy when the download prompt ask you for connector as it will later allow you to use things like Node.js which as of today isn't supported with standard connector.
2. Download MySQL 8 Workbench.
3. Start MySQL Server & Open MySQL Workbench
4. Run create_database.sql via File => Run SQL Script
5. File => Open SQL Script and open set_sql_mode.sql and execute it to avoid SQL Error 1055.
6. If you want to start using the Database schema then just type 
## USE instagram_clone_db; 
and Now we are using instagram_clone_db schema
