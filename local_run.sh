#!/bin/bash
# Copyright (c) 2017 Joji Doi
#
# This script wrapers ansible-playbook command. It validates variables and pass correct arguments.
# Usage: export BRANCH=<github_branch> && ./run_site.sh
# Example: BRANCH=ui-v2 && ./run_site.sh bubble
#

if [ "${BRANCH}" == "" ]; then
  BRANCH=master
fi
EXTRA_VARS="BRANCH=${BRANCH}"

if [ "${SSID}" != "" ]; then
  EXTRA_VARS="${EXTRA_VARS} ssid=${SSID}"
fi

if [ "${PASS}" != "" ]; then
  EXTRA_VARS="${EXTRA_VARS} wpa_pass=${PASS}"
fi

# TODO add ip address option for dnsmasq; dynamically generate dhcp address range based on the ip
echo "==> raspberry <=="
ansible-playbook -i "localhost," --connection local -s --ask-sudo-pass site.yml --skip-tags update_upgrade_reboot --extra-vars "${EXTRA_VARS}"
