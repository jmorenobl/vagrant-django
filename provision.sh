#!/usr/bin/env bash

if [ -z $1 ]; then
  PROJECT_NAME="myproject"
else
  PROJECT_NAME=$1
fi

# Install basic packages
apt-get update
apt-get install -y build-essential python-dev python-pip python-virtualenv libmysqlclient-dev libjpeg62 libjpeg62-dev libfreetype6 libfreetype6-dev zlib1g-dev

# Upgrade python packages downloaded from repository
pip install --upgrade setuptools
pip install --upgrade pip
pip install --upgrade virtualenv

# Install basic python packages
pip install virtualenvwrapper 

export WORKON_HOME=/home/vagrant/.virtualenvs
export PROJECT_HOME=/vagrant
source /usr/local/bin/virtualenvwrapper.sh

echo "
export WORKON_HOME=/home/vagrant/.virtualenvs
export PROJECT_HOME=/vagrant
source /usr/local/bin/virtualenvwrapper.sh

workon project
" >> /home/vagrant/.bashrc

# Setup virtualenv
mkproject project

# Install basic project packages inside the virtualenv
pip install MySQL-python Pillow django

# Set up a Django project (TODO)
django-admin.py startproject --template=https://github.com/twoscoops/django-twoscoops-project/archive/master.zip --extension=py,rst,html $PROJECT_NAME /vagrant/project
pip install -r /vagrant/project/requirements/local.txt
