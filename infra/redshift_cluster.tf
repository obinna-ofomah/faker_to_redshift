# create the cluster
resource "aws_redshift_subnet_group" "obinna_subnet_grp" {
  name       = "obinna-subnets-grp"
  subnet_ids = [aws_subnet.obinna_public_subnet_1.id, aws_subnet.obinna_public_subnet_2.id]

  tags = {
    environment = "Development"
  }
}

data "aws_ssm_parameter" "db_password" {
  name = "redshift_cluster_password"
}

resource "aws_redshift_cluster" "obinna_redshift_cluster" {
  cluster_identifier        = "redshift-cluster"
  database_name             = "obinna_database"
  master_username           = "obinna"
  master_password           = data.aws_ssm_parameter.db_password.value
  node_type                 = "ra3.large"
  cluster_type              = "multi-node"
  iam_roles                 = [aws_iam_role.redshift_role.arn]
  number_of_nodes           = 2
  publicly_accessible       = true
  cluster_subnet_group_name = aws_redshift_subnet_group.obinna_subnet_grp.name
  vpc_security_group_ids    = [aws_security_group.obinna_sg.id]

  tags = {
    Name = "obinna_redshift_cluster"
  }
}