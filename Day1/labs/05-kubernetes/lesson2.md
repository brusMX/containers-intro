# Kubernetes Deployment Versions

*   Create  templateV1 deployment. This deployment includes 2 replicas and nginx container with 1.7.9 tag
*  	Get all pods with app=nginx
*   Describe a specific pod and check the version.
*   Apply templateV2.yaml. The nginx version is 1.8.
*   Get all pods with app=nginx
*   Describe a specific pod and check the version.
*   Apply templateV3.yaml. The replica count is updated to 4. 
*   Verify the replica count Get all pods.

kubectl create -f templateV1.yaml

## Show pods
kubectl get pods -l app=nginx

## Describe specific pod
kubectl describe pod <pod-name>

## Update V2 template 
kubectl apply -f templateV2.yaml

## Show pods
kubectl get pods -l app=nginx

## Describe specific pod
kubectl describe pod <pod-name>

## Update V2 template
kubectl apply -f templateV3.yaml

## Show pods
kubectl get pods -l app=nginx

# Wordpress with MySQL and Azure Disks

Deploy a WordPress site and a MySQL database. Both applications use PersistentVolumes and PersistentVolumeClaims to store data.

Steps
* Create a Persistent Volume
* Create a Secret
* Deploy MySQL
* Deploy WordPress

## Create a Persistent Volume

kubectl create -f deployment-storage.yaml

## Run the following command to verify that two 32GiB PersistentVolumes are available:

kubectl get pv

## Create a MySQL secret

kubectl create secret generic mysql-pass --from-literal=password=YOUR_PASSWORD

## Verify that the Secret exists by running the following command:

kubectl get secrets

## Deploy MySQL from the mysql-deployment.yaml file:

kubectl create -f mysql-deployment.yaml

## Verify Pod is running 

kubectl get pods

## Create a WordPress Service and Deployment from the wordpress-deployment.yaml file:

kubectl create -f wordpress-deployment.yaml

## Verify that the Service is running by running the following command

kubectl get services wordpress




