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
    availability_zone = "eu-west-1a"
}
resource "aws_subnet" "main_vpc_subnet2" {
    vpc_id = "${aws_vpc.main_vpc.id}"
    cidr_block = "172.16.2.0/24"
    tags = {
        Name = "Andrei_Main_VPC_Subnet2"
    }
    availability_zone = "eu-west-1b"
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

# ---- Load Balancer
resource "aws_lb" "main_lb" {
    name = "Andrei-Main-ELB"
    internal = false
    subnets = ["${aws_subnet.main_vpc_subnet.id}","${aws_subnet.main_vpc_subnet2.id}"]
    security_groups = ["${aws_security_group.main_sg.id}"]
    
    tags = {
        Name = "Andrei-Main-ELB"
    }
}

# ---- Load Balancer and Target Group connection
resource "aws_lb_listener" "main_lb_listener" {
    load_balancer_arn = "${aws_lb.main_lb.arn}"
    port = "80"
    protocol = "HTTP"
    
    default_action {
        type = "forward"
        target_group_arn = "${aws_lb_target_group.main_tg.arn}"    
        
    }
}

# ---- Target Group
resource "aws_lb_target_group" "main_tg" {
    name = "Andrei-Main-TG"
    port = 80
    protocol = "HTTP"
    vpc_id = "${aws_vpc.main_vpc.id}"
}

# ---- Target Group and Instance connection
resource "aws_lb_target_group_attachment" "main_tg_attachment" {
    count = 2
    target_group_arn = "${aws_lb_target_group.main_tg.arn}"
    target_id = "${var.instance_id[count.index]}"
    port = 8080
}