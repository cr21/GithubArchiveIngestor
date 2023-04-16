FROM public.ecr.aws/lambda/python:3.8

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

# LAMBDA_TASK_ROOT variable available from source lambda image Copy all code there
COPY app ${LAMBDA_TASK_ROOT}/app

ENV PYTOHNPATH=${LAMBDA_TASK_ROOT}/app

CMD ["app.lambda_transform"]