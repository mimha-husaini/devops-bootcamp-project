data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "aws_iam_instance_profile" "my_ssm_profile" {
  name = "EC2-SSM-Role"
}
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = data.aws_iam_instance_profile.my_ssm_profile.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_ssm_parameter" "token" {
  name = "/devops-bootcamp-project/tunnel-token"
}
module "my_server_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name                   = "web-server"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = module.devops_vpc.public_subnets[0]
  private_ip             = "10.0.0.5"
  create_security_group  = false
  vpc_security_group_ids = [module.devops_public_sg.id]
  iam_instance_profile   = data.aws_iam_instance_profile.my_ssm_profile.name
  key_name            = "mimha-key"
  user_data = templatefile("userdata.sh", {})
  # tags      = { Name = "tf-server-public" }
}

module "my_server_private" {
  for_each = {
    controller = {ip = "10.0.0.135", ansible = true}
    monitoring = {ip = "10.0.0.136", ansible = false}
  }

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name                 = each.key
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  subnet_id            = module.devops_vpc.private_subnets[0]
  private_ip           = each.value.ip
  create_security_group  = false
  vpc_security_group_ids = [module.devops_private_sg.id]
  iam_instance_profile = data.aws_iam_instance_profile.my_ssm_profile.name
  key_name            = "mimha-key"
  user_data = templatefile("userdata-tunnel.sh", { 
    tunnel_token = data.aws_ssm_parameter.token.value
    install_ansible = each.value.ansible})
}