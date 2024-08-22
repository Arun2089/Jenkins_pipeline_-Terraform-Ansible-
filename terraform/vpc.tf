module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Project_Jenkins"
  cidr = "10.0.0.0/24"

  azs             = ["ap-south-1a","ap-south-1b","ap-south-1c"]
  private_subnets = ["10.0.0.0/28"]
  public_subnets  = ["10.0.0.16/28","10.0.0.32/28"]

  enable_nat_gateway = true
  one_nat_gateway_per_az = false
  single_nat_gateway = false

  tags = {
    Terraform = "true"
    
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Project_Jenkins"
  cidr = "10.0.0.0/24"

  azs             = ["ap-south-1a","ap-south-1b","ap-south-1c"]
  private_subnets = ["10.0.0.0/28"]
  public_subnets  = ["10.0.0.16/28","10.0.0.32/28"]

  enable_nat_gateway = true
  one_nat_gateway_per_az = false
  single_nat_gateway = false

  tags = {
    Terraform = "true"
    
  }
}
