#!/bin/bash

virtualenv  -p python2.7 --system-site-packages waveansible

#virtualenv  waveansible

source waveansible/bin/activate

pip install ansible
pip install boto

AWS_PROFILE=wtg ansible-playbook   playbook.yml --ask-vault-pass

echo $foobar
