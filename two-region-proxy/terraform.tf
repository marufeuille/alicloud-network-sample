provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region-a}"
  alias      = "region-a"
}

provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region-b}"
  alias      = "region-b"
}

resource "alicloud_vpc" "vpc_region-a" {
  provider   = "alicloud.region-a"
  name       = "${var.vpc_name_region-a}"
  cidr_block = "${var.vpc_cidr_region-a}"
}

resource "alicloud_vswitch" "vsw_region-a" {
  provider          = "alicloud.region-a"
  vpc_id            = "${alicloud_vpc.vpc_region-a.id}"
  cidr_block        = "${var.vsw_cidr_region-a}"
  availability_zone = "${var.zone_region-a}"
}

resource "alicloud_vpc" "vpc_region-b" {
  provider   = "alicloud.region-b"
  name       = "${var.vpc_name_region-b}"
  cidr_block = "${var.vpc_cidr_region-b}"
}

resource "alicloud_vswitch" "vsw_region-b" {
  provider          = "alicloud.region-b"
  vpc_id            = "${alicloud_vpc.vpc_region-b.id}"
  cidr_block        = "${var.vsw_cidr_region-b}"
  availability_zone = "${var.zone_region-b}"
}

resource "alicloud_cen_instance" "cen" {
  provider    = "alicloud.region-a"
  name        = "${var.cen_name}"
  depends_on  = ["alicloud_vswitch.vsw_region-a", "alicloud_vswitch.vsw_region-b"]
  description = "${var.cen_description}"
}

resource "alicloud_cen_instance_attachment" "attachment_region-a" {
  provider                 = "alicloud.region-a"
  instance_id              = "${alicloud_cen_instance.cen.id}"
  child_instance_id        = "${alicloud_vpc.vpc_region-a.id}"
  child_instance_region_id = "${var.region-a}"
}

resource "alicloud_cen_instance_attachment" "attachment_region-b" {
  provider                 = "alicloud.region-b"
  instance_id              = "${alicloud_cen_instance.cen.id}"
  child_instance_id        = "${alicloud_vpc.vpc_region-b.id}"
  child_instance_region_id = "${var.region-b}"
}

resource "alicloud_vpn_gateway" "vpn-gateway" {
  provider             = "alicloud.region-b"
  name                 = "${var.vpn_gateway_name}"
  vpc_id               = "${alicloud_vpc.vpc_region-b.id}"
  bandwidth            = "10"
  enable_ssl           = true
  instance_charge_type = "PostPaid"
  description          = "${var.vpn_gateway_description}"
}

resource "alicloud_ssl_vpn_server" "ssl-vpn-server" {
  provider       = "alicloud.region-b"
  name           = "${var.ssl_vpn_server_name}"
  vpn_gateway_id = "${alicloud_vpn_gateway.vpn-gateway.id}"
  client_ip_pool = "${var.client_ip_pool}"
  local_subnet   = "${alicloud_vswitch.vsw_region-b.cidr_block}"
  protocol       = "UDP"
  cipher         = "AES-128-CBC"
  port           = 1194
  compress       = "false"
}

resource "alicloud_ssl_vpn_client_cert" "cert1" {
  provider          = "alicloud.region-b"
  ssl_vpn_server_id = "${alicloud_ssl_vpn_server.ssl-vpn-server.id}"
  name              = "${var.ssl_vpn_client_cert_name}"
}

resource "alicloud_security_group" "sg_region-a" {
  provider = "alicloud.region-a"
  name     = "terraform-sg"
  vpc_id   = "${alicloud_vpc.vpc_region-a.id}"
}

resource "alicloud_security_group_rule" "allow_icmp_region-a" {
  provider          = "alicloud.region-a"
  type              = "ingress"
  ip_protocol       = "icmp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg_region-a.id}"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_ssh_region-a" {
  provider          = "alicloud.region-a"
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg_region-a.id}"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_proxy_access_region-a" {
  provider          = "alicloud.region-a"
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "8080/8080"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg_region-a.id}"
  cidr_ip           = "${alicloud_instance.proxy-b.private_ip}"
}

resource "alicloud_security_group" "sg_region-b" {
  provider = "alicloud.region-b"
  name     = "terraform-sg"
  vpc_id   = "${alicloud_vpc.vpc_region-b.id}"
}

resource "alicloud_security_group_rule" "allow_icmp_region-b" {
  provider          = "alicloud.region-b"
  type              = "ingress"
  ip_protocol       = "icmp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg_region-b.id}"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_ssh_region-b" {
  provider          = "alicloud.region-b"
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg_region-b.id}"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_proxy_access_region-b" {
  provider          = "alicloud.region-b"
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "8080/8080"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg_region-b.id}"
  cidr_ip           = "${alicloud_ssl_vpn_server.ssl-vpn-server.client_ip_pool}"
}
resource "alicloud_cen_route_entry" "vpn" {
    provider       = "alicloud.region-b"
    instance_id    = "${alicloud_cen_instance.cen.id}"
    route_table_id = "${alicloud_vpc.vpc_region-b.route_table_id}"
    cidr_block     = "${var.client_ip_pool}"
    depends_on     = [
        "alicloud_ssl_vpn_server.ssl-vpn-server"
    ]
}

resource "alicloud_eip" "eip-a" {
  provider = "alicloud.region-a"
}

resource "alicloud_eip" "eip-b" {
  provider = "alicloud.region-b"
}

