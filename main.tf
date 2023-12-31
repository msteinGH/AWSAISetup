
# do need to have credentials file ~/.aws/credentials set up via aws cli
# aws configure
# or edit manually:
#
# [default]
# aws_secret_access_key = XXX
# aws_access_key_id = YYY

# TODOS
# run BERT training on 32 CPU machine
# - maybe adjust parameters/batch sizes > 32 
# - check BERT training optimizations
# Create Q&A model
# - context approach not scalable, need to go for pretraining
# -- import/read text once, answer questions faster
# Start using GIT branches??
# - this way no hard merge conflicts?? 
# consolidate AISamples <-> AWSAISetup
# - have AISetup use AISamples to only have a single source of truth

provider "aws" {
	#region 		= "us-east-1"
    region 		= "${var.region}"
    shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_key_pair" "tf-generic-user-key" {
  key_name   = "tf-generic-user-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAp62kAHeRBzDaz8QpqdhIlvgPtnOVx2q1v2nGnYwYdVRlrWUIL8B3NyvCAwebu/T2+QXjTphfOXfd8z5gExxXnjuv/ECUILVjxuzwM3eC9C1YGCVekPObY8HqjvhNvpdz/sZpU3FgXi8mj9JN2+li+tgPZfejyhuzCXJrYICQ/x6iV2sxD7Rlwd4ALSQoaHO+/x72FimkfidtSawxRJszghY38+TVd3yi2SPBCd36MQtYPqHxj1GuLQmG+VrYXvdndTcf56mHCqsWIxSeJMtFEXjbP3eDjHku12hZqp+Vyt4bNh9kK6IV/dPPLCXeyew7gIz6jFk4UJBABsHc95+6BQ=="
}



# set up EC2 instance
resource "aws_instance" "plain-ubuntu-ec2" {
# plain Ubuntu SSD
 ami = "ami-0c7217cdde317cfec" 
  # Ubuntu SSD, WITH PyTorch preinstalled??
  # ami = "ami-05b5ef59e0e3e83b4"
	# 1 CPU 1 GB
  #instance_type = "t2.micro"
  # 64 GB 32 CPUs (largest we can get??) c5 Intel (better?), c5a AMD
  instance_type = "c5a.8xlarge"

  # 2 CPUs 8 GB 
  #instance_type = "t2.large"  
  # 8 CPUs 32 GB 
  #instance_type = "t2.2xlarge"
  # 32 GB 16 CPUs c5 Intel (better?), c5a AMD
  #instance_type = "c5.4xlarge"

	
  key_name = "tf-generic-user-key"
  subnet_id       = aws_subnet.tf-generic-subnet.id
	associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.tf-allow-ssh.id]
	user_data = "${file("user_data.sh")}"
	tags = {
		Name = "tf-plain-ubuntu-ec2"
	}
}


# create ebs volume for extended storage
resource "aws_ebs_volume" "python-venv-ebs-volume" {
  availability_zone = "${var.availability_zone}"
  # size in GB
  size       = 100
  tags = {
    Name = "tf-python-venv-ebs-volume"
  }
}

resource "aws_volume_attachment" "python-venv-ebs-volume-attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.python-venv-ebs-volume.id
  instance_id = aws_instance.plain-ubuntu-ec2.id
}


# Standard Networking

# create VPC
resource "aws_vpc" "tf-generic-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tf-generic-vpc"
  }
}

# create subnet
resource "aws_subnet" "tf-generic-subnet" {
  vpc_id            = aws_vpc.tf-generic-vpc.id

  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.availability_zone}"

  tags = {
    Name = "tf-generic-subnet"
  }
}

resource "aws_internet_gateway" "tf-my-internet-gateway" {
  vpc_id = aws_vpc.tf-generic-vpc.id
  tags = {
    Name = "tf-my-internet-gateway"
  }
}

resource "aws_route_table" "tf-my-route-table" {
  vpc_id = aws_vpc.tf-generic-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-my-internet-gateway.id
  }
  tags = {
    Name = "tf-my-route-table"
  }
}

resource "aws_route_table_association" "tf-my-route-table-association" {
 subnet_id = aws_subnet.tf-generic-subnet.id
 route_table_id = aws_route_table.tf-my-route-table.id
}

# create security group inbound via HTTP port 8080/8081
resource "aws_security_group" "tf-allow-tcp-8080-8081" {
  name        = "tf-allow-tcp-8080"
  description = "Allow ALL TCP on port 8080 inbound traffic"
  vpc_id      = aws_vpc.tf-generic-vpc.id

  ingress {
    description      = "HTTP from 8080"
    from_port        = 8080
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # outbound ALL protocols alllowed
  # make sure to be able to reach amazon and other repos for package installations 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "tf-allow-tcp-8080"
  }
}

# create security group inbound via SSH from ALL, 
resource "aws_security_group" "tf-allow-ssh" {
  name        = "tf-allow-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.tf-generic-vpc.id

  ingress {
    description      = "SSH from ALL"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # outbound ALL protocols alllowed
  # make sure to be able to reach amazon and other repos for package installations 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "tf-allow-ssh"
  }
}


