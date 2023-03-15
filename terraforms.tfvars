# ------------------------------------------------------------
# Networking Settings
# ------------------------------------------------------------
aws_region             = "us-east-1"
vpc_cidr_block         = "10.123.0.0/16"
subnet1                = "us-east-1a"
subnet1_cidr_block     = "10.123.1.0/24"
dev2_subnet_az         = "us-east-1b"
dev2_subnet_cidr_block = "10.123.20.0/24"
# ------------------------------------------------------------
# EKS Cluster Settings
# ------------------------------------------------------------
cluster_name                       = "my-cluster"
cluster_version                    = "1.22"
worker_group_name                  = "my-cluster-group"
worker_group_instance_type         = ["t3.medium"]
autoscaling_group_min_size         = 1
autoscaling_group_max_size         = 3
autoscaling_group_desired_capacity = 2
# ------------------------------------------------------------
# Jenkins Settings
# ------------------------------------------------------------
jenkins_admin_user     = "admin"
jenkins_admin_password = ""