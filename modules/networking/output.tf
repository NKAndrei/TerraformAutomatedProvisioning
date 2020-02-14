output "main_vpc_id" {
    value = "${aws_vpc.main_vpc.id}"
}
output "main_ig_id" {
    value = "${aws_internet_gateway.main_igw.id}"
}
output "main_rt_id" {
    value = "${aws_route_table.main_rt.id}"
}
output "main_vpc_subnets" {
    value = "${aws_subnet.main_vpc_subnet.id}"
}
output "main_sg_id" {
    value = "${aws_security_group.main_sg.id}"
}