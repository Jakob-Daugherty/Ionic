#!/bin/bash 

#add universe repo 
sudo add-apt-repository universe 

#update and upgrade 
sudo apt-get update && sudo apt-get upgrade -y 

#install ddclient 
echo 
echo "<--"
echo "Installing ddclient"
echo "-->"
echo 

sudo apt-get install -y ddclient -q 

echo 
echo '<--'
echo 'Configuring ddclient for google domains'
echo '-->'
echo 

echo 
read -p 'Domain name:' domain_name
read -p 'Domain Username:' login 
read -sp 'Domain Password:' password 

echo 
echo 'Moving ddclient.conf to /etc/ddclient.conf.old'
echo 
sudo mv /etc/ddclient.conf /etc/ddclient.conf.old 

echo 
echo 'Copying ionic-ddclient.conf to /etc/ddclient.conf'
echo 
sudo cp ionic-ddclient.conf /etc/ddclient.conf 

echo 
echo 'Writing user data to /etc/ddclient.conf'
echo 
echo 'login='$login >> /etc/ddclient.conf 
echo 'password='$password >> /etc/ddclient.conf 
echo $domain_name >> /etc/ddclient.conf 

echo 
echo 'Checking config is working'
echo 
sudo ddclient -daemon=0 -debug -verbose-noquiet

echo 
echo 'Restarting ddclient'
echo 
sudo systemctl restart ddclient 

