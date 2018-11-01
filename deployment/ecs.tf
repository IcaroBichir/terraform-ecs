
resource "aws_ecr_repository" "api" {
  name = "api"
}

resource "aws_ecs_cluster" "applications" {
  name = "applications"
}

resource "aws_ecs_service" "api" {
  name                               = "api"
  cluster                            = "${aws_ecs_cluster.applications.id}"
  task_definition                    = "${aws_ecs_task_definition.api.arn}"
  desired_count                      = "${var.ecs_api_desired_count}"
  launch_type                        = "EC2"
  deployment_maximum_percent         = "${var.deployment_maximum_healthy_percent}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  placement_strategy {
    type  = "spread"
    field = "instanceId" 
  }
  placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone" 
  }
  depends_on = [
    "aws_ecs_task_definition.api",
    "aws_ecs_cluster.applications",
    "aws_iam_role_policy.ecs_instance_role"
  ]
}

resource "aws_ecs_task_definition" "api" {
  family                   = "env-api"
  network_mode             = "bridge"
  container_definitions    = "${file("task-definitions/api.json")}"
}