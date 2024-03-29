
resource "aws_ecs_task_definition" "revamp_service" {
  family = var.revamp_task_def_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu       = 256
  memory    = 512
  execution_role_arn = var.task_execution_role
  container_definitions = jsonencode([
    {
      name      = "revamp_frontend_landing"
      image     = var.revamp_image_name
      essential = true
      logConfiguration = { 
            logDriver = "awslogs",
            options = { 
               "awslogs-group" : "${aws_cloudwatch_log_group.frontend_landing_page-apps.name}",
               "awslogs-region": "${var.region}",
               "awslogs-stream-prefix": "ecs"
            }
         },
      portMappings = [
        {
          containerPort = var.container_port
        }
      ]
    } 
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}


resource "aws_ecs_task_definition" "mvp_service" {
  family = var.mvp_task_def_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu       = 256
  memory    = 512
  execution_role_arn = var.task_execution_role
  container_definitions = jsonencode([
    {
      name      = "mvp_frontend_landing"
      image     = var.mvp_image_name
      essential = true
      logConfiguration = { 
            logDriver = "awslogs",
            options = { 
               "awslogs-group" : "${aws_cloudwatch_log_group.frontend_landing_page-apps.name}",
               "awslogs-region": "${var.region}",
               "awslogs-stream-prefix": "ecs"
            }
         },
      portMappings = [
        {
          containerPort = var.container_port
        }
      ]
    } 
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}