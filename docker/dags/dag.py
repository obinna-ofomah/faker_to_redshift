from faker_pipeline import *
from airflow import DAG
import datetime 
from airflow.operators.python import PythonOperator
from airflow.providers.amazon.aws.transfers.s3_to_redshift import (S3ToRedshiftOperator)
ingestion_date = datetime.date.today()

default_args = {
    'owner': 'Obinna Ofomah',
    'start_date': datetime.datetime(2025, 8, 1, 0),
    'schedule_interval': '@daily',
    'retries': 3
}

dag = DAG(
    dag_id='faker_etl_pipeline',
    default_args=default_args
)

faker_pipeline = PythonOperator(
    task_id='fake_data_pipeline',
    python_callable=faker_to_s3,
    dag=dag
)

create_table = PythonOperator(
    dag=dag,
    python_callable=create_fake_table,
    task_id='create_table'
)

load_to_redshift = S3ToRedshiftOperator(
    redshift_conn_id='redshift',
    aws_conn_id='obinna-aws',
    task_id = 'load_to_redshift',
    schema='public',
    table='orders',
    s3_bucket='obinna-data-store',
    s3_key=f'faker_data/*',
    copy_options=['FORMAT AS PARQUET'],
    method='APPEND',
    dag=dag
)


faker_pipeline >> create_table >> load_to_redshift