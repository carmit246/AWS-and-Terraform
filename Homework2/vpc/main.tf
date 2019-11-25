provider "aws" {
  region     = "${var.aws_region}"
}

#Crate VPC
resource "aws_vpc" "lesson2hw_vpc" {
  cidr_block       = "${var.vpc_config.cidr_block}"
  tags = {
    Name = "${var.vpc_config.name}"
  }
}
#Create public subnets
resource "aws_subnet" "lesson2hw-pub1" {
  vpc_id     = "${aws_vpc.lesson2hw_vpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "lesson2hw-pub1"
  }
}

resource "aws_subnet" "lesson2hw-pub2" {
  vpc_id     = "${aws_vpc.lesson2hw_vpc.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"
  tags = {
    Name = "lesson2hw-pub2"
  }
}

#Create internal subnets
resource "aws_subnet" "lesson2hw-int1" {
  vpc_id     = "${aws_vpc.lesson2hw_vpc.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "lesson2hw-int1"
  }
}
resource "aws_subnet" "lesson2hw-int2" {
  vpc_id     = "${aws_vpc.lesson2hw_vpc.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "lesson2hw-int2"
  }
}

#Create internet GW
resource "aws_internet_gateway" "lesson2hw-igw" {
    vpc_id = "${aws_vpc.lesson2hw_vpc.id}"
    
    tags = {
        Name = "lesson2hw-igw"
    }
}

#Create route table for external subnet
resource "aws_route_table" "lesson2hw-rtpub" {
    vpc_id = "${aws_vpc.lesson2hw_vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.lesson2hw-igw.id}" 
    }
    
    tags = {
        Name = "lesson2hw-rtpub"
    }
}

#Create NAT
resource "aws_instance" "lesson2hw-nat1" {
    ami = "ami-024582e76075564db"
    instance_type = "t2.micro"
    key_name = "test1"
    vpc_security_group_ids = ["${aws_security_group.lesson2hw-ssh-allowed.id}"]
    subnet_id = "${aws_subnet.lesson2hw-pub1.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags = {
        Name = "lesson2hw-nat1"
    }
}

resource "aws_eip" "lesson2hw-nat1" {
  instance = "${aws_instance.lesson2hw-nat2.id}"
  vpc      = true
  tags = {
        Name = "lesson2hw-nat1"
    }
}

resource "aws_instance" "lesson2hw-nat2" {
    ami = "ami-024582e76075564db"
    instance_type = "t2.micro"
    key_name = "test1"
    vpc_security_group_ids = ["${aws_security_group.lesson2hw-ssh-allowed.id}"]
    subnet_id = "${aws_subnet.lesson2hw-pub2.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags = {
        Name = "lesson2hw-nat2"
    }
}

resource "aws_eip" "lesson2hw-nat2" {
  instance = "${aws_instance.lesson2hw-nat2.id}"
  vpc      = true
  tags = {
        Name = "lesson2hw-nat2"
    }
}

#Create route table for internal subnet
resource "aws_route_table" "lesson2hw-rtint1" {
    vpc_id = "${aws_vpc.lesson2hw_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.lesson2hw-nat1.id}"
    }
    tags = {
        Name = "lesson2hw-rtint1"
    }
}

resource "aws_route_table" "lesson2hw-rtint2" {
    vpc_id = "${aws_vpc.lesson2hw_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.lesson2hw-nat2.id}"
    }
    tags = {
        Name = "lesson2hw-rtint2"
    }
}

#associate route table for internal subnet
resource "aws_route_table_association" "lesson2hw-int1" {
    subnet_id = "${aws_subnet.lesson2hw-int1.id}"
    route_table_id = "${aws_route_table.lesson2hw-rtint1.id}"
}
resource "aws_route_table_association" "lesson2hw-int2" {
    subnet_id = "${aws_subnet.lesson2hw-int2.id}"
    route_table_id = "${aws_route_table.lesson2hw-rtint2.id}"
}

#Create security group
resource "aws_security_group" "lesson2hw-ssh-allowed" {
    vpc_id = "${aws_vpc.lesson2hw_vpc.id}"
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8
        to_port = 0
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
     ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "lesson2hw-ssh-allowed"
    }
}


#associate route table for external subnet
resource "aws_route_table_association" "lesson2hw-pub1" {
    subnet_id = "${aws_subnet.lesson2hw-pub1.id}"
    route_table_id = "${aws_route_table.lesson2hw-rtpub.id}"
}
resource "aws_route_table_association" "lesson2hw-pub2" {
    subnet_id = "${aws_subnet.lesson2hw-pub2.id}"
    route_table_id = "${aws_route_table.lesson2hw-rtpub.id}"
}


#Create EC2 Web Instances
