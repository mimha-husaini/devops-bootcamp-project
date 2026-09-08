module "devops_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "devops-vpc"
  cidr = "10.0.0.0/24"
  azs  = ["ap-southeast-1a"]

  public_subnets  = ["10.0.0.0/25"]
  public_subnet_tags = {
    Name = "devops-public-subnet"
  }
  private_subnets = ["10.0.0.128/25"]
  private_subnet_tags = {
    Name = "devops-private-subnet"
  }

  map_public_ip_on_launch = true
  enable_nat_gateway      = true
  single_nat_gateway      = true
}