data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "default-keys" {
  key_name = "default-keys"
  public_key = var.public_key
}
resource "aws_instance" "web" {
  count = var.web_server_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  user_data = file("userdata.tpl")
  subnet_id = aws_subnet.private_subnets[count.index].id
  key_name = aws_key_pair.default-keys.key_name
  security_groups = [aws_security_group.web_public.id]

  tags = {
    Name = "webserver-${count.index + 1}"
  }
}


resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_subnets[0].id
  key_name = aws_key_pair.default-keys.key_name
  security_groups = [aws_vpc.st-main-1.default_security_group_id]
  
  tags = {
    Name = "bastion-host"
  }
}

resource "aws_eip" "bastion_eip" {
    instance = aws_instance.bastion_host.id
    domain = "vpc"
}

