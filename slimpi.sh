#!/bin/bash

PKG_DEL="xserver-common x11-common gnome-icon-theme gnome-themes-standard penguinspuzzle desktop-base desktop-file-utils hicolor-icon-theme raspberrypi-artwork omxplayer"
PKG_ADD="git-core libnss-mdns ntpdate rpi-update"

function echo_usage {
	echo -e "\n > current usage of root partition ${1}"
	df -h /
	echo ""
}

echo -e "   slimpi v0.1!\n   ============"

echo_usage "before removal"
echo " > removing the following packages and their met reverse dependencies: ${PKG_DEL}"
apt-get -qq remove --purge ${PKG_DEL}
apt-get -qq autoremove --purge

echo_usage "after removal, before installation"
echo " > installing the following packages including their dependencies: ${PKG_ADD}"
apt-get -qq update
apt-get -qq install ${PKG_ADD}

echo_usage "after installation"

echo -e "\n > setting time..."
ntpdate -u de.pool.ntp.org 1>/dev/null 2>&1

echo -e "\n > updating firmware..."
rpi-update 1>/dev/null 2>&1

echo -e "\n > zeroing free space. this might take a while..."
TEMPFILE="/tmp/${RANDOM}"
dd if=/dev/zero of=${TEMPFILE} bs=1024 1>/dev/null 2>&1
sync; sleep 12; sync
rm ${TEMPFILE}

echo -e "\n > all done. press any key to reboot..."
read
