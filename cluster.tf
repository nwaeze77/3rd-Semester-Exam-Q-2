module "my-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.28.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  vpc_id          = aws_vpc.my-vpc.id


  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = var.worker_group_instance_type

    attach_cluster_primary_security_group = false
    vpc_security_group_ids                = [aws_security_group.allow-traffic.id]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = var.autoscaling_group_min_size
      max_size     = var.autoscaling_group_max_size
      desired_size = var.autoscaling_group_desired_capacity

      instance_types = var.worker_group_instance_type
      capacity_type  = "SPOT"
      labels = {
        Environment = "dev"
      }
    }
  }
}
