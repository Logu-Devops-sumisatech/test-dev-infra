VPC with Public & Private Subnets
Security Groups for Jenkins, Proxy, and Dev servers
EC2 Instances:
  - Jenkins Server (`t2.medium`)
  - Proxy Server (`t2.micro`)
  - Dev Server (`t2.medium`)

Region: us-east-1
VPC CIDR: 10.0.0.0/16
Subnets:
  - Public Subnet: 10.0.0.0/24 (us-east-1a)
  - Private Subnet: 10.0.1.0/24 (us-east-1b)
Security Groups:
  - Public SG → Ports 80, 8080
  - Private SG → Ports 80, 3001–3002
  - Terraform >= 1.5.0
