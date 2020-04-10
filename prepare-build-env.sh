#!/bin/bash

set -ex

if [ ${USER} != 'root' ]; then
	echo "Error : Must be run as root"
	exit 1
fi

sudo apt update
sudo apt install -y git fai-client debootstrap mtools squashfs-tools
