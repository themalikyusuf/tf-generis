provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_instance" "staging" {
  ami           = "ami-"
  instance_type = "t2.micro"
  key_name      = "abdulmalik"

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("/path/to/pem/key")
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [g
    ]
  }
}

resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.staging.id
}