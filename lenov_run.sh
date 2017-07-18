#!/bin/bash
source ~/tmps/zansible/envs/ansible/bin/activate
export ANSIBLE_CONFIG_DIR=~/tmps/zansible/raspbian-jessie
export BRANCH=pretty-ui
cd ${ANSIBLE_CONFIG_DIR}
if [ "$1" == "" ]; then
  ansible-playbook -i hosts -s --ask-sudo-pass site.yml --extra-vars "BRANCH=${BRANCH}"
else
  ansible-playbook -i hosts -s --ask-sudo-pass site.yml --extra-vars "BRANCH=${BRANCH}" --tags "$1"
fi
