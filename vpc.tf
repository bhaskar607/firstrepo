provider "aws" {
  region = "us-east-1"  
}

resource "aws_vpc" "Bhaskar_vpc" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "Bhaskar_vpc"
  }
}

#create igw

resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.Bhaskar_vpc.id

tags = {
  Name = "Bhaskar_vpc gateway"
}

}

#create subnet

resource "aws_subnet" "pub" {
  vpc_id = aws_vpc.Bhaskar_vpc.id
  cidr_block = "192.168.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Public subnet"
  }
}

resource "aws_subnet" "pri" {
  vpc_id = aws_vpc.Bhaskar_vpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private subnet"
  }
}

#creating route tables

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.Bhaskar_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "pri_rt" {
  vpc_id = aws_vpc.Bhaskar_vpc.id
  
}

#create rt association

resource "aws_route_table_association" "pa" {

subnet_id = aws_subnet.pub.id
route_table_id = aws_route_table.pub_rt.id
}


resource "aws_route_table_association" "pra" {

subnet_id = aws_subnet.pri.id
route_table_id = aws_route_table.pri_rt.id
}

#elasticip
resource "aws_eip" "nat_eip" {
  domain = "vpc"

}


#creating_NAT_gateway

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub.id  
  tags = {
    Name = "MyNATGateway"
  }
}

resource "aws_route" "priv_rt_nat" {     
  route_table_id = aws_route_table.pri_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}