variable "eks__version" {
  type        = string
  description = "The version of Kubernetes to use for the EKS cluster."
  default     = "1.27"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.10.1"

  cluster_name    = "LJ-eks"
  cluster_version = var.eks__version
  subnet_ids      = aws_subnet.private[*].id
  vpc_id          = aws_vpc.main.id
  aws_auth_roles = [
    {
      rolearn  = aws_iam_role.eks_worker_nodes.arn
      username = "newRole"
      groups   = ["system:masters"]
    }
  ]

  aws_auth_users = [

    {
      userarn  = "arn:aws:iam::183275805557:user/lroy15"
      username = "root"
      groups   = ["system:masters"]
    }
  ]

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
    }

  }

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true
  cluster_service_ipv4_cidr       = "172.16.0.0/16"
  create_aws_auth_configmap       = true



  manage_aws_auth_configmap = true


  eks_managed_node_group_defaults = {
    instance_types             = ["t2.medium"]
    ami_type                   = "AL2_x86_64"
    iam_role_attach_cni_policy = true
    aws_iam_role               = aws_iam_role.eks_worker_nodes.arn
  }

  eks_managed_node_groups = {
    blue = {
      min_size                   = 2
      max_size                   = 3
      desired_size               = 2
      instance_types             = ["t2.medium"]
      disk_size                  = 20
      use_custom_launch_template = false
    }
  }

  /*cluster_security_group_additional_rules = {
    ingress_ingress_controllers_to_cluster_api_443 = {
      description              = "Ingress controllers to cluster API 443"
      type                     = "ingress"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      source_security_group_id = aws_security_group.eks_ingress_base_sg.id
    }
  }
*/
}

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix      = "VPC-CNI-IRSA"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv6   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}


