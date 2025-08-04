# Project: ETL Pipeline – Fake Order Data to S3 & Redshift

![Alt text](faker_new.png)

---

### 📋 Description

#### 1. Generates Fake Order Data  
Uses the `Faker` library to simulate customer names, addresses, dates, quantities, and prices.  
The number of records is random — anywhere between **500,000** and **1,000,000**.

#### 2. Writes to S3  
Converts the data into a `pandas` DataFrame and writes it to a specified S3 bucket in **Parquet format** using `awswrangler`.

#### 3. Creates a Redshift Table (If Missing)  
Ensures there’s a table in Redshift called `orders` with the right schema.  
*Note: this script doesn’t load any data into Redshift — it just creates the table structure.*

---

### 📦 Requirements

Make sure you have the following installed and configured:

- Python 3.x  
- [`awswrangler`](https://github.com/aws/aws-sdk-pandas)  
- `boto3`  
- `pandas`  
- `faker`  
- Apache Airflow (used for managing environment variables)

And access to:

- An **S3 bucket**  
- **AWS credentials** stored as Airflow variables:
  - `access_key`  
  - `secret_key`  
  - `region`
- A **Redshift connection** set up in Airflow:
  - `postgres_conn_id="redshift"`
