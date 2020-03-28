provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "mobile_arch" {
  source = "./mobile_app"
  alb_data = "${var.alb_data}"
  office_ip = "${var.ssh_ip}"
  incapsula_ip = "${var.waf_ip}"
  mobile_application_sg = "${var.mobile_application_sg}"
  mobile_server_sg = "${var.mobile_server_sg}"
  mobileinstance = "${var.mobileinstance}"
  mobile_squid = "${var.mobile_squid}"
  mobilenetwork = "${var.mobilenetwork}"
  zone = "${var.zone}"
}

