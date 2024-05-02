locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}

provider "aws" {
  region = "us-east-1" 
}

data "terraform_remote_state" "rm_nw_state" {
  backend = "s3"
  config = {
    bucket = "acs730-group2-project"
    key    = "${var.prefix}/network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "rm_web_state" {
  backend = "s3"
  config = {
    bucket = "acs730-group2-project"
    key    = "${var.prefix}/instances/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_lb" "app_lb" {
  name               = "${var.prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.terraform_remote_state.rm_nw_state.outputs.public_subnet_ids

  enable_deletion_protection = false

  tags = merge(
    local.default_tags, {
      Name = "${var.prefix}-Load_Balancer"
    }
  )
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.prefix}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.rm_nw_state.outputs.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
  }

  tags = merge(
    local.default_tags, {
      Name = "${var.prefix}-target_group"
    }
  )
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
  
  tags = merge(
    local.default_tags, {
      Name = "${var.prefix}-lb-front_end"
    }
  )
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.prefix}-alb-sg"
  description = "Security group for ALB"
  vpc_id      =  data.terraform_remote_state.rm_nw_state.outputs.vpc_id
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.default_tags, {
      Name = "${var.prefix}-LB_security_group"
    }
  )
}


resource "aws_lb_target_group_attachment" "tg_attachment" {
  for_each         = toset(data.terraform_remote_state.rm_web_state.outputs.webserver_ids)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = each.value
}
