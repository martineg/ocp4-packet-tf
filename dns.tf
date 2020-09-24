data "aws_route53_zone" "cluster" {
  name = var.ocp4_base_domain
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