import boto3
import csv
import io
import os

ENDPOINT = "http://localstack:4566"

dynamodb = boto3.resource("dynamodb", endpoint_url=ENDPOINT)
s3 = boto3.client("s3", endpoint_url=ENDPOINT)


def lambda_handler(event, context):
    print("EVENT:", event)

    bucket = event["bucket"]
    key = event["key"]
    table_name = event["table"]

    obj = s3.get_object(Bucket=bucket, Key=key)
    content = obj["Body"].read().decode("utf-8")

    rows = list(csv.DictReader(io.StringIO(content)))

    table = dynamodb.Table(table_name)

    with table.batch_writer(overwrite_by_pkeys=["registry", "name"]) as batch:
        for row in rows:
            print("PUT:", row)
            batch.put_item(Item=row)

    return {"status": "ok", "written": len(rows)}
