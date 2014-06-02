#!/bin/sh
# Using chef/debian-7.4

export DEBIAN_FRONTEND=noninteractive

# clear console
clear && sudo su

echo 'Provisioning in progress please wait!'

# change dir to root home
cd ~

echo 'Timezone Configuration'
echo "Europe/Bucharest" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

echo '
deb http://ftp.ro.debian.org/debian stable main contrib non-free
deb-src http://ftp.ro.debian.org/debian stable main contrib non-free

deb http://ftp.debian.org/debian/ wheezy-updates main contrib non-free
deb-src http://ftp.debian.org/debian/ wheezy-updates main contrib non-free

deb http://security.debian.org/ wheezy/updates main contrib non-free
deb-src http://security.debian.org/ wheezy/updates main contrib non-free
' > sources.list.new

mv /etc/apt/sources.list /etc/apt/sources.list.bak
mv ~/sources.list.new /etc/apt/sources.list

echo "\nStaring Update & Upgrade! Date: $(date)\n"

yes '' | apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" update

echo '\nUpgrade to latest package version\n'
yes '' | apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

echo '\nCleanup\n'
sudo apt-get autoremove --yes
sudo apt-get autoclean --yes
sudo apt-get clean --yes

echo "Modifing hosts file and hostname"
echo '10.0.0.110 development.local' >> /etc/hosts
echo 'development.local' > /etc/hostname
/etc/init.d/hostname.sh start
hostname
hostname -f

echo "Synchronizing the System Clock"
sudo apt-get install -y ntp ntpdate

echo "Installing MySQL"
echo 'mysql-server mysql-server/root_password password root' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password root' | debconf-set-selections
apt-get -y install mysql-client mysql-server

echo 'Configuring MySQL'
sudo cp /etc/mysql/my.cnf /etc/mysql/my.bkup.cnf
## Note: Since the MySQL bind-address has a tab cahracter I comment out the end line
sudo sed -i 's/bind-address/#bind-address/' /etc/mysql/my.cnf

#Grant All Priveleges to ROOT for remote access
mysql -uroot -proot -Bse "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION;"

#restart mysql
sudo /etc/init.d/mysql restart

echo 'Installing & Configuring Nginx'
#Nginx is available as a package for Debian
sudo apt-get install -y nginx
sudo /etc/init.d/nginx start

echo 'Installing PHP'
sudo apt-get install -y php5-fpm
sudo apt-cache search php5
sudo apt-get install -y php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap
sudo apt-get install -y php5-mcrypt php5-memcache php5-memcached php5-ming php5-ps php5-pspell php5-recode php5-snmp
sudo apt-get install -y php5-sqlite php5-tidy php5-xmlrpc php5-xsl memcached
sudo apt-get install -y php-apc

echo 'Configurating PHP FPM'
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php5/fpm/php.ini
sudo sed -i 's/;date.timezone =/;date.timezone ="Europe/Bucharest"/' /etc/php5/fpm/php.ini
sudo /etc/init.d/php5-fpm reload

echo 'Installing PHP FAST CGI'
sudo apt-get install -y fcgiwrap

echo 'Installing GIT'
sudo apt-get install -y git

echo 'Installing composer'
sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo 'Installing phpMyAdmin'
sudo apt-get install -y phpmyadmin

echo "----------------------------------------"
echo "Provisioning finished! Happy coding :)"
echo "----------------------------------------"
