#!/bin/bash

# Variables

# Set AWS credentials 
aws sts get-caller-identity >> /dev/null
if [ $? -eq 0 ]
then
  echo "Credenciales testeadas, proceder con la creacion de cluster."

  # Creacion de cluster
 eksctl create cluster \
  --name eks-mundos-e \
  --region us-east-1 \
  --with-oidc \
  --nodegroup-name mundose \
  --node-type t2.large \
  --nodes 1 \
  --nodes-min 1 \
  --nodes-max 3 \
  --node-volume-size 20 \
  --ssh-access=false \
  --managed \
  --asg-access \
  --external-dns-access \
  --full-ecr-access \
  --appmesh-access \
  --alb-ingress-access

  if [ $? -eq 0 ]
  then

    #instalacion ebs driver
    kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.35"

    eksctl create iamserviceaccount \
     --name ebs-csi-controller-sa \
     --region us-east-1 \
     --namespace kube-system \
     --cluster mundos-e \
     --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
     --approve \
     --role-only \
     --role-name AmazonEKS_EBS_CSI_DriverRole

    eksctl create addon --name aws-ebs-csi-driver --region us-east-1 --cluster mundos-e --service-account-role-arn arn:aws:iam::654654500943:role/AmazonEKS_EBS_CSI_DriverRole --force 
    
    echo "Cluster Setup Completo con eksctl ."
  else
    echo "Cluster Setup Falló mientras se ejecuto eksctl."
  fi
else
  echo "Please run aws configure & set right credentials."
  echo "Cluster setup failed."
fi