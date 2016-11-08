#!/bin/bash

virtualenv  -p python2.7 --system-site-packages waveansible

#virtualenv  waveansible

source waveansible/bin/activate

pip install ansible
pip install boto

#AWS_PROFILE=wtg ansible-playbook --tag aws   playbook.yml --ask-vault-pass
AWS_PROFILE=wtg ansible-playbook --tag aws   playbook.yml 

new_instance_id=$(aws ec2 describe-instances --filters Name=tag:Name,Values=waveapp --profile wtg --output text --query 'Reservations[*].Instances[*].PublicIpAddress')

echo $new_instance_id

ssh -i "~/.ssh/wtg-key1.pem"   ubuntu@$new_instance_id  "sudo apt-get -y update && sudo apt-get -y install python2.7" 

#AWS_PROFILE=wtg ansible-playbook --tag common,nginx,deploy   playbook.yml --ask-vault-pass
AWS_PROFILE=wtg ansible-playbook --tag common,nginx,deploy -i $new_instance_id,  playbook.yml 
