#!/bin/bash
# Copyright (c) 2017 Joji Doi
#
# Script to download Ansible and setup environment
#
# Usage: export BRANCH=<github release tag version or branch> && bash install.sh
#
if [ "${BRANCH}" == "" ]; then
  echo "[NG] export BRANCH variable"
  exit 1
fi
WORK_DIR="$(pwd)"
echo "[OK] Working directory: ${WORK_DIR}"
# If BRANCH is a tag with prefix v, remove it.
if [[ "${BRANCH}" =~ ^v[0-9].[0-9].[0-9] ]]; then
  export BANSIBLE_DIR=${WORK_DIR}/bansible-${BRANCH:1}
  echo "[OK] trimming v"
else
  export BANSIBLE_DIR=${WORK_DIR}/bansible-${BRANCH}
  echo "[OK] no trimming"
fi

echo "[OK] BRANCH : ${BRANCH}"
echo "[OK] BANSIBLE_DIR : ${BANSIBLE_DIR}"

# Remove previously installed bansible if they exists
if [ -d ${BANSIBLE_DIR} ]; then
  rm -r ${BANSIBLE_DIR}
  echo "[OK] Removed previously installed bansible"
fi

# Download bansible from the specified branch as tar.gz format and unpack the contents to ${BANSIBLE_DIR}
curl -skL https://github.com/do-i/bansible/archive/${BRANCH}.tar.gz | tar xz

# Check the download and untar was good
if [ -d ${BANSIBLE_DIR} ]; then
  echo "[OK] Download and unpack bansible"
else
  echo "[NG] Unable to install bansible"
  exit 1
fi

sudo apt install build-essential python-dev
echo "[OK] Install build-essential python-dev"
if [ -d ./envs ]; then
  rm -r ./envs
  echo "[OK] Removed previously installed virtualenv"
fi
mkdir ./envs
virtualenv ./envs/ansible
echo "[OK] Install virtualenv"
source ./envs/ansible/bin/activate
echo "[OK] Source virtualenv"
pip install ansible
pip install netaddr
echo "[OK] Pip install"
pip freeze

# Run Playbook
cd ${BANSIBLE_DIR}
echo "Enter password for raspberry pi3... hint: raspberry"
ansible-playbook -i hosts -s --ask-sudo-pass site.yml --extra-vars "BRANCH=${BRANCH}"
echo "[Ok] End of install script. Check for any errors."
