
# Retrieve global variables from the Terraform module
module "globalvars"{
  source = "../../../modules/globalvars"
}

# Define tags locally
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

# Module to deploy basic networking 
module "vpc-prod" {
  source = "../../../modules/aws_network"
  #source              = "git@github.com:igeiman/aws_network.git"
  env                = var.env
  vpc_cidr           = var.vpc_cidr
  public_cidr_blocks = var.public_subnet_cidrs
  private_cidr_block = var.private_subnet_cidrs
  prefix             = local.name_prefix
  default_tags       = local.default_tags
}

resource "aws_key_pair" "linux_prod_key" {
  key_name   = "linux_prod_key"
  public_key = file(var.path_to_linux_key)
    tags = merge({
    Name = "${local.name_prefix}-keypair"
    },
    local.default_tags
  )
}

# Security Groups that allows SSH and HTTP access
resource "aws_security_group" "prod_private_vms_sg" {

  name        = "private_vms_sg"
  description = "Security group allowing HTTP traffic"
  # Allow unlimited egress

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidrs[1]]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/24"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["10.1.2.0/24"]
    # bastion cidr added
    ipv6_cidr_blocks = ["::/0"]
  }
  
  vpc_id = module.vpc-prod.vpc_id
}

# Launch EC2 instances in the private subnet
resource "aws_instance" "private_instances" {
  count         = 2
  ami           = "ami-0c101f26f147fa7fd"  # Replace with actual AMI ID
  instance_type = "t2.micro"     # Choose instance type according to your needs
  subnet_id     = module.vpc-prod.private_subnet_id[count.index]
  security_groups             = [aws_security_group.prod_private_vms_sg.id]
  key_name      = aws_key_pair.linux_prod_key.key_name
  tags = {
    Name = "prod-private-vm-${count.index + 1}"
  }
}