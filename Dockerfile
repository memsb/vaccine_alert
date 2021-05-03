FROM python:3-alpine
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt
COPY . /app
ENTRYPOINT ["python", "/app/vaccine_scan.py"]