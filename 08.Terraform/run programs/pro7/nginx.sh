#!/bin/bash
apt-get update -y
apt-get install wget unzip nginx -y
systemctl start nginx
systemctl enable nginx
wget https://www.free-css.com/assets/files/free-css-templates/download/page288/digitalex.zip
unzip digitalex.zip
rm -rvf /usr/share/nginx/html/*
rm -rvf /var/www/html/*
cp -rvf digitalex-html/* /usr/share/nginx/html/
cp -rvf digitalex-html/* /var/www/html/
