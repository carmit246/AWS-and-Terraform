provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}
resource "aws_security_group" "lesson1hw-security-group" {
 name = "lesson1hw"
 ingress {
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 ingress {
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
  egress {
   from_port       = 0
   to_port         = 0
   protocol        = "-1"
   cidr_blocks     = ["0.0.0.0/0"]
 }
}


resource "aws_instance" "lesson1hw" {
  ami           = "ami-024582e76075564db"
  instance_type = "t2.micro"
  key_name = "lesson1hw"
  ebs_block_device {
  device_name = "/dev/sdb"
  volume_type = "gp2"
  volume_size = 10
  encrypted = true
  }
  
  tags = {
    owner = "Carmit Danon"
	servername = "lesson1hw"
	purpose = "opschool lesson1 homework"
  }
      
  vpc_security_group_ids = ["${aws_security_group.lesson1hw-security-group.id}"]
    
connection {
    	type = "ssh"
    	host = self.public_ip
	user = "ubuntu"
	private_key = "${file("D:\\opschool\\lesson1hw\\lesson1hw.pem")}"
  }
  
  provisioner "remote-exec" {       
	
	inline = [
	"sudo apt -y update",
	"sudo apt install -y nginx",
	 "sudo echo OpsSchool Rules | sudo tee /var/www/html/index.nginx-debian.html",
	"sudo service nginx start"
	]	
         }
	        
}



