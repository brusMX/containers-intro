# Service Fabric - Local Service Fabric Development 

One of the benefits is developing locally on your machine. On Windows, that allows for a great debugging experience allowing F5 debugging wiht Visual Studio and Eclipse for native applications.

In the first challenge you will:

- set up a development environment on your local machine
- deploy a containerized application into your cluster
- experience the resilience of service fabric applications

## Prerequisites 
 
Make sure you install the prerequisites installed

### Service Fabric SDK
- [SF SDK For Linux](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-get-started-linux)
- [SF SDK for Windows](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-get-started)
- [SF SDK for Mac](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-get-started-mac)

### Azure CLI
Install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) 

### Service Fabric CLI
and the [Service Fabric CLI](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cli)

For the 2nd exercise, you'll need an Azure Subscription and a VSTS account.

## Challenge 1
Get started with your local development environment.

### Description
Setup your local dev box, either on Windows, Mac or Linux.

### Success Criteria 
- sfctl is connected to the clsuter
- Service Fabric explorer displays in the browser from http://localhost:19080/Explorer.

### Tips
- For developing with Windows containers, it's best to run your local Service Fabric development machine on a Windows Server VM. The Visual Studio Community edition image will do.

## Challenge 2 - Deploying an Application
Familiarize yourself with managing applications.

### Description
*Windows* Deploy a containerized application running a single instance of the xtoph/webapp:1.0.0 container into your local environment. The webapp listens on port 5000. Make sure you configure Service Fabric to map the port. 

*Linux* Deploy a containerized application running a single instance of the xtoph/nginx:v1 container into your local environment. Nginx listens on port 80. Make sure you configure Service Fabric to map the port.

### Success Criteria
- The application shows deployed in Service Fabric explorer 
- *Windows* The MVC home page shows in your browser when accessed via the cluster DNS name 
- *Linux* The NGINX index page shows in your browser when accessed 
- Verify that it survives and "application crash" and update the application to the new version.

### Tips
- There are several ways to create the deployment files. Some are more straight forward than others. Sometimes creating from scratch isn't necessary. 
- Not all tools to deploy Service Fabric applictions accept all file formats.
- There are several formats of deployment files that Service Fabric will accept.  
- For some extra fun, locate the running NGINX container and `docker kill` the container.
- Watch Service Fabric explorer to see what happens. Try the service URL
- Connecting to a secure cluster from Linux can be a bit tricky: https://serverfault.com/questions/880176/connect-to-a-secure-azure-service-fabric-cluster-using-service-fabric-cli-sfctl


## Challenge 3 - No Downtime Changes

Scale and update a running service without downtime.

### Description
- Using the sfctl CLI increase the number of instances of the xtoph/nginx:v1 container from 1 to 3. Then update the version from *windows* xtoph/webapp:1.0.0 to xtoph/webapps:2.0.0 *Linux* xtoph/nginx:v1 to xtoph/nginx:v2.
- Watch the Service Fabric explorer during update and scale operations 

### Success criteria
- 3 running instances of the Service displayed in Service Fabric explorer
- Browser shows *windows* MVC Version 2 page or *Linux* xtoph/nginx:v2 welcome page

TODO: 
- Windows versions of my versioned container
- VSTS deployment
- 

https://serverfault.com/questions/880176/connect-to-a-secure-azure-service-fabric-cluster-using-service-fabric-cli-sfctl

