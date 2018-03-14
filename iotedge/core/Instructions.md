## Instructions

### 1) Accessing your Device/Linux DSVM

Use the following credentials to log in to the Device/Linux DSVM:

* *VM Name*: {Outputs.dvmName}
* *Admin Username*: {Outputs.dadminUsername}
* *SSH Command*: {Outputs.dsshConnection}

![See edgeAgent in Docker](https://raw.githubusercontent.com/MicrosoftDocs/azure-docs/master/articles/iot-edge/media/tutorial-simulate-device-linux/docker-ps.png)

### 2) View generated data

We created a new IoT Edge device and installed the IoT Edge runtime on it. Then, we pushed an IoT Edge module to run on the device without having to make changes to the device itself. In this case, the module that you pushed creates environmental data that you can use for the tutorials. 

Open the command prompt on the computer running your simulated device. Confirm that the module deployed from the cloud is running on your IoT Edge device:

```cmd
sudo docker ps
```

![View three modules on your device](https://raw.githubusercontent.com/MicrosoftDocs/azure-docs/master/articles/iot-edge/media/tutorial-simulate-device-linux/docker-ps2.png)

View the messages being sent from the tempSensor module to the cloud:

```cmd
sudo docker logs -f tempSensor
```

![View the data from your module](https://raw.githubusercontent.com/MicrosoftDocs/azure-docs/master/articles/iot-edge/media/tutorial-simulate-device-linux/docker-logs.png)

### 3) Visualize the device telemetry in Time Series Insights

[Add your user in the Time Series Insights Data Access Pane]({Outputs.dataAccessPaneUrl}).

 * Click on **+Add** > **Select user** > **Enter your account** > click **Select**
 * Click on **Select role** > choose **Contributor** > click **Ok** > click **Ok**
 * Click on **Overview**
 * Click on **Go to Environment** or the **Time Series Insights URL**
 
 [Open Time Series Insights](https://insights.timeseries.azure.com/).

You can also view the telemetry the device is sending by using the [Time Series Insights](https://insights.timeseries.azure.com/). 

 ### 4) Install Azure Machine Learning Workbench

 1. [Install Azure Machine Learning](https://docs.microsoft.com/en-us/azure/machine-learning/preview/quickstart-installation)
 1. If you would like to use the Data Science VM for installation instead of your PC or Mac then click [here](https://quickstart.azure.ai/Deployments/new/datasciencevm?source=CiqsGallery) to deploy the Windows Data Science VM

 **Note: you will want to deploy the Windows Data Science VM into the same location as the IoT Edge quickstart** 

### 5) Set up Model Management for Azure ML
If you are already an Azure ML user then skip to the next section.

Otherwise, follow these steps (more details in the [Model Management documentation](https://docs.microsoft.com/en-us/azure/machine-learning/preview/deployment-setup-configuration)):

1. Connect and log into the DSVM you created in the previous section
2. Open a command prompt (type `az ml -h` to see options)
3. Run the script below to configure Docker correctly (Docker is pre-installed on the DSVM). **Remember to log out and log back in after running the script.**
```
sudo /opt/microsoft/azureml/initial_setup.sh
```
4. Set up the environment (only needs to be done one time).  Note when completing the environment setup:
  * You are prompted to sign in to Azure. To sign in, use a web browser to open the page https://aka.ms/devicelogin and enter the provided code to authenticate.
  * During the authentication process, you are prompted for an account to authenticate with. Important: Select an account that has a valid Azure subscription and sufficient permissions to create resources in the account.
  * When the log-in is complete, your subscription information is presented and you are prompted whether you wish to continue with the selected account.

5. Register the environment provider by entering the following command:

```azurecli
az provider register -n Microsoft.MachineLearningCompute
```
6. Set up a local environment using the following command. The resource group name is optional.

```azurecli
az ml env setup -l [Azure Region, e.g. eastus2] -n [your environment name] [-g [existing resource group]]
```

7. The local environment setup command creates the following resources in your subscription:
* A resource group (if not provided, or if the name provided does not exist)
* A storage account
* An Azure Container Registry (ACR)
* An Application insights account

After setup completes successfully, set the environment to be used using the following command:

```azurecli
az ml env set -n [environment name] -g [resource group]
```
*Note:* For subsequent deployments, you only need to use the set command above to reuse it.

You are now ready to deploy your saved model as a web service.

## Create container for Azure IoT Edge
[Follow these steps](https://github.com/Azure/ai-toolkit-iot-edge/tree/master/MNIST%20classification%20with%20TensorFlow) to create the container for deployment to Azure IoT Edge running on your DSVM.

### Ways to connect to the Device/Linux DSVM

You can access your newly created Device/Linux DSVM in several ways.

#### Terminal

Use the following credentials to log in:

* *VM Name*: {Outputs.dvmName}
* *Admin Username*: {Outputs.dadminUsername}
* *SSH Command*: {Outputs.dsshConnection}

#### X2Go Client

You can download The X2Go client from the [X2Go site](http://wiki.x2go.org/doku.php/start).

* *Host*: {Outputs.ddnsName}
* *Login*: {Outputs.dadminUsername}
* *SSH port*: 22
* *Session Type*: Change the value to _XFCE_

#### PuTTY

You can download PuTTY from the [PuTTY site](http://www.putty.org/).

* *Host Name*: {Outputs.ddnsName}
* *Port*: 22
* *Connection Type*: SSH
* *login as*: {Outputs.dadminUsername}

#### Azure Portal

* Click [here]({Outputs.dfirstDeviceVmUrl}) to view the Device/Linux DSVM on the Azure portal.