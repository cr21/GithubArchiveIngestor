# START RUN THIS TO UPDATE CURRENT DOCKER IMAGE TO ECR
export AWS_PROFILE=ghactivity


docker build -t ghactivity_aws .

aws ecr get-login-password \
  --region us-east-1 | \
  docker login \
    --username AWS \
    --password-stdin 008483831724.dkr.ecr.us-east-1.amazonaws.com





docker tag ghactivity_aws:latest 008483831724.dkr.ecr.us-east-1.amazonaws.com/ghactivity_aws:latest
docker push 008483831724.dkr.ecr.us-east-1.amazonaws.com/ghactivity_aws:latest

# END RUN THIS TO UPDATE CURRENT DOCKER IMAGE TO ECR


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



