# 🚀 DevOps Bootcamp Final Project

**Project Name:** Nebular, Let's Fly Together!

---

## 🔗 Project Links

* **GitHub Repository:**  
  [https://github.com/mimha-husaini/devops-bootcamp-project/]

* **Web Application:**  
  [http://web.husainibrahim.com]

* **Monitoring (Grafana via Cloudflare Tunnel):**  
  [https://monitoring.husainibrahim.com]

* **Documentation (GitHub Pages):**  
  [https://mimha-husaini.github.io/devops-bootcamp-project/]

### 🏗 Terraform Structure
- providers.tf
- ec2.tf
- vpc.tf
- security.tf
- outputs.tf
- userdata-tunnel.sh *Install all prerequisites (including ansible) and write SSH Key*
- userdata.sh *Install all prerequisites and write SSH Key*

### 🤖 Ansible Structure
- playbooks
	> site.yaml
	> web-server.yaml
	> monitoring.yaml
- group_vars
	> allvars.yaml
	> cloudflare_token.yaml *manually added into ec2 to avoid git hub* *put into .gitignore*
- templates
	> docker-compose.yml.j2
	>prometheus.yml.j2

  ## 🏗 Infrastructure (Terraform)

All infrastructure is provisioned using **Terraform** in `ap-southeast-1`.

### 🌐 Network
- VPC: `10.0.0.0/24`
- Public Subnet: `10.0.0.0/25`
- Private Subnet: `10.0.0.128/25`
- Internet Gateway + NAT Gateway

### 🖥 EC2 Instances
| Role | Private IP | Access |
|----|----|----|
| Web Server | 10.0.0.5 | web.husainibrahim.com (104.21.54.141) |
| Ansible Controller | 10.0.0.135 | Private (SSM only) |
| Monitoring Server | 10.0.0.136 | Private (Cloudflare Tunnel) |

### 📝 Notes
- Terraform state stored in **S3**
- `userdata-tunnel.sh` installs Ansible and prepares inventory
- `userdata.sh` installs Docker and Node Exporter
- All servers are accessed via **AWS SSM**

## ⚙️ Configuration Management (Ansible)

All Ansible tasks are executed from the **Ansible Controller**.

### 🚀 Web Server
- Docker installed
- Application container deployed
- Node Exporter running on port `9100`

### 📈 Monitoring Server
- Docker installed
- Prometheus + Grafana deployed using Docker Compose
- Prometheus scrapes Web Server metrics
- Grafana exposed securely via **Cloudflare Tunnel**

### ⌨️ Run Ansible
- aws ssm start-session --target <ANSIBLE_CONTROLLER_INSTANCE_ID>
- create directory ansible
- create 3 subdirectory for playbooks, templates and group_vars
- playbooks got webserver.yaml, monitoring.yaml and site.yaml
- when run playbook call only site.yaml it will call both webserver.yaml & webserver.yaml
- templates directory got docker-compose.yml.j2 & prometheus.yml.j2 template that will be called by playbook yaml scripts (both monitoring and webserver YAML files)
- for centralised variables parked under group_vars:
  - allvars.yaml contains all variable used 
  - cloudflare_token.yaml only contain tunnel token to be used to connect monitoring server to cloudflare tunnel.

### Run Playbook
cd /playbooks
ansible-playbook /site.yaml