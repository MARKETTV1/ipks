#!/bin/sh

clear
echo "> Start of process ..."
sleep 1
echo "> Downloading and installing libraries please wait ..."

#determine package manager
#########################################
if [ -f /etc/apt/apt.conf ]; then
   install="apt-get install -y"
   check_list_command="dpkg -l"
   update="apt-get update"
elif [ -f /etc/opkg/opkg.conf ]; then
   install="opkg install --force-reinstall --force-depends"
   check_list_command="opkg list-installed"
   update="opkg update"
else
echo "> your device is not supported"
exit 1
fi

#determine packages 
#########################################

# Check python
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")
if [ "$pyVersion" = 3 ]; then
packages=(
    "wget" "xz" "zip" "p7zip" "unrar" "bzip2" "ffmpeg" "python3-requests" "python3-pillow" "binutils" "curl"
)
else
packages=(
    "wget" "xz" "zip" "p7zip" "unrar" "bzip2" "ffmpeg" "python-requests" "python-pillow" "ar" "curl" "enigma2-plugin-extensions-opkg-tools"
)
fi

#check packages installation
#########################################
$update > /dev/null 2>&1
sleep 3
for package in "${packages[@]}"; do
if $check_list_command|grep $package ; then
echo "already installed"
sleep 1
echo
else
$install $package > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
echo "Failed to install $package"
sleep 1
echo
else
echo "$package is installed succesfully"
sleep 1
echo
fi
fi
done
echo "> End of process ..."
echo
sleep 3

wget -q "--no-check-certificate" https://gitlab.com/eliesat/extensions/-/raw/main/ajpanel/eliesatpanel.sh -O - | /bin/sh 