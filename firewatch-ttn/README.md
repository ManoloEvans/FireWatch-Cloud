# The Things Network Repository

This part of the repository contains all things pertaining to The Things Network (TTN) and the FireWatch project.

## Table of Contents

- [Introduction](#introduction)
- [Pre-requisites](#pre-requisites)
- [Overview](#overview)
- [Create a TTN account](#create-a-ttn-account)
- [Claiming a Gateway](#claiming-a-gateway)
- [Register a Gateway](#register-a-gateway)
- [Create a TTN application](#create-a-ttn-application)
- [Integration into AWS](#integration-into-aws)
- [Register a TTN End Device](#register-a-ttn-end-device)


## Introduction

The Firewatch project is aimed at creating a prototype for a cluster of sensors in remote areas to detect wildfires. This repository contains the details pertaining to the TTN setup and the code used to send data to TTN.

## Pre-requisites

For this part of the project, you will need:

- A TTN Gateway
- A LoraWAN Sensor flashed with working code, found in my repository [firewatch-sensor](https://github.com/ManoloEvans/firewatch-sensor) or a simulated sensor.
- An AWS account.

## Overview

This readme covers the steps I took to create and set up the The Things Network. A high level overview of the steps needed to be taken:

- Create a TTN account
- Claiming a TTN Gateway
- Register a TTN Gateway
- Create a TTN application
- Integration into AWS
- Register a TTN End Device

## Create a TTN account

This step is straightforward, just go ahead and sign up for an account at TTN and youre good to go.

## Claiming a Gateway

I would recommend following the [docs](https://www.thethingsindustries.com/docs/gateways/models/thethingsindoorgateway/) on the TTN website. It is a very straightforward process and they will provide much more detail, but I'll quickly cover it here.

I used TTN Indoor Gateway for this project, so the steps may differ depending on which gateway you're using.

- Keep a note of the gateway's EUI somewhere on the gateway itself, and then add "FFFE" after the first 6 characters to make it 16 characters long.
- Plug in the gateway and wait for it to boot up.
- Press the reset button for 5 secs until LED blinks green and red.
- Hold SETUP button for 10 seconds until it blinks red.
- Gateway will display a wifi network you can connect to with the name <code>MINIHUB-XXXXXXX</code> where the X's are the last 6 digits of the gateway's EUI.
- The password will be the EUI with the "FFFE" added.
- In your browser go to <code>192.168.4.1</code> 
- Press the "+" and Select the wifi network you want to connect to, and then after you're connected click save and reboot. 

This will connect the gateway online.

## Register a Gateway

Once again I will reference you to check out The Things Network [docs](https://www.thethingsindustries.com/docs/gateways/concepts/adding-gateways/) to get a more detailed explanation of this step. But I will quickly cover it here.

- Go to the TTN console and log in.
- Click on gateways at the top.
- Fill in the Gateway EUI.
- On the next page just fill out your respective settings like what frequency plan you're using, etc.

## Create a TTN application

Just go to the top on TTN console and click on applications. Then click on add application. Fill in the details and you're good to go.

## Integration into AWS

Go to the TTN deployment guide [here](https://www.thethingsindustries.com/docs/integrations/cloud-integrations/aws-iot/deployment-guide/) and follow the steps to integrate TTN with AWS, they provide you with a CloudFormation template that you can use to set up the AWS infrastructure after you've selected the appropriate region. I will cover the steps here as well.

- Go to your application on TTN console and select API keys, and click <code>+ Add API Key</code>. Give it a name and select the rights you want to give it. I gave it the recommended rights in the docs:
  - View devices in application
  - View device keys in application
  - Create devices in application
  - Edit device keys in application
  - Edit basic application settings
  - View and edit application packages and associations
  - Write downlink application traffic
  - Read application traffic (uplink and downlink)

- The following settings are copied from the docs mentioned earlier:
  - Principal Account ID  : AWS Account ID that The Things Stack authenticates with.
  - Thing Type Name: The unique AWS IoT Core thing type name for this integration.
  - Thing Name Scheme: The name that is given to AWS IoT things when they are created by the integration.
    - When using DevEUI, the name will appear as the numeric DevEUI, i.e 1122334455667788.
    - When using DeviceID, the thing name will be a combination of the CloudFormation stack name and the device ID as registered in The Things Stack, i.e. <stackName>_<DeviceID>.
  - Thing Shadow Metrics: Enable or disable updating the thing shadow with metrics.
  - Cluster Address: The cluster address of your The Things Stack deployment.
    - When using The Things Stack Cloud, go to [The Things Stack Cloud Addresses](https://www.thethingsindustries.com/docs/getting-started/cloud-hosted/addresses/) to find your cluster address
    - When using The Things Stack Enterprise, enter your cluster address
    - When using The Things Network, select the community cluster from the dropdown
  - Application ID: The application ID for which you configure the integration.
  - Application API Key: The application API key that you generated before.

- Check I acknowledge that AWS CloudFormation might create IAM resources. 
- Click <code>Create Stack</code>.

When the deployment is done it will say <code>Create_Complete</code>.

## Register a TTN End Device

Now that the AWS integration is complete, when you register an end device in your TTN application, it will automatically be registered in AWS IoT Core. I personally used the OTAA.

- Go to your TTN application and click on <code>+ Register end device</code> to add a device.
- I had to select the **Enter end device specifics manually** option.
- Fill out the frequency plan, LoRaWAN version, Regional Parameters Version and the JOIN EUI. In my case I had the JOIN EUI set to all 0's.
- Generate the DevEUI and AppKey then give your device a name or leave it blank, it will generated if not filled.
- Click <code>Register end device</code>.

Now you can go add your keys to your code for the device and it will connect. And once it's registered you can see it on the AWS IoT Core console.

## Conclusion

That's about it for the TTN setup. I hope this helps you get started with TTN and AWS IoT Core. If you have any questions or suggestions, feel free to reach out to me.