resource "aws_ecs_cluster" "foo" {
  name = "white-hart"
}

# arn:aws:iam::901447437554:role/ecsTaskExecutionRole
resource "aws_ecs_service" "nginx-service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.foo.id
  task_definition = aws_ecs_task_definition.test.arn
  desired_count   = 1
  # iam_role        = aws_iam_role.test_role.arn
  launch_type     = "FARGATE"
  depends_on      = [aws_iam_policy.policy]
  
  network_configuration {
   subnets         = [ "subnet-0bff92c27ba1aa62d", "subnet-0447c2cadbfd33e5c", "subnet-0aec3c294b60639d1" ]
   assign_public_ip = true 
   security_groups = [aws_security_group.allow_http.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ip-example.arn
    container_name   = "nginx"
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "test" {
  family                   = "test"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.test_role.arn
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "nginx",
    "image": "public.ecr.aws/nginx/nginx:mainline-alpine3.18-perl",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ]
  }
]
TASK_DEFINITION
}