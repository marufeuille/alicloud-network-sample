variable "access_key" {}
variable "secret_key" {}
variable "publickey" {}
variable "dest-domains" {}
variable "ecs-password" {
  default = "Test1234!"
}
variable "region-a" {
  default = "ap-northeast-1"
}
variable "region-b" {
  default = "ap-northeast-1"
}
variable "cen_name" {
  default = "cen-sample"
}
variable "cen_description" {
  default = "created by tf"
}
variable "vpc_name_region-a" {
  default = "vpc-a"
}
variable "vpc_cidr_region-a" {
  default = "192.168.0.0/16"
}
variable "vsw_cidr_region-a" {
  default = "192.168.10.0/24"
}
variable "vpc_name_region-b" {
  default = "vpc-b"
}
variable "vpc_cidr_region-b" {
  default = "192.168.0.0/16"
}
variable "vsw_cidr_region-b" {
  default = "192.168.20.0/24"
}
variable "vpn_gateway_name" {
  default = "vpn-gateway"
}
variable "vpn_gateway_description" {
  default = "created by tf"
}
variable "ssl_vpn_server_name" {
  default = "ssl-server"
}
variable "client_ip_pool" {
  default = "192.168.30.0/24"
}
variable "ssl_vpn_client_cert_name" {
  default = "sample-cert"
}

variable "zone_region-a" {
  default = "ap-northeast-1a"
}
variable "zone_region-b" {
  default = "ap-northeast-1b"
}
variable "instance_type_region-a" {
  default = "ecs.n4.small"
}
variable "instance_name_region-a" {
  default = "terraform-ecs-a"
}
variable "host_name_region-a" {
  default = "proxy-ecs-a"
}
variable "instance_type_region-b" {
  default = "ecs.n4.small"
}
variable "instance_name_region-b" {
  default = "terraform-ecs-b"
}
variable "host_name_region-b" {
  default = "proxy-ecs-b"
}
variable "log_project_name-a" {
  default = "log-project-a"
}
variable "log_store_name-a" {
  default = "squid-log-a"
}
variable "logtail_config_name-a" {
  default = "squid-config-a"
}
variable "log_project_name-b" {
  default = "log-project-b"
}
variable "log_store_name-b" {
  default = "squid-log-b"
}
variable "logtail_config_name-b" {
  default = "squid-config-b"
}
