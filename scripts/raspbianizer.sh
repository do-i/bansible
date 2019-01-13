#!/bin/bash
# Copyright (c) 2019 Joji Doi
#
# Create raspbian image on sdcard

function find_partition_count_linux() {
  ### Check if the device name ends with a digit (partition number).
  if [[ ${DEVICE_NAME} =~ [0-9]$ ]]; then
    echo "Do not specify device partition. ${DEVICE_NAME}"
    exit 1
  fi
  CNT=$(sudo fdisk -l | grep ${DEVICE_NAME} | wc -l)
}

function find_partition_count_mac() {
  ### Check if the device name ends with a digit (partition number).
  if [[ ${DEVICE_NAME} =~ ^/dev/disk[2-9]$ ]]; then
    echo "Device name seems valid."
  else
    echo "Bad device name. ${DEVICE_NAME}"
    exit 1
  fi
  CNT=$(diskutil list ${DEVICE_NAME} | grep -e [0-9]: | wc -l)
}

function check_device_status() {
  if [ ${CNT} -eq 0 ]; then
    echo "Specified device ${DEVICE_NAME} does not exist. Please specify the device path to your sdcard."
    exit 1
  else
    echo "Valid Device ${DEVICE_NAME} Recognized."
  fi
}

function delete_partitions_mac() {
  if [ ${CNT} -gt 1 ]; then
    echo "Partition(s) found. They will be wiped out."
    diskutil eraseDisk JHFS+ Bubble ${DEVICE_NAME}
  fi
  diskutil unmountDisk ${DEVICE_NAME}
}

function delete_partitions_linux() {
  if [ ${CNT} -gt 1 ]; then
    echo "Partition(s) found. They will be wiped out."
    for i in $(parted -s ${DEVICE_NAME} print | awk '/^ / {print $1}'); do
      sudo parted -s ${DEVICE_NAME} rm ${i} > /dev/null 2>&1
    done
  fi
}

function copy_image_to_device() {
  echo "Copying ${RASPBIAN} to ${DEVICE_NAME}... takes about 18 minutes. Take a quick nap."
  unzip -p ${RASPBIAN} | sudo dd of=${DEVICE_NAME} bs=4194304 conv=fsync
  echo "Sync in progress... do not touch nothing... takes about 7 to 8 minutes. Kick back and relax."
  sync
}

function create_ssh_wpa_files() {
  local BUBBLE=/tmp/bubble
  local BOOT_MNT=${DEVICE_NAME}1
  sudo mkdir -p ${BUBBLE}
  sudo mount ${BOOT_MNT} ${BUBBLE}
  sudo touch ${BUBBLE}/ssh
  if [ -f ${BUBBLE}/ssh ]; then
    echo "Enable sshd"
  else
    echo "Failed to create ssh file in boot partition."
    exit 1
  fi
  sudo tee /tmp/bubble/wpa_supplicant.conf &>/dev/null<<EOF
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=US

network={
	ssid="${WIFI_SSID}"
	psk="${WIFI_PASS}"
  key_mgmt=WPA-PSK
}
EOF
  sudo tee /tmp/bubble/interfaces &>/dev/null<<EOF
auto lo
iface lo inet loopback

allow-hotplug wlan0
iface wlan0 inet manual
    wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
EOF
  sudo umount ${BOOT_MNT}
}

### End of functions

DEVICE_NAME="${1}"
RASPBIAN="${2}"
OS=$(uname)

## check if the ${DEVICE_NAME} exists
if [ "${DEVICE_NAME}" == "" ] || [ "${RASPBIAN}" == "" ]; then
  echo "Usage: ${0} <DEVICE_NAME> <RASPBIAN_ZIP>"
  echo "Example: ${0} /dev/sdx ~/tmps/2018-11-13-raspbian-stretch-lite.zip"
  exit 1
fi
if [ ! -f "${RASPBIAN}" ]; then
  echo "${RASPBIAN} is not a valid file"
  exit 1
fi
echo "DEVICE_NAME: ${DEVICE_NAME}"
echo "RASPBIAN:    ${RASPBIAN}"


if [ "${OS}" == "Darwin" ]; then
  find_partition_count_mac && check_device_status && delete_partitions_mac
elif [ "${OS}" == "Linux" ]; then
  find_partition_count_linux && check_device_status && delete_partitions_linux
else
  echo "This is unsupported OS"
  exit 1
fi

## TODO check return status code from the previous command.
copy_image_to_device && create_ssh_wpa_files \
  && echo "Script completed. Check for errors in case there is any." \
  && exit 0

echo "[Error] There was an error. Check the error log."
exit 1
