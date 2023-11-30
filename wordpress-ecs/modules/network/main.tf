provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_name
    }  
}

resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.vpc.id
 cidr_block        = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}
 
resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnet_cidrs)
 vpc_id            = aws_vpc.vpc.id
 cidr_block        = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.vpc.id
 
 tags = {
   Name = var.igw_name
 }
}

resource "aws_route_table" "public_rt" {
 vpc_id = aws_vpc.vpc.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = {
   Name = "Public Route Table"
 }
}

resource "aws_route_table_association" "public_subnet_asso" {
 count          = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_IPs" {
   count   = length(var.public_subnet_cidrs)
   domain  = "vpc"
   
   tags = {
        Name = "NAT IP ${count.index + 1}"
    }
}

resource "aws_nat_gateway" "nat_gw" {
   count         = length(var.public_subnet_cidrs)
   allocation_id = element(aws_eip.nat_IPs[*].id, count.index)
   subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)
   tags = {
        Name = "NAT ${count.index + 1}"
    }
}

resource "aws_route_table" "private_rt" {
 count  = length(var.public_subnet_cidrs)     
 vpc_id = aws_vpc.vpc.id 

 route {
   cidr_block = "0.0.0.0/0"             
   nat_gateway_id = element(aws_nat_gateway.nat_gw[*].id , count.index)
   }

 tags = {
   Name = "Private Route Table ${count.index + 1}"
    
  }
}

resource "aws_route_table_association" "private_subnet_asso" {
 count          = length(var.private_subnet_cidrs)
 subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
 route_table_id = element(aws_route_table.private_rt[*].id, count.index)
}

