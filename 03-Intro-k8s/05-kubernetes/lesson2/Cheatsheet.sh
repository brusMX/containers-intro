#! /bin/sh
#! /bin/sh

# deploy storage
kubectl create -f deployment-storage.yaml
kubectl get pv

# check if pvc has successfully been deployed
kubectl get pvc
kubectl describe pvc

# add secret for MySQL
kubectl create secret generic mysql-pass --from-literal=password=P@ssw0rd1234
kubectl get secrets

# deploy MySQL
kubectl create -f deployment-mysql.yaml
kubectl get pods

# deploy Wordpress
kubectl create -f deployment-wordpress.yaml
kubectl get services wordpress



# Create V1 template
kubectl create -f templateV1.yaml

# Show pods
kubectl get pods -l app=nginx

# Describe specific pod
kubectl describe pod <pod-name>

# Update V2 template 
kubectl apply -f templateV2.yaml

# Show pods
kubectl get pods -l app=nginx

# Describe specific pod
kubectl describe pod <pod-name>

# Update V2 template
kubectl apply -f templateV3.yaml

# Show pods
kubectl get pods -l app=nginx
