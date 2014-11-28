vagrant-django
==============

Bootstrap your Django project with Vagrant


Creating a PostgreSQL Database
==============================

$ sudo su - postgres
postgres$ createdb dbname -T template_postgis
postgres$ createuser -P
Enter name of role to add: dbuser
Enter password for new role:
Enter it again:
Shall the new role be a superuser? (y/n) n
Shall the new role be allowed to create databases? (y/n) n
Shall the new role be allowed to create more new roles? (y/n) n

postgres$ psql -c "GRANT ALL PRIVILEGES ON DATABASE dbname TO dbuser;"