resource "alicloud_instance" "proxy-a" {
  provider             = "alicloud.region-a"
  instance_name        = "${var.instance_name_region-a}"
  host_name            = "${var.host_name_region-a}"
  availability_zone    = "${var.zone_region-a}"
  image_id             = "centos_7_3_64_40G_base_20170322.vhd"
  instance_type        = "${var.instance_type_region-a}"
  system_disk_category = "cloud_efficiency"
  security_groups      = ["${alicloud_security_group.sg_region-a.id}"]
  vswitch_id           = "${alicloud_vswitch.vsw_region-a.id}"
  user_data            = "#!/bin/bash\necho \"${file("static/squid/squid-a.conf")}\" > /tmp/squid.conf\n${data.template_file.prv-proxy-a.rendered}"
}

resource "alicloud_eip_association" "eip-a-ass" {
  provider      = "alicloud.region-a"
  allocation_id = "${alicloud_eip.eip-a.id}"
  instance_id   = "${alicloud_instance.proxy-a.id}"
}

resource "alicloud_instance" "proxy-b" {
  provider             = "alicloud.region-b"
  instance_name        = "${var.instance_name_region-b}"
  host_name            = "${var.host_name_region-b}"
  availability_zone    = "${var.zone_region-b}"
  image_id             = "centos_7_3_64_40G_base_20170322.vhd"
  instance_type        = "${var.instance_type_region-b}"
  system_disk_category = "cloud_efficiency"
  security_groups      = ["${alicloud_security_group.sg_region-b.id}"]
  vswitch_id           = "${alicloud_vswitch.vsw_region-b.id}"
  user_data            = "#!/bin/bash\necho '${file("static/squid/make-squid-b-conf.sh")}' > /tmp/make-squid-b-conf.sh\n${data.template_file.prv-proxy-b.rendered}"
}

resource "alicloud_eip_association" "eip-b-ass" {
  provider      = "alicloud.region-b"
  allocation_id = "${alicloud_eip.eip-b.id}"
  instance_id   = "${alicloud_instance.proxy-b.id}"
}

data "template_file" "prv-proxy-a" {
  template = "${file("templates/provisioning-proxy-a.tpl")}"
  vars     = {
    password   = "${var.ecs-password}"
    publickey  = "${var.publickey}"
    region-id  = "${var.region-a}"
  }
}

data "template_file" "prv-proxy-b" {
  template = "${file("templates/provisioning-proxy-b.tpl")}"
  vars     = {
    password     = "${var.ecs-password}"
    publickey    = "${var.publickey}"
    proxy-a-ip   = "${alicloud_instance.proxy-a.private_ip}"
    dest-domains = "${var.dest-domains}"
    region-id    = "${var.region-b}"
  }
}

resource "alicloud_log_project" "project-a"{
  provider    = "alicloud.region-a"
  name        = "${var.log_project_name-a}"
  description = "create by terraform"
}

resource "alicloud_log_store" "store-a"{
  provider              = "alicloud.region-a"
  project               = "${alicloud_log_project.project-a.name}"
  name                  = "${var.log_store_name-a}"
  retention_period      = 3650
  shard_count           = 2
  auto_split            = true
  max_split_shard_count = 60
  append_meta           = true
}

resource "alicloud_logtail_config" "config-a" {
  provider     = "alicloud.region-a"
  project      = "${alicloud_log_project.project-a.name}"
  logstore     = "${alicloud_log_store.store-a.name}"
  input_type   = "file"
  name         = "${var.logtail_config_name-a}"
  output_type  = "LogService"
  log_sample   = "1554718819.175      4 10.255.255.6 TCP_MISS/200 913 POST http://ocsp.digicert.com/ - HIER_DIRECT/117.18.237.29 application/ocsp-response"
  input_detail = "${file("static/logtail_config/config.js")}"
}

resource "alicloud_log_machine_group" "squid-a" {
  provider      = "alicloud.region-a"
  project       = "${alicloud_log_project.project-a.name}"
  name          = "tf-machine-group"
  identify_type = "ip"
  identify_list = ["${alicloud_instance.proxy-a.private_ip}"]
}

resource "alicloud_logtail_attachment" "attachment-a" {
  provider            = "alicloud.region-a"
  project             = "${alicloud_log_project.project-a.name}"
  logtail_config_name = "${alicloud_logtail_config.config-a.name}"
  machine_group_name  = "${alicloud_log_machine_group.squid-a.name}"
}

resource "alicloud_log_project" "project-b"{
  provider    = "alicloud.region-b"
  name        = "${var.log_project_name-b}"
  description = "create by terraform"
}

resource "alicloud_log_store" "store-b"{
  provider              = "alicloud.region-b"
  project               = "${alicloud_log_project.project-b.name}"
  name                  = "${var.log_store_name-b}"
  retention_period      = 3650
  shard_count           = 2
  auto_split            = true
  max_split_shard_count = 60
  append_meta           = true
}
resource "alicloud_logtail_config" "config-b" {
  provider     = "alicloud.region-b"
  project      = "${alicloud_log_project.project-b.name}"
  logstore     = "${alicloud_log_store.store-b.name}"
  input_type   = "file"
  name         = "${var.logtail_config_name-b}"
  output_type  = "LogService"
  log_sample   = "1554718819.175      4 10.255.255.6 TCP_MISS/200 913 POST http://ocsp.digicert.com/ - HIER_DIRECT/117.18.237.29 application/ocsp-response"
  input_detail = "${file("static/logtail_config/config.js")}"
}

resource "alicloud_log_machine_group" "squid-b" {
  provider      = "alicloud.region-b"
  project       = "${alicloud_log_project.project-b.name}"
  name          = "tf-machine-group"
  identify_type = "ip"
  identify_list = ["${alicloud_instance.proxy-b.private_ip}"]
}

resource "alicloud_logtail_attachment" "attachment-b" {
  provider            = "alicloud.region-b"
  project             = "${alicloud_log_project.project-b.name}"
  logtail_config_name = "${alicloud_logtail_config.config-b.name}"
  machine_group_name  = "${alicloud_log_machine_group.squid-b.name}"
}
