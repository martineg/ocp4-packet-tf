output "bastion_public_ip" {
  description = "public IP of the instance"
  value       = packet_device.bastion.access_public_ipv4
}