kubectl create namespace grafana

helm install grafana grafana/grafana \
    --namespace grafana \
    --set adminPassword='EKS!sAWSome' \
    --values grafana.yaml \
    --set service.type=LoadBalancer

