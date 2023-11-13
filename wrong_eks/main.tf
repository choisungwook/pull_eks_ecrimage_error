module "vpc" {
  source = "./module/vpc"

  vpc_cidr = "10.0.0.0/16"
  public_subnets = {
    "subnet_a1" = {
      cidr = "10.0.10.0/24",
      az   = "ap-northeast-2a",
      tags = {
        Name = "public subnet a1"
      }
    },
    "subnet_b1" = {
      cidr = "10.0.11.0/24",
      az   = "ap-northeast-2c",
      tags = {
        Name = "public subnet c1"
      }
    }
  }
  private_subnets = {
    "subnet_a1" = {
      cidr = "10.0.100.0/24",
      az   = "ap-northeast-2a",
      tags = {
        Name = "private subnet a1"
      }
    },
    "subnet_b1" = {
      cidr = "10.0.101.0/24",
      az   = "ap-northeast-2c",
      tags = {
        Name = "private subnet c1"
      }
    }
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [module.vpc.private_route_table_id]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "arn:aws:s3:::akbun*", # 의미없는 s3값(실제 사용하지 않음)
          "arn:aws:s3:::akbun/*" # 의미없는 s3값(실제 사용하지 않음)
        ]
      }
    ]
  })

  tags = {
    Name = "terrafkrma-eks"
  }
}

module "eks" {
  source = "./module/eks"

  eks-name                = "eks-from-terraform"
  eks_version             = "1.27"
  vpc_id                  = module.vpc.vpc_id
  private_subnets_ids     = module.vpc.private_subnets_ids
  endpoint_prviate_access = true
  endpoint_public_access  = true
  managed_node_groups = {
    "managed-node-group-a" = {
      node_group_name = "managed-node-group-a",
      instance_types  = ["t2.micro"],
      capacity_type   = "SPOT",
      release_version = "1.27.1-20230513"
      disk_size       = 20
      desired_size    = 1,
      max_size        = 1,
      min_size        = 1
    }
  }
  aws_auth_admin_roles = []
}
