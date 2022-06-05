To install the application you need to have python installed.

-Execute the following command in the root project directory:

pip install -r ./requirements.txt

After you activate the local server for your databases

You need a program to run sql scripts.

-Open and run:

1. "erga.sql" in the "Baseis" directory		for the creation of the database 
2. "erga-data" in the "Baseis" directory	for the population of the database

-Now go to "Sembaseis" directory and open the "demo1.py" file

-In line 6 complete: 
db=mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="erga"
)

with your own server data

-Now you can execute the python file "demo1.py" and run the application



Note: In the directory "Baseis" there is a file named "queries.sql" with all the queries asked.
Queries 3.1, 3.2 are implemented at python directly.
We have created the indexes in the "erga.sql" file.