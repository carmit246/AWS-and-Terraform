output "vpc-id" {
  value = "${aws_vpc.lesson2hw_vpc.id}"
}

output "subnet-pub1-id" {
  value = "${aws_subnet.lesson2hw-pub1.id}"
}

output "subnet-pub2-id" {
  value = "${aws_subnet.lesson2hw-pub2.id}"
}

output "subnet-int1-id" {
  value = "${aws_subnet.lesson2hw-int1.id}"
}

output "subnet-int2-id" {
  value = "${aws_subnet.lesson2hw-int2.id}"
}

output "security-group-pub" {
  value = "${aws_security_group.lesson2hw-ssh-allowed.id}"
}
