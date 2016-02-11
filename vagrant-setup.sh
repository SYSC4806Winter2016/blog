#!/bin/sh 

#The following parameters are to configure PostgreSQL. 
# Edit the following to change the name of the database user that will be created:
APP_DB_USER=blog
APP_DB_PASS=dbpass

# Edit the following to change the name of the databases that are created (defaults to dev_ [theuser name] and test_ [the username])
APP_DB_NAME1=dev_$APP_DB_USER
APP_DB_NAME2=test_$APP_DB_USER

# Edit the following to change the version of PostgreSQL that is installed: we'll stick to 9.3 because this version is available from the standard Ubuntu repositories.
PG_VERSION=9.3

export DEBIAN_FRONTEND=noninteractive #this will suppress interaction with the user, along with the -y flag of apt-get (see below)


#add a repository for ruby (this means apt-get will query this repo to obtain the packages we want)
apt-add-repository -y ppa:brightbox/ruby-ng

# Update package list and upgrade all packages
apt-get update
apt-get -y upgrade

############################### Edit here #

# install the following packages:  
#       - build-essential  (development tools)
#       - libpq-dev (to develop postgresql client apps)
#       - ruby2.3 (Ruby language, version 2.3 ! accessible through the repo we added above)
#       - ruby2.3-dev

############################################
#install postgresql
apt-get -y install "postgresql-$PG_VERSION" "postgresql-contrib-$PG_VERSION"

#the following are PostgreSQL configuration files that need to be edited to change permissions, authentication methods, etc.
PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"


# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

############################### Edit here #

# Edit pg_hba.conf to add password authentication
#

############################################

echo "host    all             all             all                     md5" >> "$PG_HBA"

# Explicitly set default client_encoding
echo "client_encoding = utf8" >> "$PG_CONF"

# Restart so that all new config is loaded:
service postgresql restart

# 'cat' (write) the following lines (up to 'EOF') to the program psql, which is the interactive command-line of PostgreSQL
cat << EOF | su - postgres -c psql
-- Create the database user:
CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';

-- Create the database:
CREATE DATABASE $APP_DB_NAME1 WITH OWNER=$APP_DB_USER
                                  LC_COLLATE='en_US.utf8'
                                  LC_CTYPE='en_US.utf8'
                                  ENCODING='UTF8'
                                  TEMPLATE=template0;

CREATE DATABASE $APP_DB_NAME2 WITH OWNER=$APP_DB_USER
                                  LC_COLLATE='en_US.utf8'
                                  LC_CTYPE='en_US.utf8'
                                  ENCODING='UTF8'
                                  TEMPLATE=template0;

EOF


###########################################################
# This is the message you will get when the script finishes
echo "Successfully created PostgreSQL dev virtual machine."
echo ""
echo "Your PostgreSQL database has been setup and can be accessed on your local machine on the forwarded port (default: 15432)"
echo "  Host: localhost"
echo "  Port: 15432"
echo "  Database: $APP_DB_NAME1"
echo "  Username: $APP_DB_USER"
echo "  Password: $APP_DB_PASS"
echo ""
echo "  Database: $APP_DB_NAME2"
echo "  Username: $APP_DB_USER"
echo "  Password: $APP_DB_PASS"
echo ""
echo "Admin access to postgres user via VM:"
echo "  vagrant ssh"
echo "  sudo su - postgres"
echo ""
echo "psql access to app database user via VM:"
echo "  vagrant ssh"
echo "  sudo su - postgres"
echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost $APP_DB_NAME1"
echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost $APP_DB_NAME2"
echo ""
echo "Env variable for application development:"
echo "  DATABASE_URL=postgresql://$APP_DB_USER:$APP_DB_PASS@localhost:15432/$APP_DB_NAME1"
echo "  DATABASE_URL=postgresql://$APP_DB_USER:$APP_DB_PASS@localhost:15432/$APP_DB_NAME2"
echo ""
echo "Local command to access the database via psql:"
echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost -p 15432 $APP_DB_NAME1"
echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost -p 15432 $APP_DB_NAME2"

