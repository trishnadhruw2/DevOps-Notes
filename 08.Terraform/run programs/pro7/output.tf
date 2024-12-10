output "apache_public_ip" {
 	description = "Public IP address Apache Server"
  	value = aws_instance.apache-server.public_ip
}
output "nginx_public_ip" {
 	description = "Public IP address Nginx Server"
  	value = aws_instance.nginx-server.public_ip
}

