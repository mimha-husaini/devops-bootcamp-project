module "devops_public_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 6.0"

  name            = "devops-public-sg"
  use_name_prefix = false
  vpc_id          = module.devops_vpc.vpc_id

  ingress_rules = {
    http = {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
    }
    prometheus = {
      cidr_ipv4   = "10.0.0.136/32"
      ip_protocol = "tcp"
      from_port   = 9190
      to_port     = 9190
    }
    ssh = {
      cidr_ipv4   = "10.0.0.128/25"
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
    }
  }

  egress_rules = {
    all = {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "-1"
    }
  }

  tags = {
    Name = "devops-public-sg"
  }
}

module "devops_private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 6.0"

  name            = "devops-private-sg"
  use_name_prefix = false
  vpc_id          = module.devops_vpc.vpc_id

  ingress_rules = {
    ssh = {
      cidr_ipv4   = "10.0.0.128/25"
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
    }
  }

  egress_rules = {
    all = {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "-1"
    }
  }

  tags = {
    Name = "devops-private-sg"
  }
}