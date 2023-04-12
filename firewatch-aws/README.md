# AWS Repository

This repository contains the AWS infrastructure and code used for the Firewatch project.

## Introduction

The Firewatch project is aimed at creating a prototype for a cluster of sensors in remote areas to detect wildfires. This repository contains the AWS infrastructure and code used to collect, store, and analyze data from the Firewatch sensors.

## Pre-requisites

The following are the pre-requisites for deploying the AWS infrastructure for this project:
- An AWS account.
- The things network account and for it to be integrated into AWS.
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

## Getting Started

In deploying the AWS infrastructure for this project, the following is a high level overview of the steps needed to be taken:

1. Create a thing in AWS IoT core for each Firewatch sensor.
2. Set up an AWS IoT Core rule to route the data from the sensors to the S3 bucket.
3. Configured AWS Glue to crawl the data in the S3 bucket and generate a table schema for the data.
4. Used AWS Glue to create an ETL job to transform the data into a format that can be used by Amazon Athena.
5. Set up Amazon Athena to query the data in the S3 bucket and generate reports based on the data.
6. Configured Grafana to connect to Amazon Athena and visualize the data in a dashboard.


Contributing
If you would like to contribute to this project, please follow the standard Git workflow:

Fork the repository.
Create a new branch for your changes.
Make your changes and commit them to your branch.
Push your changes to your forked repository.
Create a pull request to merge your changes into the main repository.
License
This project is licensed under the MIT License. See the LICENSE file for details.