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

data "aws_ssm_parameter" "token" {
  name = "/devops-bootcamp-2026/tunnel-token"
}
module "my_server_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name                   = "web-server"
  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t3.micro"
  subnet_id              = module.devops_vpc.public_subnets[0]
  private_ip             = "10.0.0.5"
  create_security_group  = false
  vpc_security_group_ids = [module.devops_sg_sg.id]
  iam_instance_profile   = data.aws_iam_instance_profile.my_ssm_profile.name

  user_data = templatefile("userdata.sh", {})
 # tags      = { Name = "tf-server-public" }
}

module "my_server_private" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name                 = "controller"
  ami                  = data.aws_ami.my_ami.id
  instance_type        = "t3.micro"
  subnet_id            = module.devops_vpc.private_subnets[0]
  private_ip           = "10.0.0.135"
  iam_instance_profile = data.aws_iam_instance_profile.my_ssm_profile.name

  user_data = templatefile("userdata-tunnel.sh", { tunnel_token = data.aws_ssm_parameter.token.value })
 # tags      = { Name = "tf-server-public" }
}

module "my_server_private" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name                 = "monitoring"
  ami                  = data.aws_ami.my_ami.id
  instance_type        = "t3.micro"
  subnet_id            =  module.devops_vpc.private_subnets[0]
  private_ip           = "10.0.0.136"
  iam_instance_profile = data.aws_iam_instance_profile.my_ssm_profile.name

  user_data = templatefile("userdata-tunnel.sh", { tunnel_token = data.aws_ssm_parameter.token.value })
 # tags      = { Name = "tf-server-public" }
}