#!/bin/bash
MAINDB="wordpress"
PASSWDDB="wordpress"

sudo mysql -e "CREATE DATABASE ${MAINDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
sudo mysql -e "CREATE USER ${MAINDB}@'localhost' IDENTIFIED BY '${PASSWDDB}';"
sudo mysql -e "CREATE USER ${MAINDB}@'%' IDENTIFIED BY '${PASSWDDB}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'%';"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

