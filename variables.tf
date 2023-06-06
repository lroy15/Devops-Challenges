variable "sg_rules_ingress" {
  type = list(object({
    to_port     = string
    from_port   = string
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      to_port     = 0
      from_port   = 0
      protocol    = "-1"
      cidr_blocks = ["10.0.0.0/16"]
    },
    {
      to_port     = 6443
      from_port   = 6443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      to_port     = 443
      from_port   = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

variable "sg_rules_egress" {
  type = list(object({
    to_port     = string
    from_port   = string
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

