output "ansible_public_ip" {
 	description = "Public IP address of Ansible Server"
  	value = aws_instance.Ansible-server.public_ip
}
output "master_private_ip" {
 	description = "Private IP address of master Server"
  	value = aws_instance.master.private_ip
}
output "worker1_private_ip" {
 	description = "Private IP address of worker"
  	value = aws_instance.worker1.private_ip
}
output "worker2_private_ip" {
 	description = "Private IP address of worker"
  	value = aws_instance.worker2.private_ip
}
output "worker3_private_ip" {
 	description = "Private IP address of worker"
  	value = aws_instance.worker3.private_ip
}
