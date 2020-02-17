module "networking" {
    source = "../networking"
    instance_id = "${module.instances.instance_id}"
}
module "instances" {
    source = "../instances"
    main_subnet_id = "${module.networking.main_vpc_subnets}"
    key_name = "${var.key_name}"
    public_key_path = "${var.public_key_path}"
    #web_instance_access = "mainKey"
    main_sg_id = "${module.networking.main_sg_id}"
}