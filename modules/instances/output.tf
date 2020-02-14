output "instance_id" {
    #value = "${aws_instance.web_instance.*.id}"
    value = "${aws_instance.web_instance.id}"
}