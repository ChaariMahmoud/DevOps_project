variable "vpc_id" {
  description = "The ID of the VPC to use"
  type        = string
  default     = "vpc-02f112e29d520c472"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "mykubernetes"
}
