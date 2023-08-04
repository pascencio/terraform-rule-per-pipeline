# Terraform Rule per Pipeline

This is a little example how to create a pipeline avoiding target's limits per rule.

## Requirements

File `.env` with this environment variables:

```bash
export AWS_ACCESS_KEY_ID="<your-access-key-id>"
export AWS_SECRET_ACCESS_KEY="<your-secret-access-key>"
export AWS_DEFAULT_REGION="us-east-2" # Replace with your region
```

> For windows use WLS :smiley:

File `terraform.tfvars` with this variables:

```hcl
codepipeline_role_arn="your-role-arn"
codepipeline_name="your-pipeline-name"
codepipeline_bucket_name="your-bucket"
codecommit_repository_arn="your-arn"
codecommit_repository_name="your-repository"
codecommit_branch_name="master"
codebuild_project_name="your-project"
codebuild_environment_variables = "[{\"name\":\"SOME_VAR\",\"value\":\"some value\"}]"
```

## Getting Started

Let's go

```bash
source .env
terraform init
terraform plan
terraform apply
```

Now, destroy em all!

```bash
terraform destroy
```