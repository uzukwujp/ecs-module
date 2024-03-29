variable "cidr_block" {
    type = string
    default = "10.0.0.0/16" 
}

variable "instance_tenancy" {
    type = string
    default = "default" 
}

variable "enable_dns_hostnames" {
    type = bool
    default = "true"  
}

variable "tag" {
    type = string
    default = "testing"
}

variable "ecs_cluster_name" {
    type = string
    default = "frontend-landing-page-cluster" 
}

variable "enable_container_insight" {
    type = string
    default = "enabled"
}

variable "cloudwatch_log_group_name" {

    type = string
    default = "frontend-landing-page" 
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
    default = "hashicorp/http-echo"  
  
}

variable "region" {
    default = "us-east-1" 
}

variable "mvp_image_name" {
    type = string
    default = "hashicorp/http-echo"  
}

variable "container_port" {
    type = number
    default = 5678
}

variable "task_execution_role" {
    type = string
    default = "arn:aws:iam::062000045886:role/ecsTaskExecutionRole"
}

variable "revamp-elb-name" {
    type = string
    default = "revamp-frontend-landing-page-elb"
  
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

variable "mvp_certificate_arn" {

    default = "arn:aws:acm:eu-west-2:11122233341:certificate/9af4ee0f-1624-4455-ad00-878b319b948a" 
}

variable "revamp_certificate_arn" {

    default = "arn:aws:acm:eu-west-2:11122233341:certificate/de2138cd-39e3-49d4-b014-b3679793a1b3"
}