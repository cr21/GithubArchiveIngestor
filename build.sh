rm -f ghacitivity_ingest_aws_lambda.zip
mkdir -p depedencies
pip install -r requirements.txt  -t depedencies
cd depedencies; zip -r ghacitivity_ingest_aws_lambda.zip .  # rm -rf botocore*;
mv -f ghacitivity_ingest_aws_lambda.zip ..
cd ..
rm -rf depedencies
zip -r ghacitivity_ingest_aws_lambda.zip app
#aws s3  cp ghacitivity_ingest_aws_lambda.zip s3://crtaigithub/landing/code/ghactivity_ingestor.zip