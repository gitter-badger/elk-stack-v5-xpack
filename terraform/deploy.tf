
variable "dockerworkercount" {
  default = 3
}


data "template_file" "dockerworker" {
    template = "${file("bootstrapdockerworker.sh.tpl")}"
}

resource "openstack_compute_instance_v2" "docker-worker" {
  count = "${var.dockerworkercount}"
  name = "${format("demo-elk-demo-%02d-${var.openstack_user_name}", count.index+1)}"
  image_name = "demo-centos7-gencloud20160906-image"
  availability_zone = "Temp"
  flavor_name = "demo-xlarge"
  key_pair = "${var.openstack_keypair}"
  security_groups = ["allow_all"]
  region = "DEMO"
  network {
    name = "Infra"
  }
  config_drive = "true"

  user_data = "${data.template_file.dockerworker.rendered}"
}

output "docker-worker" {
  value = "${join(",", openstack_compute_instance_v2.docker-worker.*.access_ip_v4)}"
}
