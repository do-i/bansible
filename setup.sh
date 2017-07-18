#!/bin/bash
#
# Script to download Ansible and setup Environment
#

# TODO set WORK_DIR
sudo apt install build-essential python-dev
echo "Working directory. $(pwd)"
echo "Install virtualenv: [START]"
mkdir -p ./envs
virtualenv ./envs/ansible
echo "Install virtualenv: [COMPLETE]"
echo "Source virtualenv: [START]"
source ./envs/bin/activate
echo "Source virtualenv: [COMPLETE]"
echo "Pip install: [START]"
pip install ansible
echo "Pip install: [COMPLETE]"
# TODO download ansible config from repo
echo "All done. Check for any errors."
