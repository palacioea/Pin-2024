# Crear el perfil de instancia IAM
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.my_role.name  # Referencia directa al rol definido en iam.tf
}

# Crear la instancia EC2
resource "aws_instance" "mi_instancia" {
  ami                    = "ami-005fc0f236362e99f" # Usa una variable para la AMI
  instance_type          = var.ec2_instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  subnet_id              = aws_subnet.main.id
  key_name               = aws_key_pair.devops.key_name  # Asumiendo que el key pair está definido
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  user_data = file("script/apps_install.sh")

  tags = {
    Name = var.ec2_name
  }
}