#!/bin/bash
yum update -y
yum install ansible* -y
hostnamectl  set-hostname ansible
useradd itadmin
echo 111 | passwd --stdin itadmin
echo 111 | passwd --stdin root
echo "itadmin  ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers
sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
echo PermitRootLogin yes >> /etc/ssh/sshd_config
systemctl restart sshd

mkdir  /home/itadmin/punepro
echo [swarm] >> /home/itadmin/punepro/inventory
echo master >> /home/itadmin/punepro/inventory
echo worker1 >> /home/itadmin/punepro/inventory
echo worker2 >> /home/itadmin/punepro/inventory
echo worker3 >> /home/itadmin/punepro/inventory
echo [swarm:vars] >> /home/itadmin/punepro/inventory
echo ansible_port=22 >> /home/itadmin/punepro/inventory
echo ansible_user=itadmin >> /home/itadmin/punepro/inventory
echo ansible_password=111 >> /home/itadmin/punepro/inventory

echo [defaults]  >> /home/itadmin/punepro/ansible.cfg
echo inventory=/home/itadmin/punepro/inventory  >> /home/itadmin/punepro/ansible.cfg
echo remote_user=itadmin  >> /home/itadmin/punepro/ansible.cfg
echo host_key_checking=false  >> /home/itadmin/punepro/ansible.cfg
echo interpreter_python = auto_silent   >> /home/itadmin/punepro/ansible.cfg
echo [privilege_escalation]  >> /home/itadmin/punepro/ansible.cfg
echo become=yes  >> /home/itadmin/punepro/ansible.cfg
echo become_user=root  >> /home/itadmin/punepro/ansible.cfg
echo become_method=sudo  >> /home/itadmin/punepro/ansible.cfg
echo become_ask_pass=false  >> /home/itadmin/punepro/ansible.cfg

chown -R  itadmin:itadmin  /home/itadmin/punepro
