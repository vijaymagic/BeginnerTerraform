resource "aws_instance" "mobileserver" {
  count = "${lookup(var.mobileinstance, "count")}"
  instance_type ="${lookup(var.mobileinstance, "instancetype")}"
  ami = "${lookup(var.mobileinstance, "ami")}"
  key_name = "${lookup(var.mobileinstance, "key")}"
  monitoring = "false"
  vpc_security_group_ids = ["${aws_security_group.mobile_common_sg.id}"]
  subnet_id = "${aws_subnet.mobile_subnet.*.id[count.index]}"
    volume_tags = "${merge(
    local.common_tags
   )}"
  tags = "${merge(
    local.common_tags,
    map("Name", "Mobile.net-${count.index+1}")
   )}"
}       


resource "aws_instance" "mobile_squid" {
  count = "${lookup(var.mobile_squid, "count")}"
  depends_on =["aws_security_group.mobile_squid_sg"]
  instance_type = "${lookup(var.mobile_squid, "instancetype")}"
  ami = "${lookup(var.mobile_squid, "ami")}"
  key_name = "${lookup(var.mobile_squid, "key")}"
  monitoring = "false"
  vpc_security_group_ids = ["${aws_security_group.mobile_squid_sg.id}"]
  subnet_id = "${aws_subnet.mobile_subnet.*.id[count.index]}"
  volume_tags = "${merge(
    local.common_tags
    )}"
  tags = "${merge(
    local.common_tags,
    map("Name", "Mobile_squid-${count.index+1}")
  )}"
  
}