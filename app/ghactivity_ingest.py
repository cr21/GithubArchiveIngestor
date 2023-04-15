import  requests
import  boto3


def upload_file_to_s3(filename, bucket_name, folder):
    print(f"Getting {filename} from ghacrhive data")
    res = requests.get(f'https://data.gharchive.org/{filename}')
    print(f"uploading {filename} to s3 under path : s3://{bucket_name}/{folder}/")
    s3_client = boto3.client('s3')
    upload_res = s3_client.put_object(Bucket=bucket_name,
                                      Key=f'{folder}/{filename}',
                                      Body=res.content
                                      )

    return {
        "last_run_file_name": f's3://{bucket_name}/{folder}/{filename}',
        "status_code": upload_res['ResponseMetadata']['HTTPStatusCode']
    }
