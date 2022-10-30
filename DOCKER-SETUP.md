
# Docker Manual Run Setup Guide

# Database Setup
Postgresql DATABASE : already installed in dc(ec2) host.
configured to accept remote connectivity (meaning docker container can communicate with DB)

##Creating shared storage So that Control Center and ICENET CLusters can store and share data
Before creating the Control Center and ICENet clusters, set up the shared storage to be used to store
Control Center data, particularly the log files that are generated during policy enforcement activities.
The shared storage should be set up first so that you can configure the connection between the stores
and the clusters when setting up the clusters.

in dc (EC2) machine
`sudo docker volume create docker-shared-vol`
ref: http://customer.nextlabs.com/Documentation%20Library/ControlCenter8.7/CC_InstallUpgrade_8.7.pdf
Page 49

### Creating necessary folder
docker inspect volume created in previous step to find the mount point

/var/lib/docker/volumes/docker-shared-vol/_data
create  following folders for control center

* logs
* logqueue
* work

create folders for ICENet cluster
* ICENet/Cluster/logs
* ICENet/Cluster/logqueue
* ICENet/Cluster/work

##  Downloading and configuring Control Center Management Server (docker image name : combo) 

we will use shared volume created in previous step to share certificate and log , logqueue
 
 ` docker volume inspect cc-installer`
 get the mount point of docker command using jq
 and extract the installer here

shoudl have these files

 * license.dat  
 * PolicyServer (will have cc_properties.json file whcih will be later sed during docker setup)


`-v cc-installer:/usr/local`

# run container as nextlabs user
## can load environment variables from .env file or pass manually

`sudo docker run -d  -p 443:443 --user nextlabs --entrypoint '/bin/bash' c93b5ad61b85 -c 'sleep 1d'`

# debug mode (get inside container)
`sudo docker exec -it --user nextlabs ced09751a9da  /bin/bash`

`sudo docker build -t console:v1 . --build-arg HOSTNAME="console" --build-arg DATABASE_TYPE="POSTGRES" --build-arg DB_CONNECTION_URL="postgresql://10.0.59.251:5432/ccdba" --build-arg DB_USERNAME="ccdbusera" --build-arg DB_PASSWORD="123Next"`

# create database 
on dc.serviceops.cloudaz.net
cd /home/ec2-user/destiny-docker/Dockerfiles/console

`psql -h dc.serviceops.cloudaz.net -p 5432 -U postgres -f /tmp/createdb.sql`
passsrdo: 123Next

# create elastic search cluster 
## reference https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html

`docker run --name es -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.7.0`
to check cluster health
`curl http://localhost:9200/_cluster/health?pretty`

## create index called customwer
curl -X PUT "localhost:9200/customer?pretty"
Add a new document



curl -X PUT "localhost:9200/customer/_doc/1?pretty" \
-H 'Content-Type: application/json' -d'{"name": "Mark Heath" }'

# list indices from es servfice

`curl http://172.17.0.2:9200/_cat/indices?v`

Add a new document
curl localhost:9200/customer/_search?pretty
#tutorial ref
https://markheath.net/post/exploring-elasticsearch-with-docker

# find replace in configuration folder /opt/nextlabs/PolicyServer/server/configuration
find . -type f -exec sed -i 's/e3afa20938cb/a5bc22384f79/g' {} +


# Adding ssh-agent

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa_ec2 (password 123Next!)

# latest debug options
`psql -h dc.serviceops.cloudaz.net -p 5432 -U postgres` - Drop database ccdb
`psql -h dc.serviceops.cloudaz.net -p 5432 -U postgres -f /tmp/createdb.sql` - Create database
`sudo docker-compose up -d cc es`
`sudo docker run --hostname cc -d  -p 8080:8443 --entrypoint '/bin/bash'  <<IMAGE ID>> -c 'sleep 1d'`

# Docker Networking
## use dockder legacy Link switch so that each container can talk (console and es ...)#

`sudo docker run --name es -p 9200:9200 -p 9300:9300 -d -e "discovery.type=single-node" -e "cluster.name=cc-data-cluster" docker.elastic.co/elasticsearch/elasticsearch:6.7.0`

`sudo docker run --hostname cc --link es:es --name cc -d  -p 8080:8080 --entrypoint '/bin/bash'  6e64c87293b1 -c 'sleep 1d'`

# latest
`sudo docker run --hostname dc.serviceops.cloudaz.net --link es:es --name cc -d  -p 8080:8080  <containerid>`

sudo docker run --hostname cc --link es:es --name cc -d  -p 8080:8080 

# delete all index on elastic search 
`curl -XDELETE 'http://localhost:9200/_all'`

