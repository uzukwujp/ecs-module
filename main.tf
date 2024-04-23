module "vpc" {
  source = "./vpc"
  cidr_block = var.cidr_block
  instance_tenancy = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  tag = var.tag
}

module "eks" {
  source   =  "./eks/control_plane"
  cluster_name = "poc-cluster"
  cluster_role_name = "poc-cluster-IAM-role"
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
}

module "worker_node" {
  source = "./eks/worker_node"

  cluster_name = module.eks.cluster_name
  node_group_name = "poc-worker-nodes"
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  instance_types = ["t3.medium"]
  capacity_type = "ON_DEMAND"
  desired_size = 3
  max_size = 4
  max_unavailable = 1
  min_size = 2
  worker_node_iam_role_name = "poc-worker-node-IAM-role"
  
}

module "eks_addons" {
  source = "./eks/eks_addons"
  cluster_name = module.eks.cluster_name
  addon_name = "aws-ebs-csi-driver"
}

# module "ecs" {

#     source = "./ecs"
#     ecs_cluster_name = var.ecs_cluster_name
#     mvp_certificate_arn = var.mvp_certificate_arn
#     revamp_certificate_arn = var.revamp_certificate_arn
#     region = var.region
#     revamp_task_def_name = var.revamp_task_def_name
#     mvp_task_def_name = var.mvp_task_def_name
#     revamp_image_name = var.revamp_image_name
#     mvp_image_name = var.mvp_image_name
#     container_port = var.container_port
#     task_execution_role = var.task_execution_role
#     vpc_id = module.vpc.vpc_id
#     tag = var.tag
#     revamp-elb-name = var.revamp-elb-name
#     public_subnet_1 = module.vpc.public_subnet_1_id
#     public_subnet_2 = module.vpc.public_subnet_2_id
#     private_subnet_1 = module.vpc.private_subnet_1_id
#     private_subnet_2 = module.vpc.private_subnet_2_id
#     revamp-frontend-target-group = var.revamp-frontend-target-group
#     desired_count = var.desired_count
#     revamp-ecs-service-name = var.revamp-ecs-service-name
#     mvp-elb-name = var.mvp-elb-name
#     mvp-frontend-target-group = var.mvp-frontend-target-group
#     mvp-ecs-service-name = var.mvp-ecs-service-name
#     depends_on = [module.vpc]
  
# }