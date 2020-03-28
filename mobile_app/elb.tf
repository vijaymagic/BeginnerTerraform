resource "aws_alb" "mobile_lb" {
  name = "Mobile-net-ALB"
  depends_on = ["aws_subnet.mobile_subnet"]
  subnets = ["${aws_subnet.mobile_subnet.*.id}"]
  security_groups = ["${aws_security_group.elb_sg.id}"]
  enable_deletion_protection = "${lookup(var.alb_data, "enable_deletion_protection")}"
  internal = "false"
  idle_timeout = "${lookup(var.alb_data, "idl_timeout")}"
  tags = "${merge(
    local.common_tags,
    map("Name", "Mobile-net-ALB")
  )}"
}

resource "aws_alb_target_group" "mobile_target_group" {
  port = "${lookup(var.alb_data, "target_port")}"
  protocol = "${lookup(var.alb_data, "target_protocol")}"
  vpc_id = "${lookup(var.mobilenetwork, "vpc")}"
  tags = "${merge(
    local.common_tags,
    map("Name", "MobileTargetGroup")
  )}"
  health_check {
    healthy_threshold = "${lookup(var.alb_data, "health_count")}"
    unhealthy_threshold = "${lookup(var.alb_data, "unhealth_count")}"
    timeout = "${lookup(var.alb_data, "timeout")}"
    interval = "${lookup(var.alb_data, "interval")}"
    path = "${lookup(var.alb_data, "path")}"
    port = "${lookup(var.alb_data, "port")}"
  }
}

resource "aws_alb_target_group" "dummy_TG" {
  name     = "MobileDummyTG"
  port = "${lookup(var.alb_data, "target_port")}"
  protocol = "${lookup(var.alb_data, "target_protocol")}"
  vpc_id = "${lookup(var.mobilenetwork, "vpc")}"
  tags = "${merge(
    local.common_tags,
    map("Name", "MobileDummyTG")
  )}"
}

resource "aws_alb_listener" "mobile_lb_listner" {
  load_balancer_arn = "${aws_alb.mobile_lb.arn}"
  port = "${lookup(var.alb_data, "listener_port")}"
  protocol = "${lookup(var.alb_data, "listener_protocol")}"
  depends_on = ["aws_alb_target_group.mobile_target_group"]
  default_action {
    target_group_arn = "${aws_alb_target_group.dummy_TG.arn}"
    type = "${lookup(var.alb_data, "elb_action")}"
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule" {
  depends_on = ["aws_alb_target_group.mobile_target_group"]
  listener_arn = "${aws_alb_listener.mobile_lb_listner.arn}"
  action {
    type = "${lookup(var.alb_data, "elb_action")}"
    target_group_arn = "${aws_alb_target_group.mobile_target_group.id}"
    } 
 condition {
   field  = "${lookup(var.alb_data, "listener_condition_field")}"
    values = ["${lookup(var.alb_data, "listener_condition_value")}"]
  }
}

resource "aws_alb_target_group_attachment" "mobile_servers_listners" {
  count = "${lookup(var.mobileinstance, "count")}"
  depends_on = ["aws_instance.mobileserver", "aws_alb_listener.mobile_lb_listner"]
  target_group_arn = "${aws_alb_target_group.mobile_target_group.arn}"
  target_id ="${aws_instance.mobileserver.*.id[count.index]}"
  port = "${lookup(var.alb_data, "target_port")}"
}