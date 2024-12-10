#!/bin/bash
yum update -y
yum install httpd wget unzip -y
systemctl start httpd
systemctl enable httpd
wget https://www.free-css.com/assets/files/free-css-templates/download/page291/goind.zip
unzip goind.zip
cp -rvf html/* /var/www/html/
