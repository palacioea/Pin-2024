resource "aws_iam_role" "my_role" {
  name = "role_admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "my_policy" {
  name        = "MyEC2Policy"
  description = "My policy for EC2 instances"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
       {
        Effect = "Allow"
        Action = [
          "ec2:CreateVolume",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DeleteVolume",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumeStatus"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = "*"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "my_attachment" {
  policy_arn = aws_iam_policy.my_policy.arn
  role       = aws_iam_role.my_role.name
}

# Adjuntar la política AmazonEBSCSIDriverPolicy al rol
resource "aws_iam_role_policy_attachment" "ebs_csi_driver_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.my_role.name
}

# Generar una nueva clave privada
resource "tls_private_key" "devops_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Crear un Key Pair en AWS usando la clave generada
resource "aws_key_pair" "devops" {
  key_name   = "devops"
  public_key = tls_private_key.devops_key.public_key_openssh
}

# Opcional: Guardar la clave privada en un archivo local
resource "local_file" "private_key" {
  content  = tls_private_key.devops_key.private_key_pem
  filename = "${path.module}/devops.pem"
}
