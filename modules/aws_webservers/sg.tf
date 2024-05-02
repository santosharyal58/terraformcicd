# Security Group for Bastion VM
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "web_sg" {
#  count = var.env == "nonprod" ? 1 : 0
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.get_network_data.outputs.vpc_id
  
  ingress {
    description      = "Allow HTTP Connection"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 #   ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow SSH Connection"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 #   ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
 #   ipv6_cidr_blocks = ["::/0"]
  }
  
  tags = merge(var.default_tags,
  {
    "Name" = "${var.prefix}-SG-webserver"
  }
  )
}

# Security Group for other VMs
resource "aws_security_group" "private_vm_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.get_network_data.outputs.vpc_id

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.1.2.0/24"]
 #   ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
 #   ipv6_cidr_blocks = ["::/0"]
  }
  
  tags = merge(var.default_tags,
  {
    "Name" = "${var.prefix}-SG"
  }
  )
}