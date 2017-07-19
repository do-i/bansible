#!/bin/bash
#
# This script wrapers ansible-playbook command. It validates variables and pass correct arguments.
# Usage: export BRANCH=<github_branch> && ./run_site.sh
# Example: BRANCH=pretty-ui && bash ./run_site.sh
#
source ../envs/ansible/bin/activate

if [ "${BRANCH}" == "" ]; then
  BRANCH=pretty-ui
fi
EXTRA_VARS="BRANCH=${BRANCH}"

if [ "${SSID}" != "" ]; then
  EXTRA_VARS="${EXTRA_VARS} ssid=${SSID}"
fi

if [ "${PASS}" != "" ]; then
  EXTRA_VARS="${EXTRA_VARS} ssid=${PASS}"
fi

# TODO add ip address option for dnsmasq; dynamically generate dhcp address range based on the ip
if [ "$1" == "" ]; then
  ansible-playbook -i hosts -s --ask-sudo-pass site.yml --extra-vars "${EXTRA_VARS}"
else
  ansible-playbook -i hosts -s --ask-sudo-pass site.yml --extra-vars "${EXTRA_VARS}" --tags "$1"
fi
