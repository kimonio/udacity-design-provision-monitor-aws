# Designate a cloud provider, region, and credentials
# Credentials are stored locally at ~/.aws/credentials
provider "aws" {
  region  = "us-east-1"
  profile = "udacity"
}

# Provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "t2" {
  count         = 4
  ami           = "ami-09d95fab7fff3776c"
  instance_type = "t2.micro"
  subnet_id = "subnet-0becb32eb662674dd"

  tags = {
    Name = "Udacity T2"
  }
}

# Provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "m4" {
  count         = 2
  ami           = "ami-09d95fab7fff3776c"
  instance_type = "m4.large"
  subnet_id = "subnet-0becb32eb662674dd"

  tags = {
    Name = "Udacity M4"
  }
}