#!/usr/bin/env bash

FILE=~/install_done

if [ ! -f $FILE ]; then




    ########## Base Install ##########
  
    echo ">>>>>> Installing software..."
    yum -y install httpd
    yum -y install mysql mysql-server
    yum -y install php php-gd php-mysql php-pdo php-mbstring php-xml php-mcrypt php-apc php-soap nano git-core php-ldap php-devel httpd-devel pcre-devel gcc make
  
    # Install drush
    yum -y install php-pear
    pear channel-discover pear.drush.org
    pear install drush/drush-5.8.0
    pear install Console_Table-1.1.5
  
    # Install APC
    pecl channel-update pecl.php.net
    printf "\n" | pecl install apc
    echo "extension=apc.so" > /etc/php.d/apc.ini



    ########## Firewall ##########
  
    # Open up firewall to allow port 80
    # See http://stackoverflow.com/questions/5984217/vagrants-port-forwarding-not-working
    # echo ">>>>>> Setting up firewall..."
    # iptables -F
    # iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    # iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    # iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
    # iptables -P INPUT DROP
    # iptables -P FORWARD DROP
    # iptables -P OUTPUT ACCEPT
    # iptables -A INPUT -i lo -j ACCEPT
    # iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    # /sbin/service iptables save
    # /sbin/service iptables restart
  
    # Alternate solution: firewall not really needed for a VM
    echo ">>>>>> Turning off firewall..."
    service iptables stop
    chkconfig iptables off



    ########## Required Files and Directories ##########
  
    echo ">>>>>> Copying drupal db and drupal file refresh bash scripts..."
    cp /vagrant/data/config_files/drupaldb                  /usr/local/bin/
#    cp /vagrant/data/config_files/drupalfiles               /usr/local/bin/
    cp /vagrant/data/config_files/perms-reset               /usr/local/bin/
    cp /vagrant/data/config_files/set_drupal_perms.sh       /usr/local/bin/
#    cp /vagrant/data/config_files/bashconfig                /usr/local/bin/
    chmod +x /usr/local/bin/drupaldb
#    chmod +x /usr/local/bin/drupalfiles
    chmod +x /usr/local/bin/perms-reset
    chmod +x /usr/local/bin/set_drupal_perms.sh
#    chmod +x /usr/local/bin/bashconfig
  
    echo ">>>>>> Adding the publish script and will run it to move files from /mnt to /var/www/html..."
    cp /vagrant/data/config_files/publish         /usr/local/bin/publish
    chmod +x /usr/local/bin/publish
    /usr/local/bin/publish -fp

    echo ">>>>>> Setting up Solr..."
    cp /vagrant/data/config_files/solrsetup         /usr/local/bin/solrsetup
    chmod +x /usr/local/bin/solrsetup
    /usr/local/bin/solrsetup 

    echo ">>>>>> Setting up Varnish..."
    cp /vagrant/data/config_files/varnishsetup        /usr/local/bin/varnishsetup
    chmod +x /usr/local/bin/varnishsetup
    /usr/local/bin/varnishsetup 
    cp /vagrant/data/config_files/default.vcl         /etc/varnish/default.vcl

    echo ">>>>>> Setting up XDebug..."
    cp /vagrant/data/config_files/xdebugsetup        /usr/local/bin/xdebugsetup
    chmod +x /usr/local/bin/xdebugsetup

