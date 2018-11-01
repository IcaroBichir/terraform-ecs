resource "aws_security_group" "ecs_instance" {
  name        = "ecs_instance_sg"
  description = "ECS Instance Security Group"

  ingress {
    from_port         = 1
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks       = ["10.0.0.0/16"]  
  }

  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ingress_22" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ecs_instance.id}"
}

resource "aws_security_group_rule" "ingress_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ecs_instance.id}"
}

resource "aws_instance" "ecs_instance" {
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.ecs_instance.name}"  
  security_groups             = [
    "${aws_security_group.ecs_instance.name}"
  ]
  user_data                   = "${base64encode(file("./policies/user-data.sh"))}"
  tags {
    Name = "ecs_instance"
  }
}
