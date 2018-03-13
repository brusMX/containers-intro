# Service Fabric - DevOps in the Cloud Development 

This set of challenges deploys containers into a Service Fabric cluster in the cloud using VSTS builds and releases.

## Prerequisites

### Azure CLI
To create your service fabric cluster in Azure  (Install the Azure CLI)[LINK]

### VSTS Reease and Build
Create a new VSTS project to manage build and release pipelines

## Challenge 4 - Deploy to Azure
Now deploy your application to Azure Service Fabric

### Description
- Provision a Service Fabric cluster in Azure. Pick an operating system that matches your development environment
- Deploy the application running 3 instances of the xtoph/nginx:v2 container using the `sftctl` CLI

### Success Criteria
- Service Fabric explorer in the browser from an Azure URL
- xtoph/nginx:v2 welcome page displays

### Tips
- The Service Fabric Reverse Proxy is currently not supported in Linux clusters. CSE has published work arounds on the Developer Blog


## Challenge 5 - Deploy using a VSTS Release
Production applications rarely deployed from the CLI. Production uses CI/CD pipelines. Let's build a VSTS build/release pipeline to deploy the application into the cluster. In a real production environment, we'd build the container images, but for this challenge, we'll keep things simple and only deploy existing images. 

### Description
- 
### Success Criteria
- Service Fabric Explorer shows 2 deployed applications, with 3 replicas each
- CI/CD Application Name includes the VSTS build number
- Application is accessible via Azure URL
- 
