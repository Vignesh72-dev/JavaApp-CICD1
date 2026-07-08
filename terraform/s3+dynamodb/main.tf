resource "aws_s3_bucket" "s3-javaapp-cicd-tfstate" {
  bucket = "javaapp-cicd-tfstate-vignesh"
}

resource "aws_dynamodb_table" "dynamodb-table-tf-lock-javaapp" {
  name           = "javaapp-cicd-tf-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  

  attribute {
    name = "LockID"
    type = "S"
  }
}