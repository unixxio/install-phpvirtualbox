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
