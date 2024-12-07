output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.my_cluster.endpoint
}

output "security_group_id" {
  description = "The security group ID for the EKS cluster"
  value       = aws_security_group.eks_cluster_sg.id
}
