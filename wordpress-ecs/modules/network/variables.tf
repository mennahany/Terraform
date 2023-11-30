variable "aws_region" {
 type        = string
 description = "aws region it deploys to"
}

variable "vpc_name" {
 type        = string
 description = "The VPC name"
}

variable "vpc_cidr" {
 type        = string
 description = "VPC CIDR value"
 default     = "10.40.0.0/16"
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
}

variable "igw_name" {
 type        = string
 description = "Internet gateway name"
}

