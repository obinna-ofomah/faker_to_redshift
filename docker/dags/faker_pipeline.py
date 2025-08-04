import datetime
import random

import awswrangler as wr
import boto3
import pandas as pd
from airflow.models import Variable
from airflow.providers.postgres.hooks.postgres import PostgresHook
from faker import Faker

fake = Faker()


def faker_to_s3():
    """
    A pipeline that generates fake data and write same to Amazon S3
    Args:
        n (int): The number of records/rows to generate
    """
    records = []
    for _ in range(random.randint(500_000, 1_000_000)):
        info = {"order_date": fake.date(),
                "customer_name": fake.name(),
                "address": fake.address(),
                "quantity_purchased": random.randint(10, 200),
                "price": random.randint(5000, 100_000)
                }
        records.append(info)

    df = pd.DataFrame(records)
    ingestion_date = datetime.date.today()

    session = boto3.Session(aws_access_key_id=Variable.get('access_key'),
                            aws_secret_access_key=Variable.get('secret_key'),
                            region_name=Variable.get('region')
                            )

    file_name = f"{ingestion_date}_data"
    folder_name = "faker_data"
    bucket = "obinna-data-store"
    path = f"s3://{bucket}/{folder_name}/{file_name}"

    wr.s3.to_parquet(
        df=df,
        path=path,
        dataset=True,
        mode='append',
        boto3_session=session
    )


def create_fake_table():
    hook = PostgresHook(postgres_conn_id="redshift")
    conn = hook.get_conn()
    conn.autocommit = True
    cursor = conn.cursor()
    sql = """
    CREATE TABLE IF NOT EXISTS orders (
        order_date DATE,
        customer_name VARCHAR(50),
        address VARCHAR(50),
        quantity_ordered INT,
        price INT
    );
    """
    cursor.execute(sql)
    cursor.close()
    conn.close()
