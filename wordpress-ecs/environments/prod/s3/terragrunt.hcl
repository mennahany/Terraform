terraform {
  source = "../../../modules/s3/"
}

inputs = {
  aws_region           = "us-east-1"
  bucket_name          = "wp-bucket-prod"

}