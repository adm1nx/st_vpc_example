#!/bin/bash
sudo apt update -y &&
sudo apt install -y nginx
sudo echo "You are now on webserver $(hostname)" > /var/www/html/index.html
sudo chown www-data:www-data /var/www/html/index.html
sudo systemctl restart nginx