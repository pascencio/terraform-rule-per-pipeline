variable codepipeline_role_arn {
  type        = string
  description = "CodePipeline role ARN"
}

variable codepipeline_name {
  type        = string
  description = "CodePipeline name"
}

variable codepipeline_bucket_name {
  type        = string
  description = "CodePipeline artifact bucket"
}

variable codecommit_repository_arn {
  type        = string
  description = "CodeCommit repository ARN"
}

variable codecommit_repository_name {
  type        = string
  description = "CodeCommit repository name"
}

variable codecommit_branch_name {
  type        = string
  description = "CodeCommit branch name"
}


variable codebuild_project_name {
  type        = string
  description = "CodeBuild project name"
}

variable codebuild_environment_variables {
  type        = string
  description = "CodeBuild environment variables list"
}

