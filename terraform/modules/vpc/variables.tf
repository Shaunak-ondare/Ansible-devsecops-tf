variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.30.0/24"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.20.30.0/26"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.20.30.64/26"
}

variable "availability_zone" {
  type    = string
  default = "ap-south-1a"
}
