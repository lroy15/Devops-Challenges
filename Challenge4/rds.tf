output "retrieved_output" {
  value = module.eks.cluster_primary_security_group_id
}




# Create a VPC security group

resource "aws_security_group" "rds_sg" {
  vpc_id      = aws_vpc.main.id
  name        = "RDS_sg"
  description = "To EKS vpc"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.eks.cluster_primary_security_group_id]
  }

}


# Create an RDS instance
resource "aws_db_instance" "ljrds" {
  identifier             = "lj-db"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = "root"
  password               = "basicpassword"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # Additional configuration options
  multi_az            = false
  publicly_accessible = true
  skip_final_snapshot = true
  deletion_protection = false

  # Specify subnet group and parameter group
  db_subnet_group_name = aws_db_subnet_group.subnetgroup.id
  #parameter_group_name = aws_db_parameter_group.example.name

}

# Create a DB subnet group
resource "aws_db_subnet_group" "subnetgroup" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.private[*].id # Replace with your subnet IDs
}

# Create a DB parameter group
/*resource "aws_db_parameter_group" "example" {
  name        = "example-db-parameter-group"
  family      = "mysql5.7"
  description = "Example DB parameter group"
  parameter {
    name  = "max_connections"
    value = "100"
  }
}*/
