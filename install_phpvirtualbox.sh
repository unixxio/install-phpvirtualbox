#!/bin/bash
# more information on: https://lukascrockett.com/blog/How-to-install-phpvirtualbox-on-Debian-Stretch/

# requirements
docroot="/var/www/html"

echo -e -n "\n[ \e[92mPlease check the latest version of virtualbox on Debian on\e[39m]: [ \e[92mhttps://wiki.debian.org/VirtualBox \e[39m]"

echo -e -n "\n[ \e[92mEnter version (example: 5.1) \e[39m]: "
read version

echo -e "\n[ \e[92mYou have entered \e[39m]: [ \e[92m${version} \e[39m]"

# install webserver if needed
version_question="[ \e[92mIs this correct? \e[39m]:"
ask_version_question=`echo -e $version_question`

read -r -p "${ask_version_question} [y/N] " question_response
case "${question_response}" in
    [yY][eE][sS]|[yY])
        # do nothing
        ;;
    *)
        exit
        ;;
    *)
esac

# install webserver if needed
apache_question="\n[ \e[92mInstall apache as webserver? \e[39m]:"
ask_apache_question=`echo -e $apache_question`

read -r -p "${ask_apache_question} [y/N] " question_response
case "${question_response}" in
    [yY][eE][sS]|[yY])
        echo -e "\n[ \e[92mWaiting while apache is being installed. This may take a while ... \e[39m]"
        apt-get update > /dev/null 2>&1
        apt-get install apache2 php php-xml php-soap -y > /dev/null 2>&1
        ;;
    *)
        # do nothing
        echo ""
        ;;
    *)
esac

# install required packages
apt-get install net-tools curl sudo unzip -y > /dev/null 2>&1

# set variable for getting main ip address
ipaddr=`ifconfig | awk {'print $2'} | head -2 | tail -1`

# add apt repo
echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" > /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc
sudo apt-key add oracle_vbox_2016.asc > /dev/null 2>&1

# run apt-get update to make sure the new virtualbox repo is loaded
apt-get update > /dev/null 2>&1

# install virtualbox
echo -e "[ \e[92mWaiting while virtualbox-${version} is being installed. This may take a while ... \e[39m]"
apt-get install virtualbox-${version} -y > /dev/null 2>&1

# download virtualbox extension
echo -e "\n[ \e[92mPlease check the latest version of virtualbox extensions on \e[39m]: [ \e[92mhttp://download.virtualbox.org/virtualbox/ \e[39m]"
echo -e -n "[ \e[92mEnter latest extension version (example: 5.1.34) \e[39m]: "
read extension_version
echo -e -n "[ \e[92mEnter latest .vbox-extpack (example: Oracle_VM_VirtualBox_Extension_Pack-5.1.34-121010.vbox-extpack) \e[39m]: "
read extension_extpack
cd /usr/src/
wget -q http://download.virtualbox.org/virtualbox/${extension_version}/${extension_extpack}
vboxmanage extpack install ${extension_extpack}

# add system user for virtualbox
echo -e -n "\n[ \e[92mPlease enter a username for virtualbox (example: vbox) \e[39m]: "
read username
echo -e -n "[ \e[92mPlease enter a group for virtualbox users (example: vboxusers) \e[39m]: "
read group
groupadd ${group} > /dev/null 2>&1
useradd -d /home/${username} -m -g ${group} -s /bin/bash ${username}
echo -e "\n[ \e[92mPlease enter password for user \e[39m]: [ \e[92m${username} \e[39m]"
passwd ${username}
echo -e -n "\n[ \e[92mPlease enter password again \e[39m]: "
read -s userpasswd

# create init file
cat << EOF > /etc/init.d/vboxweb
#!/bin/bash
sudo -u ${username} vboxwebsrv &
EOF

# give init file executable rights and load in systemd
chmod +x /etc/init.d/vboxweb
update-rc.d vboxweb defaults

# download phpvirtualbox and unzip
echo -e "\n[ \e[92mWaiting while phpvirtualbox is being downloaded and installed. This may take a while ... \e[39m]"
cd /usr/src/
wget -q https://github.com/phpvirtualbox/phpvirtualbox/archive/master.zip
unzip master.zip -d /var/www/html/
rm master.zip
cd ${docroot}
mv phpvirtualbox-master phpvirtualbox

# move config.php-example to config.php
cd ${docroot}
mv phpvirtualbox/config.php-example phpvirtualbox/config.php

# set correct username and password in config.php
sed -i -e "s#'vbox'#'${username}'#g" ${docroot}/phpvirtualbox/config.php
sed -i -e "s#'pass'#'${userpasswd}'#g" ${docroot}/phpvirtualbox/config.php

# set default docroot from /var/www/html to /var/www/html/phpvirtualbox
sed -i -e "s#/var/www/html#/var/www/html/phpvirtualbox#g" /etc/apache2/sites-available/000-default.conf

# correct virtualbox version
sed -i -e "s#5.2-0#${version}-0#g" ${docroot}/phpvirtualbox/endpoints/lib/config.php

# restarting webserver
service apache2 restart > /dev/null 2>&1

# create symlinks
sudo ln -s ${docroot}/phpvirtualbox/endpoints/lib/vboxweb-5.2.wsdl ${docroot}/phpvirtualbox/endpoints/lib/vboxweb-${version}.wsdl
sudo ln -s ${docroot}/phpvirtualbox/endpoints/lib/vboxwebService-5.2.wsdl ${docroot}/phpvirtualbox/endpoints/lib/vboxwebService-${version}.wsdl

# starting vboxweb
service vboxweb start > /dev/null 2>&1

echo -e "\n[ \e[92mPHPVirtualBox \e[39m]: [ \e[92mhttp://${ipaddr}/ \e[39m]"
echo -e "[ \e[92mUsername \e[39m]: [ \e[92madmin \e[39m]"
echo -e "[ \e[92mPassword \e[39m]: [ \e[92madmin \e[39m]"
echo -e "\n[ \e[92mDON'T FORGET TO CHANGE ADMIN PASSWORD IN PHPVIRTUALBOX \e[39m]"
echo ""
exit
