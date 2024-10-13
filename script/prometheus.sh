#!/bin/bash
# Instalar Prometheus y Grafana usnado Helm (Manejador de paquetes para kubernetes)

# Agregar repo de prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Agregar repo de grafana
helm repo add grafana https://grafana.github.io/helm-charts

helm repo update
# Crear el namespace prometheus
kubectl create namespace prometheus

# Desplegar prometheus en EKS
#Prometheus config
echo "server:
  persistentVolume:
    enabled: false
service:
  type: NodePort
alertmanager:
  enabled: false" > ~/prometheus.yaml

helm install prometheus prometheus-community/prometheus --namespace prometheus --values ~/prometheus.yaml

kubectl patch svc prometheus-server -n prometheus -p '{"spec": {"type": "NodePort"}}'

# Verificar la instalación
kubectl get all -n prometheus
