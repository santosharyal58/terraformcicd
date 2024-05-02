variable "instance_type" {
  default     = "t3.micro"
  description = "type of the ec2 instance"
  type        = string
}

# Step 8 - Add variables
variable "default_tags" {
  default = {
    "Owner" = "acs730-group2",
    "App"   = "Web Application",
    "Course" = "ACS730"
    "Env"   = "Prod"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Step 8 - Add variables
variable "prefix" {
  default     = "Group2-Dev"
  type        = string
  description = "Name prefix"
}
