docker rmi 008483831724.dkr.ecr.us-east-1.amazonaws.com/ghactivity_ingest_aws:latest

docker rmi ghactivity_ingest_aws

docker build -t ghactivity_ingest_aws .

export AWS_PROFILE=ghactivity

aws ecr get-login-password \
  --region us-east-1 | \
  docker login \
    --username AWS \
    --password-stdin 008483831724.dkr.ecr.us-east-1.amazonaws.com


docker tag ghactivity_ingest_aws:latest \
  008483831724.dkr.ecr.us-east-1.amazonaws.com/ghactivity_ingest_aws:latest

docker push 008483831724.dkr.ecr.us-east-1.amazonaws.com/ghactivity_ingest_aws:latest


aws lambda update-function-code \
  --function-name gharchive_ingestor \
  --image-uri 008483831724.dkr.ecr.us-east-1.amazonaws.com/ghactivity_ingest_aws:latest
# run with  " sh -x docker_build.sh "