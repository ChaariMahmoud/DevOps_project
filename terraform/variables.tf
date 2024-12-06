variable "aws_region" {
  description = "La région AWS"
  type        = string
  default     = "us-east-1" # Région mise à jour
}

variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
  default     = "KuberCluster" # Nom du cluster mis à jour
}


variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}