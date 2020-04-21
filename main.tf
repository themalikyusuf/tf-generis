provider "aws" {
  profile    = var.profile
  region     = var.region
}

resource "aws_instance" "staging" {
  ami           = var.amis[var.region]
  instance_type = var.instance_type
  key_name      = var.key_name

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file(var.private_key)
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apache2 -y"
    ]
  }
}

resource "aws_eip" "ip" {
  vpc = true
  instance = aws_instance.staging.id
}
