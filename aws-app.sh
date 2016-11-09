#!/bin/bash

virtualenv  -p python2.7 --system-site-packages waveansible


source waveansible/bin/activate

pip -q install ansible
pip -q install boto

ansible-vault decrypt  env/secrets.yml --vault-password-file env/pass.txt

source env/secrets.yml

echo "Starting AWS setup ...."

ansible-playbook --tag aws   playbook.yml 



new_instance_ip=$(aws ec2 describe-instances --filters Name=tag:Name,Values=wsoyinka-waveapp --output text --query 'Reservations[*].Instances[*].PublicIpAddress')


## Forcefully bootstrap 16.04 LTS ami
ssh -i "./wsoyinka-opseng-challenge-key.pem" -o StrictHostKeyChecking=no  ubuntu@$new_instance_ip  "sudo apt-get -q -y update && sudo apt-get -q -y install python2.7 && sudo ln  -s /usr/bin/python2.7 /usr/bin/python" 


ansible-playbook --tag common,nginx,deploy   playbook.yml 

ansible-vault encrypt  env/secrets.yml --vault-password-file env/pass.txt

echo  "The website can be reached at:  http://$new_instance_ip"  
echo ""

echo " You can alternative view the more secure version here:" 
echo ""
echo  "http://$new_instance_ip"
