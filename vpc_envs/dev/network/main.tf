
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

resource "aws_key_pair" "linux_key" {
  key_name   = "linux_key"
  public_key = file(var.path_to_linux_key)
    tags = merge({
    Name = "${local.name_prefix}-keypair"
    },
    local.default_tags
  )
}

# Module to deploy basic networking 
module "vpc-dev" {
  source = "../../../modules/aws_network"
  #source              = "git@github.com:igeiman/aws_network.git"
  env                = var.env
  vpc_cidr           = var.vpc_cidr
  public_cidr_blocks = var.public_subnet_cidrs
  private_cidr_block = var.private_subnet_cidrs
  prefix             = local.name_prefix
  default_tags       = local.default_tags
}

# Create Amazon Linux EC2 instances in a default VPC
# resource "aws_instance" "linux_vm" {
#   count                  = length(aws_subnet.public_subnet[*].id)
#   key_name               = aws_key_pair.linux_key.key_name
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [module.linux_sg.id]
#   tags = merge({
#     Name = "${local.prefix}-LinuxServer-${count.index}"
#     },
#     local.default_tags
#   )
#   subnet_id = aws_subnet.public_subnet[count.index].id
#   availability_zone = var.availability_zones[count.index % 2 == 0 ? 0 : 1]
#   ami = "ami-0c101f26f147fa7fd"
# }

# Security Groups that allows SSH and HTTP access
# resource "aws_security_group" "private_vms_sg" {

#   name        = "private_vms_sg"
#   description = "Security group allowing HTTP traffic"
#   # Allow unlimited egress

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/24"]
#   }
  
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.public_subnet_cidrs[1]]
#   }
  
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
  
#   vpc_id = module.vpc-dev.vpc_id
# }

# Launch EC2 instances in the public subnet
# resource "aws_instance" "public_instances" {
#   count         = 1
#   ami           = "ami-0c101f26f147fa7fd"  # Replace with actual AMI ID
#   instance_type = "t2.micro"     # Choose instance type according to your needs
#   subnet_id     = module.vpc-dev.public_subnet_ids[count.index]
#   key_name      = aws_key_pair.linux_key.key_name
#   associate_public_ip_address = true
  
#   tags = {
#     Name = "public-instance-${count.index}"
#   }
# }


# Launch EC2 instances in the private subnet
# resource "aws_instance" "private_instances" {
#   count         = 2
#   ami           = "ami-0c101f26f147fa7fd"  # Replace with actual AMI ID
#   instance_type = "t2.micro"     # Choose instance type according to your needs
#   subnet_id     = module.vpc-dev.private_subnet_id[count.index]
#   key_name      = aws_key_pair.linux_key.key_name
#   security_groups             = [aws_security_group.private_vms_sg.id]
#   user_data = templatefile("${path.module}/install_httpd.sh.tpl",
#     {
#       env    = upper(var.env),
#       prefix = upper(local.prefix)
#     }
#   )

#   root_block_device {
#     encrypted = var.env == "prod" ? true : false
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = merge(local.default_tags,
#     {
#       "Name" = "dev-private-vm-${count.index + 1}"
#     }
#   )
# }