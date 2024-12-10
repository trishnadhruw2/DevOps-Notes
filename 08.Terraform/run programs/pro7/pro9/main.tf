## 1. Create vpc =======================================
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev-vpc"
  }
}
##Create Subnet =========================================
resource "aws_subnet" "dev-subnet" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.az}"
  tags = {
    Name = "dev-subnet"
  }
}
## create igw ============================================
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
        Name = "dev-igw"
    }
}
##Create Custom Route Table ========================================
resource "aws_route_table" "dev-route-table" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.dev-igw.id
  }

  tags = {
    Name = "dev-route-table"
  }
}
##Associate subnet with Route Table ======================================
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.dev-subnet.id
  route_table_id = aws_route_table.dev-route-table.id
}
## Create Security Group =====================================================
resource "aws_security_group" "allow-web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
      }
  ingress {
    description = "custom"
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
      }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-web"
  }
}
## Create master ======================================================================
resource "aws_instance" "master" {
  ami               = "${var.AWS_AMI}"
  instance_type     = "t2.micro"
  vpc_security_group_ids =[aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet.id
  monitoring             = false
  key_name          = "${var.pkey}"
  user_data = file("${path.module}/node.sh")
  tags = {
    Name = "master"
  }
}
## Create worker1 ======================================================================
resource "aws_instance" "worker1" {
  ami               = "${var.AWS_AMI}"
  instance_type     = "t2.micro"
  vpc_security_group_ids =[aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet.id
  monitoring             = false
  key_name          = "${var.pkey}"
  user_data = file("${path.module}/node.sh")
  tags = {
    Name = "worker1"
  }
}
## Create worker2 ======================================================================
resource "aws_instance" "worker2" {
  ami               = "${var.AWS_AMI}"
  instance_type     = "t2.micro"
  vpc_security_group_ids =[aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet.id
  monitoring             = false
  key_name          = "${var.pkey}"
  user_data = file("${path.module}/node.sh")
  tags = {
    Name = "worker2"
  }
}
## Create worker3 ======================================================================
resource "aws_instance" "worker3" {
  ami               = "${var.AWS_AMI}"
  instance_type     = "t2.micro"
  vpc_security_group_ids =[aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet.id
  monitoring             = false
  key_name          = "${var.pkey}"
  user_data = file("${path.module}/node.sh")
  tags = {
    Name = "worker3"
  }
}
## Create Ansible server ======================================================================
resource "aws_instance" "Ansible-server" {
  ami               = "${var.AWS_AMI}"
  instance_type     = "t2.micro"
  vpc_security_group_ids =[aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet.id
  monitoring             = false
  key_name          = "${var.pkey}"
  user_data = file("${path.module}/ansible.sh")
  connection {
    type     = "ssh"
    user     = "root"
    password = var.rpass
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "echo '${aws_instance.master.private_ip} master' >> /etc/hosts",
      "echo '${aws_instance.worker1.private_ip} worker1' >> /etc/hosts",
      "echo '${aws_instance.worker2.private_ip} worker2' >> /etc/hosts",
      "echo '${aws_instance.worker3.private_ip} worker3' >> /etc/hosts"
    ]
  }
  tags = {
    Name = "Ansible-server"
  }
}
