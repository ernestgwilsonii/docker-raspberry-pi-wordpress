###########################################################################
# WordPress and MariaDB - MySQL  (in a Docker Container) for Raspberry Pi #
#  REF: hhttps://github.com/ernestgwilsonii/docker-raspberry-pi-wordpress #
###########################################################################
# Notes:
########
# - Uses official WordPress: https://hub.docker.com/r/arm32v7/wordpress
# - Uses custom MySQL: https://github.com/ernestgwilsonii/docker-raspberry-pi-mariadb


###############################################################################
# Docker build
##############
ssh YourRaspberryPi
sudo bash
mkdir /opt/docker-compose && cd /opt/docker-compose
git clone https://github.com/ernestgwilsonii/docker-raspberry-pi-mariadb.git
cd docker-raspberry-pi-mariadb

# Download the Docker containers
docker pull arm32v7/wordpress:5.1.1-php7.3
docker pull arm32v7/wordpress:cli
docker pull ernestgwilsonii/docker-raspberry-pi-mariadb:10.1.37
docker images
#docker system prune -af
###############################################################################


###############################################################################
# First time setup #
####################
# Create the bind mount directories and copy files to the correct node based on constraints in the docker-compose!

# WordPress
# REF: https://hub.docker.com/r/arm32v7/wordpress
mkdir -p /opt/wordpress/var/www/html/wp-content/themes
mkdir -p /opt/wordpress/var/www/html/wp-content/plugins
chmod a+rw -R /opt/wordpress
chown -R 33:33 /opt/wordpress

# MySQL
# REF: https://github.com/ernestgwilsonii/docker-raspberry-pi-mariadb
mkdir -p /opt/mysql/var/lib/mysql
chmod a+rw -R /opt/mysql
chown -R 101:101 /opt/mysql

##########
# Deploy #
##########
# Deploy the stack into a Docker Swarm
docker stack deploy -c docker-compose.yml WordPress
#docker stack rm WordPress

# Verify Docker
docker ps | grep -E "ID|WordPress"
docker stack ls | grep -E "NAME|WordPress"
docker service ls | grep -E "ID|WordPress"
docker service logs -f WordPress_wordpress-server
docker service logs -f WordPress_wordpress-wpcli
docker service logs -f WordPress_wordpress-mysql

# Verify MySQL
docker exec -it $(docker ps | grep WordPress_wordpress-mysql | awk '{print $1}') bash
mysql -u root -p
CREATE DATABASE wordpress;
SHOW DATABASES;
exit
exit

# Verify WordPress
docker exec -it $(docker ps | grep WordPress_wordpress-server | awk '{print $1}') bash
grep -E "DB_"  wp-config.php
apt-get update && apt-get install -y iputils-ping telnet mariadb-client-10.1 net-tools lsof
netstat -plant
lsof | grep IPv4
ping -c 4 wordpress-mysql
mysql -h wordpress-mysql -u root -p
SHOW DATABASES;
use wordpress;
SHOW TABLES;
exit
exit
###############################################################################
