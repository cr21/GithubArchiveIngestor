export AWS_PROFILE=ghactivity
aws ecr get-login-password \
  --region us-east-1 | \
  docker login \
    --username AWS \
    --password-stdin 008483831724.dkr.ecr.us-east-1.amazonaws.com

aws ecr get-login-password \
  --region us-east-1 | \
  docker login \
    --username AWS \
    --password-stdin 008483831724.dkr.ecr.us-east-1.amazonaws.com

docker build -t ghactivity_aws .
docker build -t ghactivity_aws .



docker run \
  --name ghactivity_ingest \
  -d \
  ghactivity_aws





docker tag ghactivity_aws:latest 008483831724.dkr.ecr.us-east-1.amazonaws.com/ghactivity_aws:latest
docker push 008483831724.dkr.ecr.us-east-1.amazonaws.com/ghactivity_aws:latest


docker run \
  --name ghactivity_aws \
  -p 9191:8080 \
  -v /Users/chiragtagadiya/.aws:/root/.aws \
  -e AWS_PROFILE=ghactivity \
  -e AWS_DEFAULT_REGION=us-east-1 \
  -e BUCKET_NAME=crtaigithub \
  -e FOLDER=landing/ghactivity \
  -e JOB_ID=ghactivity_ingest \
  -e PYTHONPATH=/var/task/app \
  -d \
  ghactivity_aws

curl -XPOST "http://localhost:9191/2015-03-31/functions/function/invocations" -d '{}'



docker exec -it ghactivity_ingest bash

docker cp ~/.aws ghactivity_ingest:/root
docker logs -f ghactivity_ingest



aws ecr list-images \
  --repository-name ghactivity_aws


aws lambda get-function \
  --function-name gharchive_ingestor

aws lambda get-function-configuration \
  --function-name gharchive_ingestor


docker run \
  --name ghactivity_aws \
  -p 9191:8080 \
  -v /Users/chiragtagadiya/.aws:/root/.aws \
  -e AWS_PROFILE=ghactivity \
  -e AWS_DEFAULT_REGION=us-east-1 \
  -e BUCKET_NAME=crtaigithub \
  -e FOLDER=landing/ghactivity \
  -e SOURCE_FOLDER=landing/ghactivity \
  -e TGT_FOLDER=raw/ghactivity \
  -e JOB_ID_1=ghactivity_transform \
  -e JOB_ID=ghactivity_ingest \
  -e PYTHONPATH=/var/task/app \
  -d \
  ghactivity_aws


curl -XPOST "http://localhost:9191/2015-03-31/functions/function/invocations" \
  -d '{"jobRunDetails": {"last_run_file_name" : "2023-04-13-3.json.gz"}}'

