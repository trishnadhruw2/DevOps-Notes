#!/bin/bash
yum update -y
yum install httpd wget unzip -y
systemctl start httpd
systemctl enable httpd
wget https://www.free-css.com/assets/files/free-css-templates/download/page289/bluene.zip
unzip bluene.zip
cp -rvf bluene-html/* /var/www/html/ 
