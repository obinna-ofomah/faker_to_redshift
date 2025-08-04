### Project: ETL Pipeline – Fake Order Data to S3 & Redshift

![Alt text](faker_new.png)

---

## Description:


This project implements an **ETL (Extract, Transform, Load)** pipeline using Apache Airflow. The pipeline generates fakes data from the Faker Library, transforms the relevant fields, and loads the data into an S3 bucket in Parquet format, and finally moved same to Redshift


### 📋 Project Stages
- Generate Fake Dataset using Faker  
- Transform and write to S3 Bucket
- Connect to S3 Bucket and Amazon Redshift
- Load from S3 Bucket to Redshift
