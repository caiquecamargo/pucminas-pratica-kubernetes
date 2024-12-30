#!/bin/bash

kubectl delete -f k8s/frontend-deployment.yaml 
kubectl apply -f k8s/frontend-configmap.yaml
kubectl apply -f k8s/frontend-deployment.yaml

