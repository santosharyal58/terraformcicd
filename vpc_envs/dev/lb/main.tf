module "dev_lb" {
  source       = "../../../modules/aws_lb"
  env          = var.env
  prefix       = var.prefix
  default_tags = var.default_tags
}
