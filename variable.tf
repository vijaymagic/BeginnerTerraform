variable "access_key" {
   }

variable "secret_key" {
  
}

variable "region" {
  type = "string"
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

