

resource "aws_ecs_cluster" "dareyio_cluster" {
  name = var.ecs_cluster_name
  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.frontend_landing_page-apps.name
      }
    }
  }
}


resource "aws_cloudwatch_log_group" "frontend_landing_page-apps" {
  name = "frontend-landing-page-log-group"

}