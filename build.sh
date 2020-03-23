#!/bin/bash

set -ex

if [ ${USER} != 'root' ]; then
	echo "Error : Must be run as root"
	exit 1
fi

if [ -d /vagrant ]; then
	SCRIPT_DIR=/vagrant
else
	SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
fi

export GRML_LIVE_DIR=$(mktemp -d)

git clone -b v0.34.4 --depth 1 https://github.com/grml/grml-live.git ${GRML_LIVE_DIR}

cp -r ${SCRIPT_DIR}/sheep-live/* ${GRML_LIVE_DIR}/

export GRML_FAI_CONFIG=${GRML_LIVE_DIR}/etc/grml/fai
export SCRIPTS_DIRECTORY=${GRML_LIVE_DIR}/scripts
export TEMPLATE_DIRECTORY=${GRML_LIVE_DIR}/templates

export GRML_CHROOT_DIR=${SCRIPT_DIR}/sheep-chroot
export LIVE_CONF=${SCRIPT_DIR}/sheep-live.conf

(cd ${GRML_LIVE_DIR} && ./grml-live -F -n -z)

mkdir -p ${SCRIPT_DIR}/build

cp ${GRML_LIVE_DIR}/grml/grml_cd/live/grml/grml.squashfs ${SCRIPT_DIR}/build/sheep-live.squashfs
cp $(ls ${GRML_LIVE_DIR}/grml/grml_chroot/boot/vmlinuz*) ${SCRIPT_DIR}/build/vmlinuz
cp $(ls ${GRML_LIVE_DIR}/grml/grml_chroot/boot/initrd.img*) ${SCRIPT_DIR}/build/initrd.img
