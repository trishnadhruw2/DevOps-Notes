#!/bin/bash
yum update -y
yum install nginx wget unzip -y
systemctl start nginx
systemctl enable nginx
wget https://www.free-css.com/assets/files/free-css-templates/download/page289/seotech.zip
unzip seotech.zip
rm -rvf /usr/share/nginx/html/*
cp -rvf seotech-html/* /usr/share/nginx/html/
