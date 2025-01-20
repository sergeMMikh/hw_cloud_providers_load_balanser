# output "instances_info" {
#   description = "Information about each instance"
#   value = {
#     public_vm = {
#       instance_name = aws_instance.public_vm[0].tags["Name"]
#       external_ip   = aws_instance.public_vm[0].public_ip
#       fqdn          = aws_instance.public_vm[0].public_dns
#     }
#     private_vm = {
#       instance_name = aws_instance.private_vm[0].tags["Name"]
#       external_ip   = aws_instance.private_vm[0].public_ip
#       fqdn          = aws_instance.private_vm[0].public_dns
#     }
#   }
# }


output "alb_dns_name" {
  value       = aws_lb.web_alb.dns_name
  description = "DNS name of the Load Balancer"
}

output "instances_info" {
  value = {
    asg = aws_autoscaling_group.web_asg.name
  }
}
