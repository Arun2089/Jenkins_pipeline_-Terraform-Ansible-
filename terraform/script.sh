export public_ip_bastion=$(terraform output public_instance_ip | awk -F'"' '{print $2}') 
export private_ip_main=$(terraform output private_instance_ip | awk -F'"' '{print $2}') 

mkdir -p ~/.ssh
chmod 700 ~/.ssh
chmod 400 /var/lib/jenkins/workspace/Major_pipeline_1/terraform/Key.pem

envsubst < ssh_config > ~/.ssh/config
