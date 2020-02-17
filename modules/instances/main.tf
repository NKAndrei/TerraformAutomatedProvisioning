provider "aws" {
    region = "eu-west-1"
}


resource "aws_instance" "web_instance" {
    #count = 2
    ami = "ami-0364dea6ba7b75fc6"
    instance_type = "t2.micro"
    tags = {
        #Name = "Andrei_Main_Instance_${count.index}"
        Name = "Andrei_Main_Instance"
    }
    associate_public_ip_address = true
    security_groups = ["${var.main_sg_id}"]
    key_name = "${aws_key_pair.web_instance_access.id}"
    #key_name = "${var.key_name}"
    subnet_id = "${var.main_subnet_id}"
    
    provisioner "remote-exec" {
        inline = [
            "echo hello world",
            "sudo yum -y install git",
            "echo hello world",
            "sudo yum -y install docker",
            "sudo systemctl start docker",
            "sudo docker pull nginx",
            "sudo docker run --name some-nginx -d -p 8080:80 nginx:latest"
        ]
        connection {
            type = "ssh"
            user = "ec2-user"
            private_key = "${file("/home/ec2-user/environment/terraform/standardProject/modules/root/mainKey")}"
            host = "${aws_instance.web_instance.public_ip}"
        }
    }
    
}

resource "aws_key_pair" "web_instance_access" {
    key_name = "${var.key_name}"
    public_key = "${file(var.public_key_path)}"
}

#subnet_id

#security
