
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "profile" {
  default = ""
}

variable "region" {
  default = "us-east-1"
}
