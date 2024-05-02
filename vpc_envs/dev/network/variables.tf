# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Santosh Aryal",
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  default     = "acs730-group2"
  description = "Name prefix"
}

variable "public_subnet_cidrs" {
  default     = ["10.100.1.0/24", "10.100.2.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

variable "private_subnet_cidrs" {
  default     = ["10.100.3.0/24", "10.100.4.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.100.0.0/16"
  type        = string
  description = "VPC to host static web site"
}

# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a","us-east-1b", "us-east-1c"] # Replace with your desired AZs
}

variable "path_to_linux_key" {
  type        = string
  default     = "/home/ec2-user/.ssh/id_rsa.pub"
  description = "url to keys"
}