variable "instance_type" {
#  default     = "t3.micro"
  description = "type of the ec2 instance"
  type        = string
}

# Step 8 - Add variables
variable "default_tags" {
  default = {
    "Owner" = "ACS730-Group2",
    "App"   = "Web Application",
    "Course" = "ACS730"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

# Step 8 - Add variables
variable "prefix" {
#  default     = "nonprod"
  type        = string
  description = "Name prefix"
}

variable "path_to_linux_key" {
  type        = string
  default     = "/home/ec2-user/.ssh/id_rsa.pub"
  description = "url to keys"
}