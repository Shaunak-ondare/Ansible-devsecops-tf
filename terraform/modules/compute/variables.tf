variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "c7i-flex.large"
}

variable "public_key" {
  type        = string
  description = "Public SSH key for the instance"
}

variable "windows_password" {
  type        = string
  description = "Password for the Windows Administrator account"
  sensitive   = true
}

variable "controller_key_name" {
  type        = string
  description = "Name of the AWS Key Pair to use for the Ansible Controller"
}
