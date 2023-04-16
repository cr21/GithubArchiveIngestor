import uuid
import boto3
import  pandas as pd


def transform_to_parquet(file_name,source_folder, bucket_name, target_folder):
    print(f"Creating json reader for {file_name}")
    json_reader = pd.read_json(
        f's3://{bucket_name}/{source_folder}/{file_name}',
        lines=True,
        orient='records',
        chunksize=10000
    )
    year = file_name.split("-")[0]
    month = file_name.split("-")[1]
    dayofmonth = file_name.split("-")[2]
    hour = file_name.split("-")[3].split(".")[0]
    print("Read each chunks of maximum 10000 records")
    for idx, df in enumerate(json_reader):
        print(f"processing chunk # {idx} which has # {df.shape[0]} records")
        target_file_name = f'part-{year}-{month}-{dayofmonth}-{hour}-{uuid.uuid1()}.snappy.parquet'
        df.drop(columns=['payload']). \
            to_parquet(
            f's3://{bucket_name}/{target_folder}/year={year}/month={month}/dayofmonth={dayofmonth}/{target_file_name}',
            index=False
        )

    return  {
        "last_run_src_file_name":file_name,
        "last_run_tgt_file_pattern":f's3://{bucket_name}/{target_folder}/year={year}/month={month}/dayofmonth={dayofmonth}/{hour}'
    }