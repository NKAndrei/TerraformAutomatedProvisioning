provider "aws" {
    region = "eu-west-1"
}

resource "aws_vpc" "main_vpc"{
    cidr_block = "172.16.0.0/16"
    tags = {
        Name = "Andrei_Main_VPC"
    }
}

resource "aws_internet_gateway" "main_igw" {
    vpc_id = "${aws_vpc.main_vpc.id}"
    tags = {
        Name = "Andrei_Main_IGW"
    }
}

resource "aws_subnet" "main_vpc_subnet" {
    vpc_id = "${aws_vpc.main_vpc.id}"
    cidr_block = "172.16.1.0/24"
    tags = {
        Name = "Andrei_Main_VPC_Subnet"
    }
}

resource "aws_route_table" "main_rt" {
    vpc_id = "${aws_vpc.main_vpc.id}"
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main_igw.id}"
    }
    
    tags = {
        Name = "Andrei_Main_RT"
    }
    
}

resource "aws_main_route_table_association" "main_rta" {
    vpc_id = "${aws_vpc.main_vpc.id}"
    route_table_id = "${aws_route_table.main_rt.id}"
}
resource "aws_route_table_association" "main_rta_subnet" {
    subnet_id = "${aws_subnet.main_vpc_subnet.id}"
    route_table_id = "${aws_route_table.main_rt.id}"
}

resource "aws_security_group" "main_sg" {
    name = "main_sg_allow_all"
    vpc_id = "${aws_vpc.main_vpc.id}"
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_elb" "main_elb" {
    name = "Andrei-Main-ELB"
    availability_zones = ["eu-west-1a", "eu-west-1b"]
    
    listener {
        instance_port = 3000
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }
}

#resource "aws_lb_target_group" "main_tg" {
#    name = "Andrei_Main_TG"
#    port = 
#    protocol = "HTTP"
#    vpc_id = "${aws_vpc.main_vpc.id}"
#}

#resource "aws_lb_target_group_attachment" "main_tg_attachment" {
#    target_group_arn = ""
#    target_id = ""
#}