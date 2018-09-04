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

sudo apt-get install -y ddclient -q 

echo 
echo '<--'
echo 'Configuring ddclient for google domains'
echo '-->'
echo 
read -p 'Press [ENTER] to continue: ' bob 

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
sudo ddclient -daemon=0 -debug -verbose -noquiet

echo 
echo 'Restarting ddclient'
echo 
sudo systemctl restart ddclient 


echo 
echo 'Done.'
echo 
echo 'Procede to Nginx install?'
read -p 'Press [ENTER] to continue: ' bob 

sudo apt-get install -y nginx 

echo 
echo '---------------------------------------'
echo 'altering firewall'
echo 
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'

echo 
echo 'Moving /etc/nginx/sites-available/default to default.old'
echo 
sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.old 

echo 
echo 'Copying ionic-nginx to /etc/nginx/sites-available/default'
echo 
sudo cp ionic-nginx.conf /etc/nginx/sites-available/default 
add_string="    server_name "$domain_name
add_string+=";}"
echo $add_string >> /etc/nginx/sites-available/default

echo 
echo 'Checking config'
echo 
sudo nginx -t
echo 'Press [ENTER] if all good OR' 
read -p '[ctl-C] if there is a problem:' bob 

echo 
echo 'restarting nginx'
echo 
sudo systemctl restart nginx 

echo 
echo "Installing SSL cert with Certbot"
read -p 'Press [ENTER] to continue: ' bub 

sudo add-apt-repository ppa:certbot/certbot 
sudo apt-get update 
sudo apt-get install python-certbot-nginx -y 

echo 
echo 'Running certbot, plese follow prompts '
echo 'If failed [ctl-C] to escape'
echo 
echo 
sudo certbot --nginx -d $domain_name

echo 
echo 'If Success'
read -p 'Press [ENTER] to continue: ' bub 

echo 
echo 'Checking cert renew'
echo 
sudo certbot renew --dry-run 

echo 
echo 'Installing docker and docker-compose'
read -p 'Press [ENTER] to continue: ' bub 

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
apt-cache policy docker-ce

echo 'If urls start with download.docker.com -> press [ENTER] to continue'
read -p 'else press [ctl-C]: ' bub 

echo 
echo 'Installing docker and granting permissions'
sudo apt-get install -y docker-ce 
sudo usermod -aG docker ${USER}
echo 
echo 'You may need to log back in for permissions to take affect '
read -p 'Press [ENTER] to continue: ' bob 

echo 
echo 'Installing docker-compose'
echo 
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo 
echo 'All Done'
echo 'take a look at https://'$server_name
echo 
echo 
echo '        -'
echo '       |_|'
echo '      /  \'
echo '    _/    \_'
echo '   |_|----|_|'
echo 
echo 'Quarkworks LLC'
echo 'by: Jakob Daugherty'