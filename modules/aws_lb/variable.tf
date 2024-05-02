variable "prefix" {
  description = "Prefix to prepend to resource names"
  type        = string
}

variable "env" {
  description = "Environment name (e.g., dev, prod)"
  default     = "dev"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to AWS resources"
  type        = map(string)
  default     = {}
}