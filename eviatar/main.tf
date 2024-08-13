provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "windows_instance" {
  ami           = "ami-07d9456e59793a7d5"  # Replace with the Windows AMI ID of your choice
  instance_type = "t2.micro"               # Choose the instance type
  key_name      = "terraform-kp" 

  # Attach a root EBS volume
  root_block_device {
    volume_type = "gp3"
    volume_size = 30  # Size in GB
    delete_on_termination = true
  }

  # Additional EBS volume
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_type = "gp3"
    volume_size = 50  # Size in GB
    delete_on_termination = true
  }
}

resource "aws_security_group" "allow_rdp" {
  name        = "allow_rdp"
  description = "Allow RDP traffic"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_public_ip" {
  value = aws_instance.windows_instance.public_ip
}