#!/bin/bash
yum update -y
yum install wget unzip docker -y
systemctl start docker
systemctl enable docker
mkdir /data
wget https://www.free-css.com/assets/files/free-css-templates/download/page289/bliss.zip
unzip bliss.zip
cp -rvf bliss-html/* /data/
docker run -dt --name=c1 -t -p 80:80 -v /data/:/usr/share/nginx/html/ --privileged=true nginx
docker run -dt --name=c2 -t -p 81:80 hackwithabhi/medistore
