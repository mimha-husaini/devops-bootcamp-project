#!/bin/bash
curl -fsSL https://get.docker.com | sh
id ssm-user &>/dev/null || useradd -m ssm-user
usermod -aG docker ssm-user
docker run -d -p 80:80 nginx
docker run -d --network host cloudflare/cloudflared:latest \
  tunnel --no-autoupdate run --token ${tunnel_token}

# --------------------------------------------------
# 2. OPTIONAL ANSIBLE INSTALL (Only runs on controller)
# --------------------------------------------------
# Terraform will replace ${install_ansible} with either "true" or "false"
if [ "${install_ansible}" = "true" ]; then
    echo "Installing Ansible Controller dependencies..."
    
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y software-properties-common curl git jq python3-pip python3-venv
    
    add-apt-repository --yes --update ppa:ansible/ansible
    apt-get install -y ansible
    pip3 install boto3 botocore
    
    echo "Ansible installation complete!"
    ansible --version
fi

echo "=== Provisioning Complete ==="