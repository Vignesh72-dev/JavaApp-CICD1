terraform {
  
  backend "s3" {
    bucket         = "javaapp-cicd-tfstate-vignesh"   # must be globally unique - change before use
    key            = "jenkins-server/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "javaapp-cicd-tf-lock"
    encrypt        = true
  }
}
