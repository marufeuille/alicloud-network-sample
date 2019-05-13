output "proxy_ip" {
    value = "${alicloud_instance.proxy-a.private_ip}"
}