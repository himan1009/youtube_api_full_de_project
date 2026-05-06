from airflow import DAG
from datawarehouse.dwh import core_table, staging_table
import pendulum
from datetime import timedelta, datetime
from api.video_stats import get_playlist_id, get_video_ids, extract_video_data, save_to_json

local_tz=pendulum.timezone("Asia/Kolkata")

default_args={
    'owner': 'himanshu-kumar',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'email':'shishusha922@gmail.com',
    # 'retries':1,
    # 'retry_delay':timedelta(minutes=5),
    'max_active_runs':1,
    'dagrun_timeout':timedelta(minutes=60),
    'start_date':datetime(2026, 1, 1, tzinfo=local_tz),
    # 'end_date':datetime(2030, 1, 1, tzinfo=local_tz)
}

with DAG(
    dag_id='produce_json',
    default_args=default_args,
    description='DAG to produce JSON file witn row data',
    schedule='0 14 * * *',
    catchup=False
) as dag:
    
    #define tasks
    playlist_id = get_playlist_id()
    video_ids=get_video_ids(playlist_id)
    extract_data= extract_video_data(video_ids)
    save_to_json=save_to_json(extract_data)


    # define dependencies
    playlist_id >> video_ids >> extract_data >> save_to_json




with DAG(
    dag_id='update_db',
    default_args=default_args,
    description='DAG to process JSON file and insert data into both staging table',
    schedule='0 15 * * *',
    catchup=False
) as dag:
    
    #define tasks
    update_staging = staging_table()
    update_core = core_table()
    

    update_staging >> update_core
    
