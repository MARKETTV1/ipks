#!/bin/bash

# clear terminal screen
#######################################
clear >/dev/null 2>&1

# Check and install wget
#######################################
package="wget"
if ! opkg list-installed | grep -q "^$package"; then
    if [ -f /etc/apt/apt.conf ]; then
    apt-get update >/dev/null 2>&1
    apt install $package -y >/dev/null 2>&1
    else
    opkg update > /dev/null 2>&1
    opkg install $package >/dev/null 2>&1
    fi
fi

# Check script url connectivity and install ajpanel_eliesatpanel
#######################################
if wget -q --method=HEAD https://gitlab.com/eliesat/eliesatpanel/-/raw/main/eliesatpanel.sh; then
sh -c "$(wget --no-check-certificate https://gitlab.com/eliesat/eliesatpanel/-/raw/main/eliesatpanel.sh -qO -)"
else
echo "> Check your internet connection and try again ..."
fi
