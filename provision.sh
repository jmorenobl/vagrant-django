#!/usr/bin/env bash

PROJECT_FOLDER=/vagrant/project

if [ -z $1 ]; then
  PROJECT_NAME="myproject"
else
  PROJECT_NAME=$1
fi

# Install basic packages
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential binutils python-dev python-pip \
libjpeg62 libjpeg62-dev libfreetype6 libfreetype6-dev zlib1g-dev gettext postgresql \
postgresql-contrib libpq-dev libproj-dev gdal-bin libgeoip1 python-gdal postgis postgresql-8.4-postgis

# Upgrade python packages downloaded from repository
pip install --upgrade setuptools
pip install --upgrade pip

# Setup folder
if [ ! -d $PROJECT_FOLDER ]; then
	mkdir $PROJECT_FOLDER
fi

if [ ! -f $PROJECT_FOLDER/requirements.txt ]; then
	pip install django==1.6.8

	django-admin.py startproject --template=https://github.com/jmorenobl/django-template-project/archive/master.zip --extension=py,rst,html $PROJECT_NAME $PROJECT_FOLDER

	echo "
	Pillow
  psycopg2
	" >> $PROJECT_FOLDER/requirements/base.txt

	pip install -r $PROJECT_FOLDER/requirements/local.txt
fi

# Necessary to access PostgreSQL from outside Vagrant
sed -i "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/8.4/main/postgresql.conf
sed -i "s/^local   all         all                               ident/local   all         all                               md5/" /etc/postgresql/8.4/main/pg_hba.conf
service postgresql-8.4 restart

POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib

su - postgres -c "createdb -E UTF8 template_postgis"
su - postgres -c "createlang -d template_postgis plpgsql"
su - postgres -c "psql -d postgres -c \"UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';\""
su - postgres -c "psql -d template_postgis -f $POSTGIS_SQL_PATH/postgis.sql"
su - postgres -c "psql -d template_postgis -f $POSTGIS_SQL_PATH/spatial_ref_sys.sql"
su - postgres -c "psql -d template_postgis -c \"GRANT ALL ON geometry_columns TO PUBLIC;\""
su - postgres -c "psql -d template_postgis -c \"GRANT ALL ON spatial_ref_sys TO PUBLIC;\""

chown -R vagrant:vagrant /home/vagrant/
