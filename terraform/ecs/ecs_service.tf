resource "aws_ecs_service" "utopia" {
  name            = "utopia"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.pub_subnet.id, aws_subnet.pub_subnet_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_route_table_association.route_table_association,
    aws_route_table_association.route_table_association_2,
  ]
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/fargate/service/utopia"
  retention_in_days = 1
}
