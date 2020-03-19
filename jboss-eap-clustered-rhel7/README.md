# VM-Redhat - JBoss EAP 7 cluster mode
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-standalone-rhel8%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-clustered-rhel7%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

`Tags: JBoss, EAP, Red Hat,EAP7, CLUSTER, Azure, Azure VM, JavaEE, RHEL 7

<!-- TOC -->

1. [Solution Overview ](#solution-overview)
2. [Template Solution Architecture ](#template-solution-architecture)
3. [Licenses, Subscriptions and Costs ](#licenses-and-costs)
4. [Prerequisites](#prerequisites)
5. [Deployment Steps](#deployment-steps)
6. [Deployment Time](#deployment-time)
7. [Post Deployment Steps](#post-deployment-steps)

<!-- /TOC -->

## Solution Overview

JBoss EAP is an open source platform for highly transactional, web-scale Java applications. EAP combines the familiar and popular Jakarta EE specifications with the latest technologies, like Microprofile, to modernize your applications from traditional Java EE into the new world of DevOps, cloud, containers, and microservices. EAP includes everything needed to build, run, deploy, and manage enterprise Java applications in a variety of environments, including on-premise, virtual environments, and in private, public, and hybrid clouds.

Red Hat Subscription Management (RHSM) is a customer-driven, end-to-end solution that provides tools for subscription status and management and integrates with Red Hat's system management tools. To obtain a rhsm account go to: www.redhat.com and sign in.

This template deploys a web applicaton deployed on JBoss EAP 7.2 cluster running on RHEL 7.7.

## Template Solution Architecture
This template creates all of the compute resources to run JBoss EAP 7 on top of RHEL 7.7, deploying the following components:

- RHEL 7.7 VM 
- Public DNS 
- Private Virtual Network 
- Security Configuration 
- JBoss EAP 7
- Sample application deployed to JBoss EAP 7

Following is the Architecture :

<img src="images/eap-rhel-arch.png" width="800">

To learn more about the JBoss Enterprise Application Platform, visit:
https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/


## Licenses and Costs

This template uses a RHEL 8.0 image which is a Pay-as-you-go (PAYG) image and does not require the user to License.  The VM will be licensed automatically after the instance is launched for the first time and the user will be charged hourly in addition to Microsoft's Linux VM rates.  Click [here](https://azure.microsoft.com/en-gb/pricing/details/virtual-machines/linux/#red-hat) for pricing details. You will also need to have a RedHat subscription (RHSM). Click [here] (https://access.redhat.com/products/red-hat-subscription-management) to know more about RHSM and pricing.

## Solution overview and deployed resources
This template creates all of the Azure compute resources to run JBoss EAP 7 on top of RHEL 7.7.  The following resources are created by this template:
- RHEL 7.2 VM 
- Public DNS 
- Private Virtual Network 
- Security Configuration 
- JBoss EAP 7
- Sample application deployed to JBoss EAP 7


## Prerequisites

1. Azure Subscription with specified payment method (RHEL 8 is a marketplace product and requires a payment method to be specified in the Azure Subscription)

2. To deploy the template, you will need:

   - **Admin Username** and password
   
   - **VM Name**
   
   - **EAP username** and password 
   
   - **RHSM Username** and password
   
   - **SSH Key Data** which is an SSH RSA public
   
## Deployment Steps

Build your environment with EAP 7.2 on top of RHEL 8.0 on Azure in a few simple steps:

   - **Subscription** - Choose the appropriate subscription where you would like to deploy.

   - **Resource Group** - Create a new Resource Group or you can select an existing one.

   - **Location** - Choose the appropriate location for your deployment.

   - **Admin Username** - User account name for logging into your RHEL VM.

   - **Admin Password** - User account password for logging into your RHEL VM.
   
   - **DNS Label Prefix** - DNS Label for the Public IP. Must be lowercase. It should match with the following regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$ or it will raise an error.

   - **EAP Username** - User name for EAP Console.

   - **EAP Password** - User account password for EAP Console.
    
   - **RHSM Username** - User name for RedHat account.

   - **RHSM Password** - User account password for RedHat account.
   
   - **RHSM Pool ID** - RedHat subscription Manager Pool ID (must contain JBoss EAP entitlement)
    
   - **SSH Key Data** - Generate an SSH key using Puttygen and provide the data here.
   
   - **VM Size** - Choose the appropriate size of the VM from the dropdown options. 

   - Leave the rest of the Parameter Values (artifacts and Location) as is and proceed to purchase. 

<img src="images/parameters.png" width="800">

## Deployment Time 

The deployment takes about 10 minutes to complete.

<img src="images/deploySucceeded.png" width="800">

## Post Deployment Steps

- Once the deployment is successful, click on the "Outputs" to see the URL of the SSH Command, App WEB URLs:

<img src="images/templateOutput.png" width="800">

- Copy the string from the "sshCommand" field. Open a terminal tool(or cmd window) and paste the string to access a VM on Azure cloud.

- Enter the VM Username and Password, the "Admin User" and "Admin Password" you provided before you deployed the template.

- Once you login into the VM, you can go through a server.log on JBoss EAP how Jgroup discovery works for clustering:

<img src="images/ssh_command.png" width="800">

-When you look at one of server logs ( i.e. node1 or node2 ), you should be able to identify the JGroups cluster members being added `Received new cluster view:`

<img src="images/session-replication-logs.png" width="800">

- Copy the App URL from the output section of the template. Open a web browser and paste the link, You will see Testing EAP Session Replication web page.

<img src="images/session-application-app0.png" width="800">

- The web application displays the Session ID, Session `counter` and `timestamp` (these are variables stored in the session that are replicated) and the container name that the web page and session is being hosted from.

- Now, select the **Increment Counter** link. The session variable will increase.

<img src="images/session-replication-increment.png" width="800">

## Notes
