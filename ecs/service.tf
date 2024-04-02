
resource "aws_security_group" "ecs_security_group" {
  name        = "revamp-frontend-landing-app"
  description = "Allow http inbound traffic from anywhere"
  vpc_id      = var.vpc_id
  tags = {
    Name = var.tag
  }
}

resource "aws_security_group_rule" "allow_http_ingress_traffic" {
  security_group_id = aws_security_group.ecs_security_group.id
  from_port         = var.container_port
  to_port           = var.container_port
  type              = "ingress"
  protocol          = "tcp"
  source_security_group_id = aws_security_group.elb_security_group.id
}

resource "aws_security_group_rule" "allow_http_egress_traffic" {
  security_group_id = aws_security_group.ecs_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
  protocol          = "-1"
}


######
#### Load balancer security group
#######

resource "aws_security_group" "elb_security_group" {
  name        = "application-load-balancer"
  description = "Allow http inbound traffic from anywhere"
  vpc_id      = var.vpc_id
  tags = {
    Name = var.tag
  }
}

resource "aws_security_group_rule" "elb_allow_http_ingress_traffic" {
  security_group_id = aws_security_group.elb_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  type              = "ingress"
  protocol          = "tcp"
}

resource "aws_security_group_rule" "elb_allow_https_ingress_traffic" {
  security_group_id = aws_security_group.elb_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
  type              = "ingress"
  protocol          = "tcp"
}

resource "aws_security_group_rule" "elb_allow_http_egress_traffic" {
  security_group_id = aws_security_group.elb_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
  protocol          = "-1"
}



resource "aws_lb" "revamp_elb" {
  name               = var.revamp-elb-name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_security_group.id]
  subnets            = ["${var.public_subnet_1}", "${var.public_subnet_2}"]

  tags = {
    Environment = var.tag
  }
}

resource "aws_lb_target_group" "revamp_ecs_containers" {
  name        = var.revamp-frontend-target-group
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
   path = "/"
   healthy_threshold = "3"
   interval = "30"
   protocol = "HTTP"
   matcher = "200"
   timeout = "3"
   unhealthy_threshold = "2"
 }
}

resource "aws_lb_listener" "revamp_frontend_landing" {
  load_balancer_arn = aws_lb.revamp_elb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.revamp_ecs_containers.arn
  }
}

resource "aws_lb_listener" "revamp_https_frontend_landing" {
  load_balancer_arn = aws_lb.revamp_elb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.revamp_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.revamp_ecs_containers.arn
  }
}

resource "aws_lb_listener_rule" "redirect_to_blog_dareyio" {
  listener_arn = aws_lb_listener.revamp_https_frontend_landing.arn

  priority = 3

  action {
    type = "redirect"
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      path        =  "/blog/mastering-remote-work-with-cloud-and-devops/blog/mastering-remote-work-with-cloud-and-devops"
      host        = "#{host}"
    }
  }

  condition {
    host_header {
      values = ["blog.darey.io"]
    }
  }

  condition {
    path_pattern {
      values = ["/blog/mastering-remote-work-with-cloud-and-devops-skills"]
    }
  }
}


resource "aws_ecs_service" "revamp_frontend_landing" {
  name            = var.revamp-ecs-service-name
  cluster         = aws_ecs_cluster.dareyio_cluster.id
  task_definition = aws_ecs_task_definition.revamp_service.arn
  desired_count   = var.desired_count
  launch_type = "FARGATE"

  network_configuration {
    subnets =  ["${var.private_subnet_1}","${var.private_subnet_2}"]
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.revamp_ecs_containers.arn
    container_name   = "revamp_frontend_landing"
    container_port   = var.container_port
  }
}


######
### Configuration for mvp service
######



resource "aws_lb" "mvp_elb" {
  name               = var.mvp-elb-name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_security_group.id]
  subnets            = ["${var.public_subnet_1}", "${var.public_subnet_2}"]

  tags = {
    Environment = var.tag
  }
}

resource "aws_lb_target_group" "mvp_ecs_containers" {
  name        = var.mvp-frontend-target-group
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
   path = "/"
   healthy_threshold = "3"
   interval = "30"
   protocol = "HTTP"
   matcher = "200"
   timeout = "3"
   unhealthy_threshold = "2"
 }
}

resource "aws_lb_listener" "mvp_frontend_landing" {
  load_balancer_arn = aws_lb.mvp_elb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mvp_ecs_containers.arn
  }
}

resource "aws_lb_listener" "mvp_frontend_https_landing" {
  load_balancer_arn = aws_lb.mvp_elb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.mvp_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mvp_ecs_containers.arn
  }
}


resource "aws_ecs_service" "mvp_frontend_landing" {
  name            = var.mvp-ecs-service-name
  cluster         = aws_ecs_cluster.dareyio_cluster.id
  task_definition = aws_ecs_task_definition.mvp_service.arn
  desired_count   = var.desired_count
  launch_type = "FARGATE"

  network_configuration {
    subnets =  ["${var.private_subnet_1}","${var.private_subnet_2}"]
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.mvp_ecs_containers.arn
    container_name   = "mvp_frontend_landing"
    container_port   = var.container_port
  }
}


