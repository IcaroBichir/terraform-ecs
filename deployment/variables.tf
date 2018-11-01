variable "region" {
  default = "us-east-1"
}

variable "ami" {
  default = "ami-0254e5972ebcd132c"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "deployment_maximum_healthy_percent" {
  default = "200"
}

variable "deployment_minimum_healthy_percent" {
  default = "100"
}

variable "ecs_api_desired_count" {
  default = "1"
}