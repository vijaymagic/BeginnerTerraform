locals {
  common_tags = {
    product = "Mobile"
    environment = "staging"
    stack = "Application"
    usecase = "MobileStaging"
    tier = "Userinterface"
    compliance = "nonpci"
    service = "MobileUI"
    name = "Mobile.in.net"
    Monitoring = "True"
    iac = "Mobile-infra-1"
    patchupgrade = "true"
    }
}

 locals {
  mobileserver_ip = "${formatlist("%s/32", aws_instance.mobileserver.*.private_ip)}"
  squid_ip = "${formatlist("%s/32", aws_instance.mobile_squid.*.private_ip)}"
 }
 
variable "alb_data" { 
  type = "map"
 }

variable "waf_ip" {
  type = "list"
 }

variable "ssh_ip" {
  type = "list"
}

variable "mobile_server_sg" {
   type = "map"
}

variable "mobile_application_sg" {
  type = "map"
}

variable "mobile_squid" {
  type = "map"
}

variable "mobilenetwork" {
  type = "map"
}

variable "zone" {
  type = "list"
}


variable "mobileinstance" {
  type = "map"
}