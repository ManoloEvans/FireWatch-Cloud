# Grafana Repository

This repository contains the details pertaining to the Grafana dashboard used in the FireWatch project.

## Introduction

The Firewatch project is aimed at creating a prototype for a cluster of sensors in remote areas to detect wildfires. This repository contains the SQL queries, and settings used to set up the panels in Grafana.

## Pre-requisites

This folder in the repository is the last step in the Project.

- Integration between TTN and AWS
- Sensor built collecting and sending data or a simulated a Sensor to send data to AWS DynamoDB.
- S3 Bucket and Athena Query created and functioning.
- IAM Identity to access the Grafana Dashboard.

## Overview

This readme covers the steps I took to create and set up the grafana dashboard. A high level overview of the steps needed to be taken:

- Configure the IAM User to be an Administrator for the dash.
- Configure Grafana to select Athena as a data source.
- Create a dashboard and panels.
- Create an SQL statement to query the data.
- Override any details in the panel settings.
- Style the panels.

## Configure IAM Identity as Administrator

- First things, go to the Grafana Console on AWS and select the Workspace and click configure users and groups under "AWS IAM Identity Center (successor to AWS SSO)".
- Select the checkbox next to the user and then on the top right click action > make admin.

All done!

## Configure Grafana to select Athena as a data source

Now that we have the IAM Identity configured, we can configure the Grafana dashboard to use Athena as a data source.

- Go to the actual Grafana dash and select the AWS Icon on the left.
- Select Region and then select the region you are using.
- Once its been selected, go to the settings and make sure the region is correct.
- Under Athena details, click Data Source and select the data source you want to use. Same for the database, and workgroup.
- Make sure the output location is to the correct bucket. I have mine set to <code>grafana-athena-query-results-firewatch</code>
- Click save and test. If it works, you should see a green checkmark.
- Now go to permissions, find the user you want to work as/with, and on the right make sure it is selected as either Admin or editor. I have mine set to Admin.

Hopefully it should be set up correctly. 

## Create a dashboard and panels

In my case, all of the numerical values, or what at least should have been numerical values, were stored as strings. So I had to go ahead and convert them to floats. I did this by using the transform tab in all of the panels. The transforming of the data type was the same for each panel so I will only show the steps for one panel.

- When you create a new panel, go ahead and select the tab "Transform".
- Select the "Convert field type" option.
- my date and time field was called <code>received_at</code>, so I selected that field and changed it to "Time". It gives you the format template to fill out but I left it blank and it worked fine.
- Click the <code>+ Convert Field Type</code> button and select the field you want to convert to numerical. Do this for each field you want to convert in each panel you make.

### Create a Heatmap

First thing I did was make the Heatmap.

Add a new panel and go ahead and write a test query to make sure that you're able to query the data correctly. Something like: <code>SELECT * FROM TABLE LIMIT 100</code>

Hopefully it should work. I personally ran into an issue where it was giving me an Amazon S3 Access denied error. I fixed this by going to the IAM console and adding to the role: amazongrafanaservicerole- the policy found in the aws-iam/amazongrafanaservicerole called: <code>grafanareadss3bucket.json</code> This fixed all my issues.

You can now go ahead and create the heatmap. I used the query found in the GrafanaSqlQueries folder called <code>heatmapquery.sql</code>
This query selects the only the most recent records for each unique device ID. You can read more about that query within the Grafana SQL Queries folder.

- go ahead and select Geomap in the visualizations, and give it a title and description. 
- Under Data layer, make sure that heatmap is one of the layers along with markers.
- Adjust the Threshold values to you liking. 

Boom! You have a heatmap.

### Gauges

Go ahead and create a new panel and select the gauge visualization. Check the Sql folder you hopefully checked earlier to see what I queried. With an explanation. I wanted to have a gauge for the latest reading of co2, humidity, and temperature. So after creating the query for the gauge, I had to fiddle with the styling settings like text and gauge size to make it look nice.

Now for some overrides. I wanted to have the gauge show each value and what the unit was. I selected the Co2 field and added the following overrides:

- Standatd Options > Unit > Parts-per-million (ppm)
- Changed the Display Name to CO2 as it was analog_in_3 before.
- Standard Options > Max > 5
- Standard Options > Min > 0

I did the same for the other two fields. For Humidity I changed the unit to Humidity %H, temperature to Degrees(There was no specific option for temperature). I adjusted all the maximums and minimums accordingly. That is it for the gauges.

### Time Series

I added a time series panel with the query found in the sql folder called <code>timeseriesquery.sql</code>. This query selects the the CO2 and the date by ascending date and time, very simple. On the top right I selected the time range for the last 6 hours. That was it for the Time Series.
