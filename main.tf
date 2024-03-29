module "vpc" {

  source = "./vpc"
  cidr_block = var.cidr_block
  instance_tenancy = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  tag = var.tag
}

module "ecs" {

    source = "./ecs"
    ecs_cluster_name = var.ecs_cluster_name
    mvp_certificate_arn = var.mvp_certificate_arn
    revamp_certificate_arn = var.revamp_certificate_arn
    region = var.region
    revamp_task_def_name = var.revamp_task_def_name
    mvp_task_def_name = var.mvp_task_def_name
    revamp_image_name = var.revamp_image_name
    mvp_image_name = var.mvp_image_name
    container_port = var.container_port
    task_execution_role = var.task_execution_role
    vpc_id = module.vpc.vpc_id
    tag = var.tag
    revamp-elb-name = var.revamp-elb-name
    public_subnet_1 = module.vpc.public_subnet_1_id
    public_subnet_2 = module.vpc.public_subnet_2_id
    private_subnet_1 = module.vpc.private_subnet_1_id
    private_subnet_2 = module.vpc.private_subnet_2_id
    revamp-frontend-target-group = var.revamp-frontend-target-group
    desired_count = var.desired_count
    revamp-ecs-service-name = var.revamp-ecs-service-name
    mvp-elb-name = var.mvp-elb-name
    mvp-frontend-target-group = var.mvp-frontend-target-group
    mvp-ecs-service-name = var.mvp-ecs-service-name
    depends_on = [module.vpc]
  
}