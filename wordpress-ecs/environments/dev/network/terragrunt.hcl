terraform {
  source = "../../../modules/network/"
}

inputs = {
  aws_region           = "us-east-1"
  azs                  = ["us-east-1a"]
  vpc_name             = "Dev-VPC"
  igw_name             = "Dev-IGW"
  public_subnet_cidrs  = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.4.0/24"]


}