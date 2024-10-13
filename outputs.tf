output "Ip-de-la-instancia" {
  value = aws_instance.mi_instancia
}

output "Nombre-del-Proyecto" {
  value = aws_instance.mi_instancia
}

output "Estado-de-la-instancia" {
  value = aws_instance.mi_instancia.instance_state
}
