---
title: Quickstart - WildFly on CentOS
description: Deploy Java applications to WildFly on CentOS VM
services: virtual-machines-linux
documentationcenter: ''
author: RockClimberT
manager: westonh
editor: ''
ms.date: 10/23/2020
---

# Quickstart: WildFly on CentOS 8

This Quickstart shows you how to deploy the standalone node of WildFly of CentOS 8 VM. This is ideal for development and testing of enterprise Java applications on Azure. Application server subscription is not required to deploy this quickstart.

## Prerequisites

* An Azure account with an active subscription. If you don't have an Azure subscription, you can activate your [MSDN subscriber benefits](https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details) or [create an account for free](https://azure.microsoft.com/pricing/free-trial).

## Use case

WildFly is ideal for development and testing of enterprise Java applications on Azure. List of technologies available in WildFly 18 server configuration profiles are available in the [WildFly Getting Started Guide](https://docs.wildfly.org/18/Getting_Started_Guide.html#getting-started-with-wildfly).

You can use WildFly in either Standalone or Cluster mode per your use case. You can ensure high availability of critical Jakarta EE applications by WildFly on a cluster of nodes. Make a small number of application configuration changes, and then deploy the application in the cluster. To learn more about this please check the [WildFly High Availability Guide](https://docs.wildfly.org/18/High_Availability_Guide.html).

## Configuration choice

WildFly can be booted in **Standalone Server** mode - A standalone server instance is an independent process, much like a JBoss Application Server (AS) 3, 4, 5, or 6 instance. Standalone instances can be launched via the standalone.sh or standalone.bat launch scripts. If more than one standalone instance is launched and multi-server management is desired, it is the user’s responsibility to coordinate management across the servers.

You can also start WildFly instance with alternate configuration by using configuration files available in configuration folder.

Following are the Standalone Server Configuration files:

- standalone.xml (default) - This is the default file used for starting the WildFly instance. It contains Jakarta Web Profile certified configuration with the required technologies.
   
- standalone-ha.xml - Jakarta EE Web Profile 8 certified configuration with high availability (targeted at web applications).
   
- standalone-full.xml - Jakarta EE Platform 8 certified configuration including all the required technologies for hosting Jakarta EE applications.

- standalone-full-ha.xml - Jakarta EE Platform 8 certified configuration with high availability for hosting Jakarta EE applications.

To start your standalone WildFly server with another provided configuration, use the --server-config argument with the server-config file.

For example, to use the Jakarta EE Platform 8 with clustering capabilities use the following command:

`./standalone.sh --server-config=standalone-full-ha.xml`

To learn more about the configurations check the [WildFly Getting Started Guide](https://docs.wildfly.org/18/Getting_Started_Guide.html#wildfly-10-configurations).

## Licensing, support, Support and subscription notes

Azure CentOS 8 image is a Pay-As-You-Go (PAYG) VM image and does not require the user to obtain a license. The VM will be licensed automatically after the instance is launched for the first time and the user will be charged hourly rate in addition to Microsoft's Linux VM rates. Click [Linux VM Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#linux) for details. WildFly is free to download and use and does not require a Red Hat subscription or license.

## How to consume

You can deploy the template in the following 3 ways:

- Use PowerShell - Deploy the template by running the following commands: (Check out [Azure Powershell](https://docs.microsoft.com/en-us/powershell/azure/?view=azps-2.8.0) for information on installing and configuring Azure PowerShell).

    `New-AzResourceGroup -Name <resource-group-name> -Location <resource-group-location> #use this command when you need to create a new Resource Group for your deployment`

    `New-AzResourceGroupDeployment -ResourceGroupName <resource-group-name> -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/wildfly-standalone-centos8/azuredeploy.json`
    
- Use Azure CLI - Deploy the template by running the following commands: (Check out [Azure Cross-Platform Command Line](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) for details on installing and configuring the Azure Cross-Platform Command-Line Interface).

    `az group create --name <resource-group-name> --location <resource-group-location> #use this command when you need to create a new Resource Group for your deployment`

    `az group deployment create --resource-group <my-resource-group> --template-uri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/wildfly-standalone-centos8/azuredeploy.json`

- Use Azure Portal - Deploy the template by clicking <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2Fwildfly-standalone-centos8%2Fazuredeploy.json" target="_blank">here</a> and log into your Azure portal.

## ARM template

<a href="https://github.com/Azure/azure-quickstart-templates/tree/master/wildfly-standalone-centos8" target="_blank"> WildFly 18 on CentOS 8 (stand-alone VM)</a> - This is a Quickstart template that creates a standalone node of WildFly 18.0.1.Final on CentOS 8 VM in your Resource Group (RG) which includes a Private IP for the VM, Virtual Network and Diagnostics Storage Account. It also deploys a sample Java application named JBoss-EAP on Azure on WildFly.

## Resource Links:

* Learn more about [WildFly 18](https://wildfly.org/18)
* Learn more about [Linux distributions on Azure](https://docs.microsoft.com/azure/virtual-machines/linux/endorsed-distros)
* [Azure for Java developers documentation](https://github.com/JasonFreeberg/jboss-on-app-service)

## Next steps

For production environment, check out the Red Hat JBoss EAP Azure Quickstart ARM templates:

Stand-alone RHEL virtual machine with sample application:

*  <a href="https://github.com/Azure/azure-quickstart-templates/tree/master/jboss-eap-standalone-rhel" target="_blank"> JBoss EAP on RHEL (stand-alone VM)</a>

Clustered RHEL virtual machines with sample application:

* <a href="https://github.com/Azure/azure-quickstart-templates/tree/master/jboss-eap-clustered-multivm-rhel" target="_blank"> JBoss EAP on RHEL (clustered VMs)</a>

Clustered RHEL virtual machine scale set with sample application:

* <a href="https://github.com/Azure/azure-quickstart-templates/tree/master/jboss-eap-clustered-vmss-rhel" target="_blank"> JBoss EAP on RHEL (clustered VMSS)</a>
