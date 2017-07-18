## Install required packages
```
sudo apt-get install build-essential python-dev
```

## Run Keygen
```
ssh-keygen
```

## Transfer rsa public key
```
cat ~/.ssh/id_rsa.pub | ssh pi@pi3 "mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys"
```

## Run setup
Note: This script will be donwloaded from github on a fly
```
bash setup.sh
```

## Run Playbook
Note: VENV and BRANCH variable must be set with correct values
```
VENV=~/apps/envs/ansible && BRANCH=pretty-ui && bash ./run_site.sh
```
