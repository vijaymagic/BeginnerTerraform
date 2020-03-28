"aws_availability_zones"  {
    Virginia = ["eu-east-1a", "eu-east-1b", "eu-east-1c", "eu-east-1d", "eu-east-1e", "eu-east-1f"]
    Ohio = ["eu-east-2a", "eu-east-2b", "eu-east-2c"]
    California = ["us-west-1a", "us-west-1b", "us-west-1c"]
    Oregon = ["us-west-2a", "us-west-2b", "us-west-2c"]
    Mumbai = ["ap-south-1a", "ap-south-1b"]
    Seoul = ["ap-northeast-2a", "ap-northeast-2b"]
    Singapore = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
    Sydney = ["ap-southeast-2a","ap-southeast-2b","ap-southeast-2c"]
    Tokyo = ["ap-northeast-1a", "ap-northeast-1b", "ap-northeast-1c"]
    Central = ["ca-central-1a", "ca-central-1b"]
    Frankfurt = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
    Ireland = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    London = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
    Paris = [ "eu-west-3a", "eu-west-3b", "eu-west-3c"]
    São Paulo = ["sa-east-1a", "sa-east-1b" ]
}

"region" = "ap-south-1"

zone = ["ap-south-1a", "ap-south-1b" ]


"alb_data"  {
    idl_timeout = 60
    listener_port = 80
    listener_protocol = "HTTP"
    elb_action = "forward"
    listener_condition_field = "host-header"
    listener_condition_value = "Mobile.net"
    target_port = 80
    target_protocol = "HTTP"
    enable_deletion_protection = "False"
    ###########Health Check ###
    health_count = 3
    unhealth_count = 10
    timeout = 5
    interval = 10
    path = "/"
    port = 80

  }
 
"waf-ip" = ["10.1.0.0/16" ]  

"ssh_ip" = [ "10.1.11.0/24"]

"mobile_server_sg" {
    "ssh_from" = "22"
    "ssh_to" = "22"
    "protocol" = "tcp"
}

"mobile_application_sg" {
    "https_from" = "443"
    "https_to" = "443"
    "protocol" = "tcp"
    "squid_count" = "2"
    "squid_egress" = "0.0.0.0/0"
}


"mobile_squid" {
    "instancetype" = "t2.micro"
    "ami" = "ami-045dcded18c5027ea"
    "count" = "2"
    "key" = "terraform"
}

"mobilenetwork" {
    "vpc" = "vpc-6407e90d"
    "subnetcount" = 2
}


"mobileinstance" {
    "instancetype" = "t2.micro"
    "ami" = "ami-045dcded18c5027ea"
    "count" = "2"
    "key" = "terraform"
  }
