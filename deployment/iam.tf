resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name  = "ecs-instance-profile"
  path  = "/"
  roles = ["${aws_iam_role.ecs_role.name}"]
}

resource "aws_iam_role_policy" "ecs_instance_role" {
  name     = "ecs_instance_role"
  policy   = "${file("policies/ecs-instance-role.json")}"
  role     = "${aws_iam_role.ecs_role.id}"
}

resource "aws_ecr_repository_policy" "ecr_permission" {
  repository  = "${aws_ecr_repository.api.name}"
  policy   = "${file("policies/ecr-permission.json")}"
}