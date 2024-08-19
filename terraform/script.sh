export public_ip_bastion=$(terraform output public_instance_ip | awk -F'"' '{print $2}') 
export private_ip_main=$(terraform output private_instance_ip | awk -F'"' '{print $2}') 
export pwd_path=$(pwd)
mkdir -p ~/.ssh
chmod 700 ~/.ssh
  echo "Host public_instance" > ~/.ssh/config
  echo "  HostName $public_ip_bastion" >> ~/.ssh/config
  echo "  Port 22" >> ~/.ssh/config
  echo "  User ubuntu" >> ~/.ssh/config
  echo "  IdentityFile $pwd_path/Key.pem" >> ~/.ssh/config
  echo " " >> ~/.ssh/config
  echo "Host private_instance" >> ~/.ssh/config
  echo "  HostName $private_ip_main" >> ~/.ssh/config
  echo "  User ubuntu" >> ~/.ssh/config
  echo "  IdentityFile $pwd_path/Key.pem" >> ~/.ssh/config
  echo "  ProxyJump public_instance" >> ~/.ssh/config
