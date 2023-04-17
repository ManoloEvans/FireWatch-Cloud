# AWS Repository

This repository contains the AWS infrastructure and code used for the Firewatch project.

## Introduction

The Firewatch project is aimed at creating a prototype for a cluster of sensors in remote areas to detect wildfires. This repository contains the AWS infrastructure and code used to collect, store, and analyze data from the Firewatch sensors.

## Pre-requisites

The following are the pre-requisites for deploying the AWS infrastructure for this project:
- An AWS account.
- **The things network account and for it to be integrated into AWS.**
(For more details regarding setup with the things network, please refer to the [firewatch-ttn repository])

## Components

The AWS infrastructure for this project includes the following components:

- Amazon S3 bucket: used to store Athena queries.
- AWS Lambda functions: used to process and transform sensor data.
- Amazon Athena: used to query the sensor data stored in the S3 bucket.
- Amazon QuickSight: used to visualize and analyze the sensor data.
- Amazon CloudWatch: used to monitor the health and performance of the AWS infrastructure.
- Amazon CloudFormation: used to deploy the AWS infrastructure.
- Amazon IoT Core: used to manage the Firewatch sensors and create rules.
- Amazon DynamoDB: used to store the Firewatch sensor payload.
- Amazon IAM: used to manage the permissions for the AWS infrastructure.

## Overview

In deploying the AWS infrastructure for this project, the following is a high level overview of the steps needed to be taken:

- Create an IAM User.
- Create a cloudformation stack.
- Set up an AWS IoT Core rule to route the data from the sensors to the DynamoDB table.
- Create a dynamoDBV2 Table. This version of DynamoDB will automatically create fields for the data that is being stored.
- Create an AWS Athena workspace to create a query.
- Set up Amazon Athena to query the data in the S3 bucket and generate reports based on the data.
- Configured Grafana to connect to Amazon Athena and visualize the data in a dashboard.


## AWS IAM Part 1

The first thing you're going to need to do is create an administrator level IAM user. It is generally not recommended to use the root level account for everyday tasks or regular usage because of security concerns. The root account has unrestricted access to all resources and permissions within an AWS account. Using the root account for routine tasks could increase the risk of unauthorized access, accidental or intentional modification or deletion of important resources, or other security issues.

Later on there in the readme there wil be an AWS IAM part 2 going over roles, policies, and permissions that you will need in order for everything to work.

## AWS IoT Core and DynamoDB

The AWS IoT Core is used to manage the Firewatch sensors and create rules. A Thing should be automatically generated when a sensor is registered on the things network. The Thing should be named after the sensor's EUI. In the aws-iotcore folder, there is a file called "firewatch-aws-iot-core-rule.sql". This file contains the SQL statement that will query the topic of the sensor(in this case lorawan/#).

- Go to the MQTT Test tab in the AWS IoT Core console and subscribe to 'lorawan/#'. Take note of the names of the fields in the table that you want to store in the DynamoDB table.
- Go to Rules in IoT Core and create a rule. Give it a name and then fill out the SQL statement with the fields that you want to store in the DynamoDB table. The SQL statement should look something like like the one in the aws-iotcore folder. 
- On the next page go to actions and select DynamoDBv2. Create a table and fill out the partition keys and sort keys with the actual names of the fields in the payload, the purpose of this is that DynamoDBv2 actually creates fields for the data that is being stored. The table name should be the same as the one that you created in DynamoDB. The rule should now be created and you should be able to see the data in the DynamoDB table. You can just leave the default settings for the rest of the page.

## AWS S3 Buckets

- Go to the S3 console and create a new bucket. The name of the bucket should specify that it is a spill bucket and then "-athena". In my case I did "firewatchspill-athena". 
- Now create another bucket. This bucket will be used to store the data that is being queried. The name of the bucket needs to be <code>grafana-athena-query-results-(yourbucketnamehere)</code>

## AWS Athena

- Go to the Athena console and create a new workgroup.
- Under Query results location, select the S3 bucket that you created
- **Super important** that you add this tag: <code>GrafanaDataSource : true</code>
- Now go to the Athena console and create a new query. The query should look something like this: <code>SELECT * FROM firewatchsensordata_v3</code>

## AWS Quicksight

Quicksight is basically Amazon's version of a dashboard that helps with visualizing data. I experimented a bit with it but found that it is quite limited in its functionality. In the end I realized if I wanted to get more out of my data I would have to use a grafana dashboard.

## AWS Managed Grafana

AWS Managed Grafana links AWS services to grafana. There is no direct support for a DynamoDB table but thats why in this project I created an Athena workgroup to query the DynamoDB table, a neat and easy workaround. To set up a AWS Managed Grafana page and have it linked and querying from Athena follow these steps:

- Go to the AWS Managed Grafana console and create a new workspace.
- Under Authentication Access select the AWS IAM Identity Center option.
- Personally I set the grafana alerting option on but this is optional.
- I set the Network access to be public but this is also optional.
- Under Data sources, select Amazon Athena.

Now the Grafana dashboard should be created. But there are a few more steps before you can start creating panels and visualizing your data.

## AWS IAM Part 2

So now we're going to discuss the roles and policies that I personally have configured. Now this being my first experience with using AWS I'm sure there are better ways to do this but this is what I did and it worked for me.

### Grafana IAM Roles and Policies

First things you will need to create an IAM Identity User.

- Go to the IAM Identity Center, not to be confused with the regular IAM console.
- Create a new user filling out the name and email.
- They will email you regarding completing the setup. Once you follow the setup rules you're IAM user will be created.

In my IAM Console I have a role called "AmazonGrafanaServiceRole-" followed by some random characters. Inside the aws-iam folder there is a folder called "AmazonGrafanaServiceRole". This is contains the policies that I have attached to the role. These policies allow the Grafana workspace to query the Athena workgroup and read from the S3 Bucket. The policies I have inside the AmazonGrafanaServiceRole are super vital. I was getting an Amazon reads S3 error and it was because I didn't have the correct policies attached to the role.

### IoT Core IAM Roles and Policies

In the aws-iam/firewatchrole folder, there is a file called awsiotaction1role. This allows my firewatch role to put items into dynamodb tables. This is all I needed to give the IoT role the policies it needed for the scope of this project.

There are other roles that were generated when you go through the cloudformation and a Thing is created in IoT Core. I won't go over these since it is a bit redundant, but I will put them into the aws-iam folder for reference.

## IAM Roles and User Attached Policies

Once again reminding you the reader here, that I am learning how to use AWS as we go along, so I would like to preface here that I know I am probably going overkill on the policies and roles. 

Inside the aws-iam/UserPolicies folder I put all of the Policies that I have attached to my IAM user. Keep in mind that you may only have up to 10 policies attached directly to your user. If you need more than 10 policies attached to your user, you can create a group and attach the policies to the group. Then you can attach the group to your user.

Inside the aws-iam folder I have also put all of the roles that I have created. Most of them were created when you create something using AWS so I have just put them there for reference.

## Contributing

If you would like to contribute to this project, please follow the standard Git workflow:

## Fork the repository.

Create a new branch for your changes.
Make your changes and commit them to your branch.
Push your changes to your forked repository.
Create a pull request to merge your changes into the main repository.
License
This project is licensed under the MIT License. See the LICENSE file for details.