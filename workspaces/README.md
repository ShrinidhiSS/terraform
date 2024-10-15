Initialize and Apply Terraform Configurations for Each Workspace

To switch between workspaces and apply configurations, use the following commands:
Initialize the workspace environment:

terraform init


Create workspaces for dev, stage, and prod:

terraform workspace new dev
terraform workspace new stage
terraform workspace new prod

Switch to a specific workspace and apply its configuration:


terraform workspace select dev

terraform plan -var-file="dev.tfvars"

terraform apply -var-file="dev.tfvars"

Repeat the apply command for each workspace, selecting the appropriate workspace and .tfvars file.

The state files for different workspaces will be organized as below

s3-demo/
└── terraform/
    ├── dev/
    │   └── terraform.tfstate
    ├── stage/
    │   └── terraform.tfstate
    └── prod/
        └── terraform.tfstate
