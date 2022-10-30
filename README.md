
## Setting UP Postgresql database

##use below for RHEL
you can get the right installer from 
`https://www.postgresql.org/download/linux/redhat/`

`yum install https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-redhat95-9.5-3.noarch.rpm`
/usr/pgsql-9.5/bin/postgresql95-setup initdb
systemctl enable postgresql-9.5
systemctl start postgresql-9.5

## setup for centos7


Ref: https://www.linode.com/docs/databases/postgresql/how-to-install-postgresql-relational-databases-on-centos-7/#secure-local-access

# linux user (postgres) - by default installed when insalling postgres server
* By default, `PostgreSQL` will create a Linux user named postgres to access the database software.
* sudo passwd postgres (Chnage postgres user's linux Password) - 123Next!
* 

# Login as postges user (linux)
## Creating new user (postgres) to ADMINISTER database - this time use Password 123Next 
Note that this user is distinct from the postgres Linux user. The Linux user is used to access the database, and the PostgreSQL user is used to perform administrative tasks on the databases.

* `su - postgres`
* `psql -d template1 -c "ALTER USER postgres WITH PASSWORD '123Next';"`   more info on template1 database https://www.postgresql.org/docs/9.1/manage-ag-templatedbs.html
* `psql -d template1 -c "ALTER USER postgres WITH PASSWORD '123Next';`
* 

## ON db vm open 5432 port
sudo firewall-cmd --zone=public --add-port=5432/tcp --permanent
sudo firewall-cmd --reload


# Enabling remote connection
Login as postgres user
$ su postgres

$  vi /var/lib/pgsql/9.5/data/postgresql.conf
#------------------------------------------------------------------------------
# CONNECTIONS AND AUTHENTICATION
#------------------------------------------------------------------------------
 
# - Connection Settings -
 
listen_addresses = '*'         # what IP address(es) to listen on;
                                        # comma-separated list of addresses;
                                        # defaults to 'localhost'; use '*' for all
                                        # (change requires restart)
port = 5432                             # (change requires restart)

### Add the ip of client to pg_hba.conf:wq
$ sudo vi /var/lib/pgsql/9.5/data/pg_hba.conf
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
host    all             all             .nextlabs.local        md5

NOTE: comment out the other entries.


vi /var/lib/pgsql/9.5/data/postgresql.conf

exit from postgres user

sudo systemctl start postgresql-9.5

### testing db connectivity from cc.nextlabs.local
`psql -h db.nextlabs.local -p 5432 -U postgres` should ask you password type 123Next

# install docker compose
sudo pip install docker-compose


# download latest builds from build18 apache
## Destiny artifacts
wget --user kmanimarpan --password "^1z3^Pg)" http://nxt-build18-apache.nextlabs.com:9052/release_artifacts/Destiny/8.7.0.0/44/destiny-8.7.0.0-44-201901141421-build.zip

wget --user kmanimarpan --password "^1z3^Pg)" http://nxt-build18-apache.nextlabs.com:9052/release_artifacts/Destiny/8.7.0.0/44/destiny-8.7.0.0-44-201901141421-xlib.zip

wget --user kmanimarpan --password "^1z3^Pg)" http://nxt-build18-apache.nextlabs.com:9052/release_artifacts/Destiny/8.7.0.0/44/Oauth2JWTSecret-Plugin.zip

### get customized JRE and tomcat from below path - from linux installer

wget http://nxt-build18-apache.nextlabs.com:9052/releases/Platform/8.7.0.0/44/ControlCenter-Linux-chef-8.7.0.0-44.zip --user kmanimarpan --password "^1z3^Pg)"

### download java policy controller
wget --user kmanimarpan --password "^1z3^Pg)" http://nxt-build18-apache.nextlabs.com:9052/releases/PolicyControllerJava/8.7.0.0/44/PolicyControllerJava-8.7.0.0-44.zip
