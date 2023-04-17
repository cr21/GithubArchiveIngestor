from util.bookmark import get_job_Details, get_next_file, save_job_run_details, get_job_Start_time
from ghactivity_ingest import upload_file_to_s3
from ghactivity_transform import transform_to_parquet

import os

bucket_name = os.environ.get("BUCKET_NAME")
folder = os.environ.get('FOLDER')
job_id = os.environ.get("JOB_ID")

print("+" * 100)


def ghactivity_ingest_to_s3():
    job_details = get_job_Details(job_id)
    job_start_time, next_file = get_next_file(job_details)
    job_run_details = upload_file_to_s3(next_file, bucket_name, folder)
    save_job_run_details(job_details, job_run_details, job_start_time)
    return job_run_details


def ghactivity_transform_to_parquet(file_name):
    print(":" * 100)
    source_folder = os.environ.get("SOURCE_FOLDER")
    bucket_name = os.environ.get("BUCKET_NAME")
    target_folder = os.environ.get('TGT_FOLDER')
    job_id = os.environ.get("JOB_ID_1")
    print("bucket_name ", bucket_name)
    print("source_folder ", source_folder)
    print("target_folder ", target_folder)
    print("job_id ", job_id)
    job_details = get_job_Details(job_id)
    print("job_details", job_details)
    job_run_details = transform_to_parquet(file_name, source_folder, bucket_name, target_folder)
    print("job_run_details", job_run_details)
    job_start_time = get_job_Start_time()
    save_job_run_details(job_details, job_run_details, job_start_time)
    print(":" * 100)
    return job_run_details


def ingest(event, context):
    """

    Lambda handler to ingest data from githubarchive website
    """
    job_run_details = ghactivity_ingest_to_s3()
    return {
        "status": 200,
        "Body": job_run_details
    }


def lambda_transform(event, context):
    """
    Lambda handler to transform data from json to parquet reading from s3 and storing output file to s3

    """
    file_name = event['jobRunDetails']['last_run_file_name']
    print("+" * 100)
    print(file_name)
    job_run_details = ghactivity_transform_to_parquet(file_name)

    return {
        "status": 200,
        "jobRunDetails": job_run_details
    }


def lambda_transform_trigger(event, context):
    """
    This function will be invoked based on s3 put event

    """

    file_name = event['Records'][0]['s3']['object']['key'].split("/")[-1]
    print("+" * 100)
    print(file_name)
    job_run_details = ghactivity_transform_to_parquet(file_name)

    return {
        "status": 200,
        "jobRunDetails": job_run_details
    }
