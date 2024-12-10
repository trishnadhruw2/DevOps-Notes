#!/bin/bash
yum update -y
yum install httpd wget unzip -y
systemctl start httpd
systemctl enable httpd
wget https://www.free-css.com/assets/files/free-css-templates/download/page294/digian.zip
unzip digian.zip
cp -rvf digian-html/* /var/www/html/
