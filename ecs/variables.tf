

variable "ecs_cluster_name" {
    type = string
    default = "frontend-landing-page-cluster"
}

variable "revamp_task_def_name" {
    type = string
    default = "revamp_frontend_landing_page" 
}

variable "mvp_task_def_name" {
    type = string
    default = "mvp_frontend_landing_page" 
}

variable "revamp_image_name" {
    type = string
    default = "nginx:latest"  
}

variable "mvp_image_name" {
    type = string
    default = "nginx:latest" 
}

variable "container_port" {
    type = number
    default = 80
}

variable "task_execution_role" {
    type = string
}

variable "vpc_id" {

}

variable "region" {
  
}

variable "tag" {
    default = "testing"
}

variable "revamp-elb-name" {
  type = string
  default = "revamp-frontend-landing-page-elb"
  
}

variable "public_subnet_1" {
  
}

variable "public_subnet_2" {
    
}

variable "revamp-frontend-target-group" {
  type = string
  default = "revamp-frontend-landing-page"
}

variable "desired_count" {
    type = number
    default = 1
}

variable "revamp-ecs-service-name" {
    type = string
    default = "revamp-frontend-landing-page"
  
}

variable "mvp-elb-name" {
    type = string
    default = "mvp-frontend-lnding-page" 
}

variable "mvp-frontend-target-group" {
    type = string
    default = "mvp-ecs-containers" 
}

variable "mvp-ecs-service-name" {
   type = string
   default = "mvp-ecs-service"  
}

variable "private_subnet_1" {
  
}

variable "private_subnet_2" {
  
}

variable "revamp_certificate_arn" {
  
}

variable "mvp_certificate_arn" {
  
}