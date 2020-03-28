data "aws_vpc" "parent" {id = "${lookup(var.mobilenetwork, "vpc")}"}


resource "aws_subnet" "mobile_subnet" {
  count = "${lookup(var.mobilenetwork, "subnetcount")}"
  vpc_id = "${lookup(var.mobilenetwork, "vpc")}"
  availability_zone = "${var.zone[count.index%2]}"
  cidr_block = "${cidrsubnet(data.aws_vpc.parent.cidr_block,8,count.index+33)}"
  tags = "${merge(
    local.common_tags,
    map("Name", "Mobile.net-${var.zone[count.index%2]}")
  )}"
}

##########################################################################################

resource "aws_security_group" "mobile_common_sg" {
      description = "Mobile Server SSH and SQUID access"
      vpc_id = "${data.aws_vpc.parent.id}"

      ingress {
        from_port = "${lookup(var.mobile_server_sg, "ssh_from")}"
        to_port =  "${lookup(var.mobile_server_sg, "ssh_to")}"
        protocol =  "${lookup(var.mobile_server_sg, "protocol")}"
        cidr_blocks = ["${var.ssh_ip}"]
              }
      ingress {
        from_port =  "${lookup(var.mobile_application_sg, "https_from")}"
        to_port = "${lookup(var.mobile_application_sg, "https_to")}"
        protocol = "${lookup(var.mobile_application_sg, "protocol")}"
        cidr_blocks = ["${var.waf_ip}"]
       
      } 
  tags = "${merge(
    local.common_tags,
    map("Name" , "Mobile.net_COMMON_SG")
    )}"
}

resource "aws_security_group_rule" "allow_squid" {
      type = "egress"
      depends_on = ["aws_instance.mobile_squid"]
      from_port =  "${lookup(var.mobile_application_sg, "https_from")}"
      to_port =  "${lookup(var.mobile_application_sg, "https_from")}"
      protocol =  "${lookup(var.mobile_application_sg, "protocol")}"
      cidr_blocks = [ "${local.squid_ip}"]
      security_group_id = "${aws_security_group.mobile_common_sg.id}"
      description = "Squid IP"
}

##########################################################################################


resource "aws_security_group" "elb_sg" {
  vpc_id = "${data.aws_vpc.parent.id}"
  ingress {
    from_port =  "${lookup(var.mobile_application_sg, "https_from")}"
    to_port = "${lookup(var.mobile_application_sg, "https_to")}"
    protocol = "${lookup(var.mobile_application_sg, "protocol")}"
    cidr_blocks = ["${var.waf_ip}"]
  
    }  
  tags = "${merge(
    local.common_tags,
    map("Name", "Mobile.net_ELB_SG")
  )}"
  
}

resource "aws_security_group_rule" "ALB_allow_Mobile_server" {
  type = "egress"
  description = "ALB oubound to Mobile Server"
  depends_on = ["aws_instance.mobileserver", "aws_security_group.elb_sg"]
  from_port =  "${lookup(var.mobile_application_sg, "https_from")}"
  to_port =  "${lookup(var.mobile_application_sg, "https_from")}"
  protocol =  "${lookup(var.mobile_application_sg, "protocol")}"
  cidr_blocks = ["${local.mobileserver_ip}"]
  security_group_id = "${aws_security_group.elb_sg.id}"
  description = "Mobile_Server_IP"
}

##############################################################################################
resource "aws_security_group" "mobile_squid_sg" {
  description = "Squid Server Security Group"
  depends_on = ["aws_instance.mobileserver"]
    ingress {
        from_port = "${lookup(var.mobile_server_sg, "ssh_from")}"
        to_port =  "${lookup(var.mobile_server_sg, "ssh_to")}"
        protocol =  "${lookup(var.mobile_server_sg, "protocol")}"
        cidr_blocks = ["${var.ssh_ip}"]        
      }
    ingress {
        from_port = "${lookup(var.mobile_application_sg, "https_from")}"
        to_port =  "${lookup(var.mobile_application_sg, "https_to")}"
        protocol =  "${lookup(var.mobile_application_sg, "protocol")}"
        cidr_blocks = ["${local.mobileserver_ip}"]        
        description = "Mobile Server Access"
      }
    egress {
      from_port =  "${lookup(var.mobile_application_sg, "https_from")}"
      to_port =  "${lookup(var.mobile_application_sg, "https_from")}"
      protocol =  "${lookup(var.mobile_server_sg, "protocol")}"
      cidr_blocks = ["${lookup(var.mobile_application_sg, "squid_egress")}"]
      description = "Squid Global Access"

    }
    tags = "${merge(
    local.common_tags,
    map("Name", "Mobile_Squid_SG")
  )}"
  
}