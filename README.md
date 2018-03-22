# Prepare Debian 9 Stretch

This script will help you setup your freshly installed Debian server. It will:

* Set a hostname
* Set a static IP (or leave DHCP on)
* Set Google DNS resolvers (or enter your own nameservers)
* Add SSH key (optional)
* Install basic tools like `openssh-server`, `sudo`, `net-tools`, `rsync`, `curl` and `htop`
* Remove 127.0.1.1 from `/etc/hosts`
* Allow root login from SSH (make sure only you can access port 22)
* Update apt-repo
* Update debian

#### Step 1 - Download and install script

```
wget -q https://raw.githubusercontent.com/unixxio/prepare-debian-9-stretch/master/prepare_debian_9.sh
```

#### Step 2 - Execute install script

```
sudo chmod +x prepare_debian_9.sh && sudo ./prepare_debian_9.sh
```

-

# Install CSF Firewall on Debian or Ubuntu

This script will help you install CSF Firewall on Debian or Ubuntu. It will:

* Ask which ports to open (default 80/443 for HTTP and HTTPS)
* Disable testing mode
* Remove comments from `/etc/csf/csf.conf` to increase readability

#### Step 1 - Download and install script

```
wget -q https://raw.githubusercontent.com/unixxio/install-csf-debian-ubuntu/master/install_csf.sh
```

#### Step 2 - Execute install script

```
sudo chmod +x install_csf.sh && sudo ./install_csf.sh
```

#### Tested on

* Debian 8 Jessie
* Debian 9 Stretch

-

# Install PHPVirtualBox

This script will help you install PHPVirtualBox completely automated. It will:

* Install required packages
* Install apache2 webserver (optional)
* Install virtualbox
* Install phpvirtualbox
* Automatically update config files
* Create vbox user and password
* Create init script

**Important note**:

```
Please only use (or test first) on freshly installed server! This script is still work in progress.
```

#### Step 1 - Download and install script

```
wget -q https://raw.githubusercontent.com/unixxio/install-phpvirtualbox/master/install_phpvirtualbox.sh
```

#### Step 2 - Execute install script

```
sudo chmod +x install_phpvirtualbox.sh && sudo ./install_phpvirtualbox.sh
```

#### Tested on

* Debian 9 Stretch

#### Changelog (D/m/Y)

* 22/03/2018 - v1.0 - First release
