resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [ "subnet-0bff92c27ba1aa62d", "subnet-0447c2cadbfd33e5c", "subnet-0aec3c294b60639d1" ]
 }

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ip-example.arn
  }
}


resource "aws_lb_target_group" "ip-example" {
  name        = "tf-example-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "vpc-06ddcba306f80c04f"
}

output "lb_dns" {
 value = aws_lb.test.dns_name
}