# some sources say that loading xdebug can cause a performance hit, even if
# debugging is disabled.  For example:
#   http://www.frankmayer.me/blog/item/12-xdebug-disabling-vs-not-loading-it-at-all    
# So I commented this out.  Just run xdebugsetup from within the vagrant box to load
# xdebug if you'd like it on for your virtual machine.  2013-12-13, BDP.
#    /usr/local/bin/xdebugsetup 

    echo ">>>>>> Setting up CAS..."
    cp /vagrant/data/config_files/cassetup        /usr/local/bin/cassetup
    chmod +x /usr/local/bin/cassetup
    /usr/local/bin/cassetup 

    echo ">>>>>> Adding tmp directory if missing..."
    if [ ! -d "/var/www/upload_tmp_dir" ]; then
        mkdir /var/www/upload_tmp_dir
        chown -R apache:vagrant /var/www/upload_tmp_dir  
    fi
  
    echo ">>>>>> Adding files directory if missing..."
    if [ ! -d "/var/www/html/d7-generic/sites/default/files" ]; then
        mkdir /var/www/html/d7-generic/sites/default/files
        chown -R apache:vagrant /var/www/html/d7-generic/sites/default/files
    fi
    
    cp /vagrant/data/config_files/settings.php              /var/www/html/d7-generic/sites/default/
    cp /vagrant/data/config_files/htaccess                  /var/www/html/d7-generic/.htaccess
    chown -R apache:vagrant /var/www/html/d7-generic
  
    echo ">>>>>> Setting up Drush for vagrant user..."
    mkdir -p /home/vagrant/.drush
    cp -i /vagrant/data/config_files/drush-php.ini          /home/vagrant/.drush/drush-php.ini
    cp -i /vagrant/data/config_files/drushrc.php            /home/vagrant/.drush/drushrc.php
    chown -R vagrant:vagrant /home/vagrant/.drush
    su -c "drush dl registry_rebuild" vagrant

    ########## Install Environmental Config Files ##########
  
    echo ">>>>>> Copying LAMP related files..."
    cp /vagrant/data/config_files/httpd.conf        /etc/httpd/conf/
    cp /vagrant/data/config_files/network           /etc/sysconfig/
    cp /vagrant/data/config_files/my.cnf            /etc/
    cp /vagrant/data/config_files/php.ini           /etc/
    cp /vagrant/data/config_files/apc.ini           /etc/php.d/
    cp /vagrant/data/config_files/.gitconfig        /home/vagrant/

    ########## Install Memcache ##########

    # We do this after LAMP, so the memcache setup script can modify php.ini
    # alternatively, we could modify the vagrant php.ini, but we're leaving
    # that until we're sure the memcache config is happy and always desired.
    echo ">>>>>> Setting up Memcache..."
    cp /vagrant/data/config_files/memcachesetup         /usr/local/bin/memcachesetup
    chmod +x /usr/local/bin/memcachesetup
    /usr/local/bin/memcachesetup 

    ########## Apache Setup ##########
  
    # Set up Apache
    service httpd start
    chkconfig --levels 235 httpd on



    ########## MySQL Setup ##########
  
    service mysqld start
    chkconfig --levels 235 mysqld on
  
    # this line is useful when settings.php is versioned
    # echo "127.0.0.1      path.to.external.database.server" >> /etc/hosts
  
    echo ">>>>>> Configuring database..."
    mysqladmin -u root password 'dbroot123'
    mysql -u root -pdbroot123 -e "CREATE DATABASE IF NOT EXISTS d7_db CHARACTER SET utf8 COLLATE utf8_general_ci;"
    mysql -u root -pdbroot123 -e "grant all privileges on d7_db.* to d7_user@'localhost' identified by 'd7_pass';"
    mysql -u root -pdbroot123 -e "grant all privileges on d7_db.* to d7_user@'%' identified by 'd7_pass';"
  
    service mysqld restart
    
    /usr/local/bin/drupaldb -i



    ########## Inform User of Available Commands ##########
  
    echo ">>>> Your Vagrant box is now setup."
    echo ""
    echo "Additional commands are available:"
    echo ""
#    echo "$ /usr/local/bin/drupalfiles -h"
#    /usr/local/bin/drupalfiles -h
#    echo ""
    echo "$ /usr/local/bin/drupaldb -h"
    /usr/local/bin/drupaldb -h
    echo ""
    echo "$ /usr/local/bin/publish -h"
    /usr/local/bin/publish -h
    echo "$ /usr/local/bin/solrsetup -h"
    /usr/local/bin/solrsetup -h
    echo "$ /usr/local/bin/memcachesetup -h"
    /usr/local/bin/memcachesetup -h
    echo "$ /usr/local/bin/varnishsetup -h"
    /usr/local/bin/varnishsetup -h
#    echo "$ /usr/local/bin/bashconfig -h"
#    /usr/local/bin/bashconfig -h

    touch $FILE;

fi
