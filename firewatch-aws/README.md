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

1. Create an IAM User.
2. Create a cloudformation stack.
3. Set up an AWS IoT Core rule to route the data from the sensors to the DynamoDB table.
4. Create a dynamoDBV2 Table. This version of DynamoDB will automatically create fields for the data that is being stored.
5. Create an AWS Athena workspace to create a query.
6. Set up Amazon Athena to query the data in the S3 bucket and generate reports based on the data.
7. Configured Grafana to connect to Amazon Athena and visualize the data in a dashboard.


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
- Under Query results location, select the S3 bucket that you create
- **Super important** that you add this tag: <code>GrafanaDataSource : true</code>
- Now go to the Athena console and create a new query. The query should look something like this:

```SELECT * FROM firewatchsensordata_v3

## Contributing

If you would like to contribute to this project, please follow the standard Git workflow:

## Fork the repository.

Create a new branch for your changes.
Make your changes and commit them to your branch.
Push your changes to your forked repository.
Create a pull request to merge your changes into the main repository.
License
This project is licensed under the MIT License. See the LICENSE file for details.