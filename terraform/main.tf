provider "aws" {
  region = var.aws_region
}

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}


resource "aws_internet_gateway" "igw" {
  vpc_id = vpc-096754b22a6ff0822
}

resource "aws_route_table" "public_route_table" {
  vpc_id = vpc-096754b22a6ff0822

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = vpc-096754b22a6ff0822
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = vpc-096754b22a6ff0822
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Cluster creation
resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = data.aws_iam_role.lab_role.arn
  version  = "1.30"

  vpc_config {
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  }

  depends_on = [
    aws_vpc.my_vpc,
    aws_internet_gateway.igw,
    aws_subnet.subnet1,
    aws_subnet.subnet2
  ]
}

data "aws_eks_cluster" "existing" {
  name = aws_eks_cluster.my_cluster.name
}

resource "aws_security_group_rule" "worker_port_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_eks_cluster.existing.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "worker_port_30000" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 30000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_eks_cluster.existing.vpc_config[0].cluster_security_group_id
}

resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "NodeGroup"
  node_role_arn   = data.aws_iam_role.lab_role.arn
  subnet_ids      = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_eks_cluster.my_cluster
  ]
}