# Latest
## start ES
sudo docker run -d --name es -p 9200:9200 -p 9300:9300 es:v1
## start CC
sudo docker run --hostname dc.serviceops.cloudaz.net --link es:es --name cc -d  -p 8080:8080  --entrypoint '/bin/bash' 1602e2022e0b -c 'sleep 1d'

### steps with volume mapping for ssl key share
sudo docker run --hostname dc.serviceops.cloudaz.net -v /home/ec2-user/destiny-docker/Dockerfiles/reverseproxy:/tmp/key --link es:es --name cc -d   -p 443:443 --entrypoint '/bin/bash' 1602e2022e0b -c 'sleep 7d'

## to start nginx reverseproxy
 sudo docker run -d -p 443:443 --link cc:cc -v /home/ec2-user/destiny-docker/Dockerfiles/reverseproxy:/tmp --entrypoint '/bin/bash' 7d6f1 -c 'sleep 1d'

# viewing cert from jks

cd /opt/nextlabs/PolicyServer/java/bin
/opt/nextlabs/PolicyServer/java/bin/keytool  -list -v -keystore /opt/nextlabs/PolicyServer/server/certificates/web-truststore.jks

make sure CN matched hostname

# delete
/opt/nextlabs/PolicyServer/java/bin/keytool  -delete -alias web -keystore /opt/nextlabs/PolicyServer/server/certificates/web-truststore.jks

# convert fullchain.pem to crt

openssl x509 -outform der -in fullchain.pem -out yourcert.crt



## LATEST

sudo docker run -d --name es -p 9200:9200 -p 9300:9300 es:v1

sudo docker run --hostname dc.serviceops.cloudaz.net --link es:es --name cc -d  -p 443:443  -v /home/ec2-user/destiny-docker/Dockerfiles/reverseproxy:/tmp/key --entrypoint '/bin/bash' 37c3d4fdc3d1 -c 'sleep 1d'


# JPC Setup

Created recordset for jpc under service ops account jpc.serviceops.cloudaz.net.

Generate sll key (using lets encrypt)
`cd ~`
`./certbot-auto certonly --standalone -d jpc.serviceops.cloudaz.net`
key is saved in /etc/letsencrypt/live/jpc.serviceops.cloudaz.net/

# Start JPC container without CC linking

from JPC Docker files directory

`sudo docker build -t jpc:v1 .`

`sudo docker run --hostname jpc.serviceops.cloudaz.net --name jpc -d  -p 443:443  -v /etc/letsencrypt/live/jpc.serviceops.cloudaz.net:/tmp/key --entrypoint '/bin/bash' 6dd4885a261c -c 'sleep 1d' `


# Enabling debugging mode

Edit /etc/docker/daemon.json, setting"debug": true. If this file does not exist, it should look like this when complete:

{
    "debug": true
}
Send a SIGHUP signal to the Docker daemon, triggering it to reload its configuration without restarting the process.

sudo kill -SIGHUP $(pidof dockerd)
(optional) To check that the configuration has been applied, check docker info. If debug is enabled, the output will show Debug Mode (server): true.

docker info | grep -i debug.*server

# CC clean build
## Steps (need to add volume mappign for certificate) 
sudo docker run --hostname dc.serviceops.cloudaz.net --link es:es --name cc -d  -p 443:443 cc:v1

## all in one line steps (including build)
sudo docker build -t cc:v1 . && sudo docker run --hostname dc.serviceops.cloudaz.net --link es:es --name cc -d  -p 443:443 -v /tmp/key:/tmp/key cc:v1

## JPC Docker RUN steps 
sudo docker run --hostname jpc.serviceops.cloudaz.net --link cc:cc --name jpc -d   -p 8080:8080 -v /tmp/key:/tmp/key jpc:v1

# --privileged
sudo docker run --hostname jpc.serviceops.cloudaz.net --privileged --name jpc  -d -p 8080:8080 -v /tmp/key:/tmp/key jpc:v1

# JPC in different host

lets encrypt cert stored in 

   /etc/letsencrypt/live/jpc.serviceops.cloudaz.net/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/jpc.serviceops.cloudaz.net/privkey.pem

# SSL stored in cc container path
/etc/letsencrypt/live/docker-cc.serviceops.cloudaz.net

# command we used to convert pem to pfx

sudo openssl pkcs12 -export -out certificate.pfx -inkey /etc/letsencrypt/live/dc.serviceops.cloudaz.net-0001/privkey.pem -in /etc/letsencrypt/live/dc.serviceops.cloudaz.net-0001/cert.pem -certfile /etc/letsencrypt/live/dc.serviceops.cloudaz.net-0001/chain.pem

# make sure you converted pem to pfx file for CC container to access


# DB container setup
image offocial imnage from postgresql:9.5

localtion of pg_hba.conf and postgresql.conf file = /var/lib/postgresql/data

Ref: https://github.com/docker-library/docs/tree/master/postgres
