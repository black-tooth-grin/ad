#!/bin/bash

#set -x

echo "updating time"

for i in {3..1};do echo -n "$i." && sleep 1; done
now=$(date +"%r")
timedatectl set-ntp true && echo "time updated to: $now"

echo "installing the required packages"; 
for i in {3..1};do echo -n "$i." && sleep 1; done
sudo dnf install -y realmd oddjob oddjob-mkhomedir sssd adcli krb5-workstation; 

echo "enabling the required services" 
for i in {3..1};do echo -n "$i." && sleep 1; done
sudo systemctl enable --now oddjobd.service;

echo "joining the AD"
for i in {3..1};do echo -n "$i." && sleep 1; done 
##realm join pdc01.lisnepal.com.np -U ldc; 
echo "Li4Nepal@22" | realm join --user ldc pdc01.lisnepal.com.np;
sleep 3;
echo "the AD that you joined is:"
realm list; 
sleep 10;

echo "Setting the Authentication via ssd"
for i in {3..1};do echo -n "$i." && sleep 1; done
sudo authselect select sssd;

echo "Setting auto Home directory creation after user authentication"
for i in {3..1};do echo -n "$i." && sleep 1; done
sudo authselect select sssd with-mkhomedir;

echo "Adding the domain suffix to usernames"
for i in {3..1};do echo -n "$i." && sleep 1; done
###sed '/^services=.*/a default_domain_suffix = pdc01.lisnepal.com.np' /etc/sssd/sssd.conf;
sed -i '6idefault_domain_suffix = pdc01.lisnepal.com.np' /etc/sssd/sssd.conf

echo "Defining home directory substring"
for i in {3..1};do echo -n "$i." && sleep 1; done
echo -e "[nss]\nhomedir_substring = /home" >> /etc/sssd/sssd.conf;

echo "Access Controlling"
for i in {3..1};do echo -n "$i." && sleep 1; done
realm deny --all;
realm permit lisadmin@pdc01.lisnepal.com.np;
realm permit -g 'SysAdmin';
sleep 5;

echo "Granting Sudo Access"
for i in {3..1};do echo -n "$i." && sleep 1; done
touch /etc/sudoers.d/domain_admins;
echo "%SysAdmin@pdc01.lisnepal.com.np ALL=(ALL)    ALL" >> /etc/sudoers.d/domain_admins;
sleep 5;

echo "AD Integrated" 
 






 

	
