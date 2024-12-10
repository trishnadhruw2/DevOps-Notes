#!/bin/bash
yum update -y
yum install httpd wget unzip -y
systemctl start httpd
systemctl enable httpd
wget https://www.free-css.com/assets/files/free-css-templates/download/page290/restoran.zip
unzip restoran.zip
cp -rvf bootstrap-restaurant-template/* /var/www/html/
