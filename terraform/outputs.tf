output "instance_id" {
  description = "EC2 instance ID of the Jenkins server"
  value       = aws_instance.jenkins_server.id
}

output "public_ip" {
  description = "Public IP address of the Jenkins server"
  value       = aws_instance.jenkins_server.public_ip
}

output "jenkins_url" {
  description = "URL to access Jenkins"
  value       = "http://${aws_instance.jenkins_server.public_ip}:8080"
}

output "sonarqube_url" {
  description = "URL to access SonarQube"
  value       = "http://${aws_instance.jenkins_server.public_ip}:9000"
}

output "tomcat_url" {
  description = "URL to access Tomcat"
  value       = "http://${aws_instance.jenkins_server.public_ip}:8083"
}

output "ssh_command" {
  description = "Command to SSH into the server"
  value       = "ssh -i ${var.key_pair_name}.pem ubuntu@${aws_instance.jenkins_server.public_ip}"
}
