provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_instance" "staging" {
  ami           = "ami-"
  instance_type = "t2.micro"
  key_name      = "keys"

  provisioner "local-exec" {
      command = "echo ${aws_instance.staging.public_ip} > ip_address.txt"
    }
}

resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.staging.id
}


