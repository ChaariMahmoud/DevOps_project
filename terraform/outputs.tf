output "cluster_endpoint" {
  description = "L'endpoint du cluster EKS"
  value       = aws_eks_cluster.my_cluster.endpoint  # Utilisation du nom correct du cluster
}

output "cluster_name" {
  description = "Le nom du cluster EKS"
  value       = aws_eks_cluster.my_cluster.name  # Utilisation du nom correct du cluster
}

output "cluster_role_arn" {
  description = "L'ARN du rôle IAM du cluster EKS"
  value       = aws_eks_cluster.my_cluster.role_arn  # Utilisation du nom correct du cluster
}

output "cluster_security_group_id" {
  value = data.aws_eks_cluster.existing.vpc_config[0].cluster_security_group_id
}