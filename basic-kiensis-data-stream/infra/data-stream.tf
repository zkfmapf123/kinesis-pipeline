## S3
################################################################################
### S3 Bucket
################################################################################
resource "aws_s3_bucket" "data-log-bucket" {
  bucket = "dk-log-bucket"

  tags = {
    Name = "dk-log-bucket"
  }
}

################################################################################
### S3 Bucket Policy
################################################################################
resource "aws_s3_bucket_policy" "bucket-policy-kinesis" {
  bucket = aws_s3_bucket.data-log-bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Statement1",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "kinesis.amazonaws.com"
        },
        "Action" : "s3:PutObject",
        "Resource" : [
          "${aws_s3_bucket.data-log-bucket.arn}",
          "${aws_s3_bucket.data-log-bucket.arn}/*"
        ]
      }
    ]
  })
}

## DataStream
resource "aws_kinesis_stream" "my-console-stream" {
  name                      = "my-console-stream"
  shard_count               = 1 ## 현재 Shard 숫자
  retention_period          = 24
  enforce_consumer_deletion = true ## Consumer 삭제시 Stream 삭제 여부 

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = {
    Name     = "my-console-stream"
    Resource = "data-stream"
  }
}

## Data Firehoes
## 하기 귀찮음아서 그냥 넣었음..
resource "aws_kinesis_firehose_delivery_stream" "extended_s3" {
  name        = "my-console-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    prefix     = "/data"
    role_arn   = "arn:aws:iam::182024812696:role/service-role/KinesisFirehoseServiceRole-my-conso-ap-northeast-2-1701754985714"
    bucket_arn = "arn:aws:s3:::dk-log-bucket"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/my-console-stream"
      log_stream_name = "DestinationDelivery"
    }
    processing_configuration {
      enabled = "false"
    }
  }

  # kinesis_source_configuration {
  #   kinesis_stream_arn = "arn:aws:kinesis:ap-northeast-2:182024812696:stream/my-console-stream"
  #   role_arn           = "arn:aws:iam::182024812696:role/service-role/KinesisFirehoseServiceRole-my-conso-ap-northeast-2-1701754985714"
  # }

  server_side_encryption {
    enabled  = false
    key_type = "AWS_OWNED_CMK"
  }

  lifecycle {
    ignore_changes = [
      "kinesis_source_configuration",
    ]
  }
}
