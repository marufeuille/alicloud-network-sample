output "eip-a" {
    value = "${alicloud_eip.eip-a.ip_address}"
}
output "private-ip-a" {
    value = "${alicloud_instance.proxy-a.private_ip}"
}
output "eip-b" {
    value = "${alicloud_eip.eip-b.ip_address}"
}
output "private-ip-b" {
    value = "${alicloud_instance.proxy-b.private_ip}"
}
