provider "aws" {
  region = "us-east-1"
}

variable "ami" {
  description = "value"
}

variable "instance_type" {
  description = "value"
  type = map(string)

  default = {
    "dev" = "t2.micro"
    "stage" = "t2.medium"
    "prod" = "t2.xlarge"
  }
}

variable "ami" {
  description = "This is AMI for the instance"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "s3-demo"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


# Remote execution - provisioners 
resource "null_resource" "remote_exec" {
  depends_on = [module.ec2_instance]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/my_key.pem")
      host        = module.ec2_instance.public_ip # or other IP reference based on output
    }

    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "echo 'Hello, World!' > /var/www/html/index.html"
    ]
  }
}