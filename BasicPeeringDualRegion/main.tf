# Provider configurations
provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-1"
}

# --- VPC 1 (East) ---
resource "aws_vpc" "vpc-1-vpc" {
  provider   = aws.east
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "vpc-1-vpc" }
}

resource "aws_subnet" "vpc-1-subnet-public1-us-east-1a" {
  provider   = aws.east
  vpc_id     = aws_vpc.vpc-1-vpc.id
  cidr_block = "10.0.0.0/20"
  tags       = { Name = "vpc-1-subnet-public1-us-east-1a" }
}

resource "aws_subnet" "vpc-1-subnet-private1-us-east-1a" {
  provider   = aws.east
  vpc_id     = aws_vpc.vpc-1-vpc.id
  cidr_block = "10.0.128.0/20"
  tags       = { Name = "vpc-1-subnet-private1-us-east-1a" }
}

# --- VPC 2 (West) ---
resource "aws_vpc" "vpc-2-vpc" {
  provider   = aws.west
  cidr_block = "10.1.0.0/16"
  tags       = { Name = "vpc-2-vpc" }
}

resource "aws_subnet" "vpc-2-subnet-public1-us-west-1a" {
  provider   = aws.west
  vpc_id     = aws_vpc.vpc-2-vpc.id
  cidr_block = "10.1.0.0/20"
  tags       = { Name = "vpc-2-subnet-public1-us-west-1a" }
}

resource "aws_subnet" "vpc-2-subnet-private1-us-west-1a" {
  provider   = aws.west
  vpc_id     = aws_vpc.vpc-2-vpc.id
  cidr_block = "10.1.128.0/20"
  tags       = { Name = "vpc-2-subnet-private1-us-west-1a" }
}

# --- PEERING & ROUTING ---
resource "aws_vpc_peering_connection" "pc-vpc1-2" {
  provider    = aws.east
  # Swapped these to match the existing connection in your plan
  vpc_id      = "vpc-075ab22bb22ed0029" 
  peer_vpc_id = "vpc-02a863bf03023b338"
  peer_region = "us-east-1"
  tags        = { Name = "VPC Peering" }
}

resource "aws_route_table" "vpc-1-rtb-public" {
  provider = aws.east
  vpc_id   = "vpc-02a863bf03023b338"
  tags     = { Name = "vpc-1-rtb-public" }
}

resource "aws_route_table" "vpc-2-rtb-public" {
  provider = aws.west
  vpc_id   = "vpc-075ab22bb22ed0029"
  tags     = { Name = "vpc-2-rtb-public" }
}

resource "aws_route_table" "vpc-1-rtb-private1-us-east-1a" {
  provider = aws.east
  vpc_id   = aws_vpc.vpc-1-vpc.id
  
  route {
    cidr_block = "10.1.0.0/16"
    vpc_peering_connection_id = "pcx-0543edbb51a1f5401"
  }
  tags = { Name = "vpc-1-rtb-private1-us-east-1a" }
}

resource "aws_route_table" "vpc-2-rtb-private1-us-west-1a" {
  provider = aws.west
  vpc_id   = aws_vpc.vpc-2-vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id = "pcx-0543edbb51a1f5401"
  }
  tags = { Name = "vpc-2-rtb-private1-us-west-1a" }
}

# --- Internet Gateways ---
resource "aws_internet_gateway" "vpc-1-igw" {
  provider = aws.east
  vpc_id   = "vpc-02a863bf03023b338"
  tags     = { Name = "vpc-1-igw" }
}

resource "aws_internet_gateway" "vpc-2-igw" {
  provider = aws.west
  vpc_id   = "vpc-075ab22bb22ed0029"
  tags     = { Name = "vpc-2-igw" }
}

# --- VPC Endpoints (S3) ---
resource "aws_vpc_endpoint" "vpc-1-vpce-s3" {
  provider          = aws.east
  vpc_id            = "vpc-02a863bf03023b338"
  service_name      = "com.amazonaws.us-east-1.s3"
  tags              = { Name = "vpc-1-vpce-s3" }
}

resource "aws_vpc_endpoint" "vpc-2-vpce-s3" {
  provider          = aws.west
  vpc_id            = "vpc-075ab22bb22ed0029"
  service_name      = "com.amazonaws.us-west-1.s3"
  tags              = { Name = "vpc-2-vpce-s3" }
}

# --- COMPUTE (EC2) ---
resource "aws_instance" "bastionserver" {
  provider      = aws.east
  ami           = "ami-098e39bafa7e7303d" # Updated to match existing
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.vpc-1-subnet-public1-us-east-1a.id
  tags          = { Name = "bastionserver" } # Lowercase to match existing
}

resource "aws_instance" "privateserver_region1" {
  provider      = aws.east
  ami           = "ami-098e39bafa7e7303d" # Updated to match existing
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.vpc-1-subnet-private1-us-east-1a.id
  tags          = { Name = "privateserver_region1" } # Match existing
}

resource "aws_instance" "privateserver_region2" {
  provider      = aws.west
  ami           = "ami-02671e999eec7752f" # Updated to match existing
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.vpc-2-subnet-private1-us-west-1a.id
  tags          = { Name = "privateserver_region2" } # Match existing
}