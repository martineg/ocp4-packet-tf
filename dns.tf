data "aws_route53_zone" "cluster" {
  name = var.ocp4_base_domain
}

resource "aws_route53_record" "etcd_a" {
  count = 3

  zone_id = data.aws_route53_zone.cluster.zone_id
  name    = "etcd-${count.index}.${var.ocp4_cluster_name}.${data.aws_route53_zone.cluster.name}"
  type    = "A"
  ttl     = "300"
  records = [packet_device.master[count.index].access_public_ipv4]
}

resource "aws_route53_record" "etcd_srv" {
  zone_id = data.aws_route53_zone.cluster.zone_id
  name    = "_etcd-server-ssl._tcp.${var.ocp4_cluster_name}.${data.aws_route53_zone.cluster.name}"
  type    = "SRV"
  ttl     = "300"
  records = [
    "0 10 2380 ${packet_device.master[0].access_public_ipv4}",
    "0 10 2380 ${packet_device.master[1].access_public_ipv4}",
    "0 10 2380 ${packet_device.master[2].access_public_ipv4}"
  ]
}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.cluster.zone_id
  name    = "api.${var.ocp4_cluster_name}.${data.aws_route53_zone.cluster.name}"
  type    = "A"
  ttl     = "300"
  records = [packet_device.bastion.access_public_ipv4]
}

resource "aws_route53_record" "api_int" {
  zone_id = data.aws_route53_zone.cluster.zone_id
  name    = "api-int.${var.ocp4_cluster_name}.${data.aws_route53_zone.cluster.name}"
  type    = "A"
  ttl     = "300"
  records = [packet_device.bastion.access_public_ipv4]
}

resource "aws_route53_record" "apps" {
  zone_id = data.aws_route53_zone.cluster.zone_id
  name    = "*.apps.${var.ocp4_cluster_name}.${data.aws_route53_zone.cluster.name}"
  type    = "A"
  ttl     = "300"
  records = [packet_device.bastion.access_public_ipv4]

}