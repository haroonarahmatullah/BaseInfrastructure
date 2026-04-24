terraform import aws_vpc.vpc-1-vpc vpc-02a863bf03023b338; `
terraform import aws_subnet.vpc-1-subnet-public1-us-east-1a subnet-067c874a272cb9d69; `
terraform import aws_subnet.vpc-1-subnet-private1-us-east-1a subnet-06f90687a2852c215; `
terraform import aws_vpc.vpc-2-vpc vpc-075ab22bb22ed0029; `
terraform import aws_subnet.vpc-2-subnet-private1-us-west-1a subnet-05b5bbdaf5a719db4; `
terraform import aws_subnet.vpc-2-subnet-public1-us-west-1a subnet-0270d49fe442c484b; `
terraform import aws_vpc_peering_connection.pc-vpc1-2 pcx-0543edbb51a1f5401; `
terraform import aws_route_table.vpc-1-rtb-private1-us-east-1a rtb-06239a676457116ea; `
terraform import aws_route_table.vpc-2-rtb-private1-us-west-1a rtb-036193df564b2758f; `
terraform import aws_route_table.vpc-1-rtb-public rtb-0a90942ae6eb071fd; `
terraform import aws_route_table.vpc-2-rtb-public rtb-002931b0a15f70951; `
terraform import aws_instance.bastionserver i-0bfdb09d41adb4463; `
terraform import aws_instance.privateserver_region1 i-012d8bf84803f1826; `
terraform import aws_internet_gateway.vpc-1-igw igw-0e6151c29efcbd343; `
terraform import aws_internet_gateway.vpc-2-igw igw-09f8d111fe67228c6; `
terraform import aws_vpc_endpoint.vpc-1-vpce-s3 vpce-01a1a32bc2b70947f; `
terraform import aws_vpc_endpoint.vpc-2-vpce-s3 vpce-0acc82f2eca1cc17d
terraform import aws_instance.privateserver_region2 i-0017a922a016ce732