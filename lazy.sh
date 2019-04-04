#!/bin/bash

# sudo -u root mkdir -p /opt/wordpress/var/www/html/wp-content/themes
# sudo -u root mkdir -p /opt/wordpress/var/www/html/wp-content/plugins
# sudo -u root chmod a+rw -R /opt/wordpress
# sudo -u root chown -R 33:33 /opt/wordpress

sudo -u root mkdir -p /opt/mysql/var/lib/mysql
sudo -u root chmod a+rw -R /opt/mysql
sudo -u root chown -R 101:101 /opt/mysql
