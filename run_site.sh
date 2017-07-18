#!/bin/bash
#
# This script wrapers ansible-playbook command. It validates variables and pass correct arguments.
# Usage: VENV=<path/to/virtualenv/for/ansible> && BRANCH=<github_branch> && bash ./run_site.sh
# Example: VENV=~/apps/envs/ansible && BRANCH=pretty-ui && bash ./run_site.sh
#
if [ "${VENV}" == "" ]; then
  echo "Specify VENV variable"
  exit 1
fi
if [ "$BRANCH" == "" ]; then
  echo "Specify BRANCH variable"
  exit 1
fi
source ${VENV}/bin/activate
if [ "$1" == "" ]; then
  ansible-playbook -i hosts -s --ask-sudo-pass site.yml --extra-vars "BRANCH=${BRANCH}"
else
  ansible-playbook -i hosts -s --ask-sudo-pass site.yml --extra-vars "BRANCH=${BRANCH}" --tags "$1"
fi
