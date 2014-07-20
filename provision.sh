#!/usr/bin/env bash

if [ -z $1 ]; then
  PROJECT_NAME="myproject"
else
  PROJECT_NAME=$1
fi

# Install basic packages
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential python-dev python-pip python-virtualenv libjpeg62 libjpeg62-dev libfreetype6 libfreetype6-dev zlib1g-dev

# Upgrade python packages downloaded from repository
pip install --upgrade setuptools
pip install --upgrade pip
pip install --upgrade virtualenv

# Install basic python packages
pip install virtualenvwrapper 

export WORKON_HOME=/home/vagrant/.virtualenvs
export PROJECT_HOME=/vagrant
source /usr/local/bin/virtualenvwrapper.sh

if [ ! -f "/home/vagrant/.bashrc_updated" ]; then
	echo "
	export WORKON_HOME=/home/vagrant/.virtualenvs
	export PROJECT_HOME=/vagrant
	source /usr/local/bin/virtualenvwrapper.sh

	workon project
	" >> /home/vagrant/.bashrc

	cp /home/vagrant/.bashrc /home/vagrant/.bashrc_updated
fi

# Setup virtualenv
if [ ! -d '/vagrant/project' ]; then
	mkproject project
else
	workon project
fi

if [ ! -f '/vagrant/project/requirements.txt' ]; then
	pip install django

	django-admin.py startproject --template=https://github.com/jmorenobl/django-template-project/archive/master.zip --extension=py,rst,html $PROJECT_NAME /vagrant/project

	echo "
	Pillow
	" >> /vagrant/project/requirements/base.txt

	pip install -r /vagrant/project/requirements/local.txt
fi
