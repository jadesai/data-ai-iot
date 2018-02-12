# Setting up for the Tutorial

The following steps will get you up and running with the tutorial. For the sake of consistency, we have attempted to automate as many of the steps as possible to avoid running into issues during the setup phase, but as much as possible we try to do so in a transparent fashion so users know what is happening under the hood. We also try to give you more than one way to perform the setup using the commandline via the [Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest), the [Azure portal](https://portal.azure.com/), the [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/microsoft-ads.linux-data-science-vm-ubuntu?tab=Overview), and/or [AI Quickstarts](https://quickstart.azure.ai/). In addition to getting your environment ready for the tutorial, the following outline can also serve as a short tutorial on how to manage Azure resource like a power user by leveraging the Azure CLI.

## Part 0: What are the Prerequisites I need on my Computer and where do I get the Setup Files?

### Prerequisites

 * [Git](https://git-scm.com/downloads)
 * [Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) 
 * [Visual Studio Code](https://code.visualstudio.com/)

### Setup Files
The files for setup are available on GitHub and can be cloned or downloaded from [here](https://github.com/Azure/data-ai-iot)

`git clone https://github.com/Azure/data-ai-iot.git`


## Part 1: Provisioning a Windows Data Science Virtual Machine

We will be using the [Windows Data Science Virtual Machine (DSVM)](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/microsoft-ads.windows-data-science-vm) on Azure. Please follow these steps to get the DSVM ready for the tutorial. There are three ways to provision a DSVM: through the [Azure portal UI](https://portal.azure.com/), programatically using the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) and an [ARM template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authoring-templates), or through [AI Quickstarts](https://quickstart.azure.ai/). 

### 1.1 Provisioning a Windows DSVM using the Azure portal (15 minutes)

1. Open this location and follow the instructions [shown here](https://docs.microsoft.com/en-us/azure/machine-learning/data-science-virtual-machine/provision-vm).
  a) Select the Data Science Virtual Machine - Windows 2016;
  b) Use `aiuser` and `BigDataAI2018!` as the admin user name and password.  Feel free to use an user name and password of your own.  These are only suggestions and are the default in the parameters.json files we will use in the Azure CLI in section 1.3
  c) Select SDD Drives;
  d) Select D4S_v3 as the size (only available in [certain locations](https://azure.microsoft.com/en-us/blog/introducing-the-new-dv3-and-ev3-vm-sizes)).

If we do not wish to learn how to provision a DSVM using the Azure CLI instead of the Azure portal, we can now skip to [Preparing the environment](#preparing-the-environment).

### 1.2 **(Optinal)** Installing the Linux `bash` command prompt on Windows (15 minutes)

The Azure CLI is a command line utility for provisioning and managing Azure resources. It works on both Windows and Linux. Windows users can use it from the `cmd` command prompt, or alternatively, we can install the `bash` command prompt on Windows.

1. From the **Start Menu**, search for **Turn Windows features on or off**, then scroll down and make sure **Windows subsystem for Linux** is activated. If it is not, activate it and restart the computer.
2. Type `cmd` from the **Start Menu** and right-click on **Command Prompt** to launch it as administrator.
3. In the command prompt, run `bash`. If `bash` is already installed on Windows then we will be presented with the `bash` command prompt. Otherwise, it will get installed for us.

### 1.3 Provisioning a Windows DSVM using the Azure CLI (30 minutes)

1. Download and install the [Azure CLI Installer (MSI)](https://aka.ms/InstallAzureCliWindows). Once the installation is complete open the command prompt and run `az login`, then copy the access code returned to us. In a browser, open a **private tab** and enter the URL `aka.ms/devicelogin`. When prompted, paste in the access code from above. You will be prompted to authenticate using our Azure account.  Go through the appropriate multifaction authenication.
2. Log into the Azure Portal and click on the Create a resource green + sign in the left panel and search for and select **Data Science Virtual Machine - Windows 2016**. On the resources' page, click on the link in the buttom that says <u>Want to deploy programmatically? Get started</u>
Scroll down and make sure that the status is enabled for the intended subscription.
2. From **Windows Explorer** navigate to the course folder and from there launch the command prompt by going to the address bar and typing `cmd` (for the Windows command prompt) or `bash` (for the Linux command prompt assuming it is installed already) and type `az --version` to check the installation. 

3. When you logged in to the CLI in step 1 above you will see a json list of all the Azure account you have access to. Run `az account show` to see you current active account.  Run `az account list -o table` if you want to see all of you Azure account in a table. If you would like to switch to another Azure account run `az account set --subscription <your SubscriptionId>` to set the active subcription.  Run `az group create -n aitutorial -l westcentralus` to create a resource group called `aitutorial`. Change directory to `cd arm/wdsvm`. Next run the following command to provision the DSVM:
```
az group deployment create -g aitutorial --template-file template-wdsvm.json --parameters @parameters-wdsvm.json
```
Once the provisioning is finished, we can run `az resource list -g aitutorial -o table` to check what resources were launched. Our listed resources includes a DSVM called `bdaireadywdsvm`, which we provided in the `parameters.json` file.  
FYI, you can start/stop/restart your VM using the corresponding commands below:
```
az vm start -g aitutorial -n bdaireadywdsvm
az vm stop -g aitutorial -n bdaireadywdsvm
az vm restart -g aitutorial -n bdaireadywdsvm
```
Note: You can also start/stop/restart your VM in the Azure portal UI.

### 1.4 Provisioning a Windows DSVM using the Azure AI Quickstart (15 minutes)
To provision a Windows Data Science VM from Azure AI Quickstarts click [here](https://quickstart.azure.ai/Deployments/new/datasciencevm?source=CiqsGallery). Enter a Deployment name, choose a Subscription and Location and click Create. Next you will be asked to provide configuration parameters.  Enter a Username, Password, and Name, and select a VM Size and click Next.

### 1.5 Provisioning a Windows DSVM using the Azure Marketplace (15 minutes)
To provision a Windows Data Science VM from the Azure Marketplace click [here](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/microsoft-ads.windows-data-science-vm)

## Part 2: Preparing the Windows DSVM to run Azure ML Workbench

### 2.1 Installing Workbench and creating an ML account (30 minutes)

We now have a Windows DSVM provisioned and almost ready to use. In this part, we log into the DSVM and install the necessary pre-requsites in order to start using Azrue ML Workbench (or Workbench for short). In order to log into the DSVM, we type `rdp` from the **Start Menu** and click on **Remote Desktop Connection**. We then enter the DSVM's Public IP address or DNS name, which we can find by logging into the Azure portal and clicking on the DSVM under our resource group `aitutorial`.
You can also click on Connect on the VMs Overview page to download the Remote Desktop Connection .rdp file.

1. On the DSVM, open the browser and navigate to [https://aka.ms/azureml-wb-msi](https://aka.ms/azureml-wb-msi), run the downloader to install Workbench by double clicking on the AmlWorkbenchSetup.msi in the Downloads directory.

    Double-click the downloaded installer **AmlWorkbenchSetup.msi** from File Explorer.

   >[!IMPORTANT]
   >Download the installer fully on disk, and then run it from there. Do not run it directly from your browser's download widget. Installation will take between 10 and 20 minutes.
2. Finish the installation by following the on-screen instructions.

   The installer downloads all the necessary dependent components, such as Python, Miniconda, and other related libraries. The installation might take around half an hour to finish all the components. 
3. Azure Machine Learning Workbench is now installed in the following directory:
   
   `C:\Users\<user>\AppData\Local\AmlWorkbench`
4. Sign in to the Azure portal and [Create your Azure Machine Learning accounts](https://docs.microsoft.com/en-us/azure/machine-learning/preview/quickstart-installation#create-azure-machine-learning-accounts) by following the directions in the link.

### 2.2 Preparing the Workbench to run a project (10 minutes)

For the remainder of this tutorial, you will be working exclusively on the DSVM. So log into the DSVM and then run through the steps outlined here.

1. Launch the Azure Machine Learning Workbench. When prompted to authenticate using an Azure account, please do so.
2. Click on initials at the bottom-left corner of the Workbench and make sure that we are using the correct account (namely the Experimentation account and matching Model Management account we created in section 2.1.4).
3. Go to **File > Configure Project IDE** and name the IDE `Code` with the following path `C:\Program Files\Microsoft VS Code\Code.exe`. Click OK to configure IDE.  This will allow us to open the entire project in Visual Studio Code, which is our editor of choice for this Tutorial.
4. Go to **File > New Project** to creat a new project.  Enter a Project name like `FirstProject`, and Project directory like `C:\workbench`, and search Project Templates for `MMLSpark` to bring bring up the `MMLSpark on Adult Census` template. Select the template and click on Create.
**Note:** that you should create the projects closer to file system root, for example C:/AzureML to avoid issues like in **Get the model file(s)** in Part 5 below.
5. Go to **File > Open Project (VSCode)** to open the project in Visual Studio Code. It is not necessary to use Code to make edit our course files but it is much more convenient. We will return to Code when we need to make changes to the existing scripts.
6. We now log into the Azure CLI using our Azure account. Return to the Workbench and go to **File > Open Command Prompt**. Check that the Azure CLI is installed on the DSVM by typing `az -h`. Now type `az login` and copy the access code. In Firefox open a **private tab** using **CTRL+SHIFT+P** then enter the URL `aka.ms/devicelogin` and when prompted, paste in the access code. Next, authenticate using an Azure account.
7. We now set the Azure CLI to use the right Azure account. From the command prompt, enter `az account list –o table` to see available accounts. Then copy the subscription ID from the Azure account used to create an AML Workbench account and type `az account set –s <subscription_id>`, replacing `<subscription_id>` with the account ID. You can enter `az account show` to see if the account is set correctly.

### 2.3 Complete an AML Workbench project template

Once you have completed the Workbench install you might want to try an AML Workbench project template. Such and example is using MMLSpark to classify adult income level

#### Create a new Workbench project

Note you may have already done this above in section 2.2.4.  If not create a new project by using this example as a template:
1.	Open Machine Learning Workbench.
2.	On the **Projects** page, select the **+** sign, and select **New Project**.
3.	In the **Create New Project** pane, fill in the information for your new project.
4.	In the **Search Project Templates** search box, type **`MMLSpark on Adult Census`**, and select the template.
5.	Select **Create**.

**Note:** that you should create the projects closer to file system root, for example C:/AzureML to avoid issues like in **Get the model file(s)** in Part 5 below.

Have a look at the folders, code, and configuration files.

Once you are finished the AML Workbench install and created a new project using the **MMLSpark on Adult Census** template you will need to proceed to provisioning the Linux DSVM which will be used for a remote Docker container for completing this project template.

## Part 3: Provisioning a Linux Data Science Virtual Machine

We will be using the [Data Science Virtual Machine fo Linux (Ubuntu)](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/microsoft-ads.linux-data-science-vm-ubuntu) on Azure. Please follow these steps to get the DSVM ready for the tutorial. There are three ways to provision a DSVM: through the [Azure portal UI](https://portal.azure.com/), programatically using the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) and an [ARM template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authoring-templates), or through [AI Quickstarts](https://quickstart.azure.ai/). 

### 3.1 Provisioning a Linux DSVM using the Azure portal (15 minutes)

1. Open this location and follow the instructions [shown here](https://docs.microsoft.com/en-us/azure/machine-learning/data-science-virtual-machine/dsvm-ubuntu-intro).
  a) Select the Data Science Virtual Machine for Linux (Ubuntu);
  b) Use `aiuser` and `BigDataAI2018!` as the admin user name and password.  Feel free to use an user name and password of your own.  These are only suggestions and are the default in the parameters.json files we will use in the Azure CLI in section 1.3
  c) Select SDD Drives;
  d) Select D4S_v3 as the size (only available in [certain locations](https://azure.microsoft.com/en-us/blog/introducing-the-new-dv3-and-ev3-vm-sizes)).

If we do not wish to learn how to provision a DSVM using the Azure CLI instead of the Azure portal, we can now skip to [Preparing the environment](#preparing-the-environment).

### 3.2 **(Optinal)** Installing the Linux `bash` command prompt on Windows (15 minutes)

The Azure CLI is a command line utility for provisioning and managing Azure resources. It works on both Windows and Linux. Windows users can use it from the `cmd` command prompt, or alternatively, we can install the `bash` command prompt on Windows.

1. From the **Start Menu**, search for **Turn Windows features on or off**, then scroll down and make sure **Windows subsystem for Linux** is activated. If it is not, activate it and restart the computer.
2. Type `cmd` from the **Start Menu** and right-click on **Command Prompt** to launch it as administrator.
3. In the command prompt, run `bash`. If `bash` is already installed on Windows then we will be presented with the `bash` command prompt. Otherwise, it will get installed for us.

### 3.3 Provisioning a Linux DSVM using the Azure CLI (30 minutes)

1. Download and install the [Azure CLI Installer (MSI)](https://aka.ms/InstallAzureCliWindows). Once the installation is complete open the command prompt and run `az login`, then copy the access code returned to us. In a browser, open a **private tab** and enter the URL `aka.ms/devicelogin`. When prompted, paste in the access code from above. You will be prompted to authenticate using our Azure account.  Go through the appropriate multifaction authenication.
2. Log into the Azure Portal and click on the Create a resource green + sign in the left panel and search for and select **Data Science Virtual Machine for Linux (Ubuntu)**. On the resources' page, click on the link in the buttom that says <u>Want to deploy programmatically? Get started</u>
Scroll down and make sure that the status is enabled for the intended subscription.
2. From **Windows Explorer** navigate to the course folder and from there launch the command prompt by going to the address bar and typing `cmd` (for the Windows command prompt) or `bash` (for the Linux command prompt assuming it is installed already) and type `az --version` to check the installation. 

3. When you logged in to the CLI in step 1 above you will see a json list of all the Azure account you have access to. Run `az account show` to see you current active account.  Run `az account list -o table` if you want to see all of you Azure account in a table. If you would like to switch to another Azure account run `az account set --subscription <your SubscriptionId>` to set the active subcription.  Run `az group create -n aitutorial -l westcentralus` to create a resource group called `aitutorial`. Note if you are deploying the Linux DSVM into the same resource group as the Windows DSVM from Part 1 you don't need to create a resource group (in fact you will get an error that the resource group already exists). Change directory to `cd arm/ldsvm`. Next run the following command to provision the DSVM:
```
az group deployment create -g aitutorial --template-file template-ldsvm.json --parameters @parameters-ldsvm.json
```
Once the provisioning is finished, we can run `az resource list -g aitutorial -o table` to check what resources were launched. Our listed resources includes a DSVM called `bdaireadyldsvm`, which we provided in the `parameters.json` file.  
FYI, you can start/stop/restart your VM using the corresponding commands below:
```
az vm start -g aitutorial -n bdaireadyldsvm
az vm stop -g aitutorial -n bdaireadyldsvm
az vm restart -g aitutorial -n bdaireadyldsvm
```
Note: You can also start/stop/restart your VM in the Azure portal UI.

### 3.4 Provisioning a Linux DSVM using the Azure AI Quickstart (5 minutes)
To provision a Windows Data Science VM from Azure AI Quickstarts click [here](https://quickstart.azure.ai/Deployments/new/linuxdatasciencevm?source=CiqsGallery). Enter a Deployment name, choose a Subscription and Location and click Create. Next you will be asked to provide configuration parameters.  Enter a Username, Password, and Name, and select a VM Size and click Next.

### 3.5 Provisioning a Linux DSVM using the Azure Marketplace (5 minutes)
To provision a Linux Data Science VM from the Azure Marketplace click [here](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/microsoft-ads.linux-data-science-vm-ubuntu)

## Part 4: Connecting to the Linux DSVM and Jupyter Hub

### 4.1 Connecting to the Linux DSVM (5 minutes)

We now have a Linux DSVM provisioned and almost ready to use. In this part, we log into the Linux DSVM. In order to log into the Linux DSVM, we enter the DSVM's Public IP address or DNS name, which we can find by logging into the Azure portal and clicking on the Linux DSVM under our resource group `aitutorial`. You can also click on Connect on the VMs Overview page to view the ssh connection information.  It will look something like this `ssh aiuser@13.78.175.241`

## Accessing your VM

You can access your newly created Data Science VM for Linux in several ways.

#### Terminal

Use the following credentials to log in:
* *SSH Command*: `ssh aiuser@<publicipaddress>`

#### X2Go Client

You can download The X2Go client from the [X2Go site](http://wiki.x2go.org/doku.php/start).

* *Host*: `<publicipaddress>`
* *Login*: `<adminUsername>`
* *SSH port*: 22
* *Session Type*: Change the value to _XFCE_

#### PuTTY

You can download PuTTY from the [PuTTY site](http://www.putty.org/).

* *Host Name*: `<publicipaddress>`
* *Port*: 22
* *Connection Type*: SSH
* *login as*: `<adminUsername>`

#### Azure Portal

* Click [here](https://portal.azure.com) to log into the Azure portal and click on the Linux DSVM under your resource group `aitutorial`.

### 4.2 Connecting to Jupyterhub

The Anaconda distribution in the DSVM comes with a Jupyter notebook, a cross-platform environment to share Python, R, or Julia code and analysis. The Jupyter notebook is accessed through JupyterHub. You sign in using your local Linux user name and password at `https://<VM DNS name or IP Address>:8000/`. 

All configuration files for JupyterHub are found in directory /etc/jupyterhub.

## Part 5: Using MMLSpark to classify adult income level

### Run this sample:

Configure a compute environment `remotevm` targeting a Docker container running on a remote Linux DSVM.
```
$ az ml computetarget attach remotedocker --name remotevm --address <ip address or FQDN> --username <username> --password <pwd>

# prepare the environment
$ az ml experiment prepare -c remotevm
```

Run train_mmlspark.py in a Docker container (with Spark) in a remote VM:
```
$ az ml experiment submit -c remotevm train_mmlspark.py 0.3
```

## Create a web service using the MMLSpark model
Get the run id of the train_mmlspark.py job from run history.
```
$ az ml history list -o table
```

### Get the model file(s)
And promote the trained model using the run id.

```azurecli
$ az ml history promote -ap ./outputs/AdultCensus.mml -n AdultCensusModel -r <run id>
```

Download the model to a directory.

```azurecli
$ az ml asset download -l ./assets/AdultCensusModel.link -d mmlspark_model
```
**Note**: The download step may fail if file paths within project folder become too long. If that happens, create the project closer to file system root, for example C:/AzureML/Income.

### Create web service schema

Promote the schema file

```azurecli
$ az ml history promote -ap ./outputs/service_schema.json -n service_schema.json -r <run id>
```

Download the schema

```azurecli
$ az ml asset download -l ./assets/service_schema.json.link -d mmlspark_schema
```

### Test the scoring file's init and run functions 

Run score_mmlspark.py in remote Docker. Check the output of the job for results.
```
$ az ml experiment submit -c remotevm score_mmlspark.py
```

### Set the environment
If you have not set up a Model Management deployment environment, see the [Set up Model Managment](https://docs.microsoft.com/azure/machine-learning/preview/deployment-setup-configuration) document under Deploy Models on the documentation page.

```azurecli
az provider register -n Microsoft.MachineLearningCompute
az provider register -n Microsoft.ContainerRegistry
az provider register -n Microsoft.ContainerService
```
Monitor above with
```azurecli
az provider show -n Microsoft.MachineLearningCompute
az provider show -n Microsoft.ContainerRegistry
az provider show -n Microsoft.ContainerService
```

If you have already setup an environment, look up it's name and resource group:

```azurecli
$ az ml env list
```
# Tested to here

Set the deployment environment:

```azurecli
$ az ml env set -n <environment cluster name> -g <resource group>
```

### Deploy the web service

Deploy the web service

```azurecli
$ az ml service create realtime -f score_mmlspark.py -m mmlspark_model -s mmlspark_schema/service_schema.json -r spark-py -n mmlsparkservice -c aml_config/conda_dependencies.yml
```

Use the Sample CLI command from the output of the previous call to test the web service.

```azurecli
$ az ml service run realtime -i mmlsparkservice -d "{\"input_df\": [{\" hours-per-week\": 35.0, \" education\": \"10th\", \" marital-status\": \"Married-civ-spouse\"}]}"
```
## Part 6: Cleaning it all up

### Delete the resource group and all of the resources:

```azurecli
az group delete -n aitutorial
```