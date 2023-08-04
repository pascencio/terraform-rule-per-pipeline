provider aws {
}

resource aws_cloudwatch_event_rule pipeline {
  name        = "${var.codecommit_repository_name}-${var.codecommit_branch_name}"
  description = "Event for repository pipeline: ${var.codecommit_repository_name}"
  event_pattern = <<EOF
{
  "source": ["aws.codecommit"],
  "detail-type": ["CodeCommit Repository State Change"],
  "resources": ["${var.codecommit_repository_arn}"],
  "detail": {
    "event": ["referenceCreated", "referenceUpdated"],
    "referenceType": ["branch"],
    "referenceName": ["${var.codecommit_branch_name}"]
  }
}
EOF
}

resource aws_codepipeline pipeline {
  name     = var.codepipeline_name
  role_arn = var.codepipeline_role_arn
  artifact_store {
    location = var.codepipeline_bucket_name
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      name            = "SourceAction"
      category        = "Source"
      owner           = "AWS"
      provider        = "CodeCommit"
      version         = "1"
      output_artifacts = ["SourceArtifact"]
      configuration = {
        RepositoryName = var.codecommit_repository_name
        BranchName     = var.codecommit_branch_name
      }
      run_order = 1
    }
  }
  stage {
    name = "Build"
    action {
      name            = "BuildAction"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      configuration = {
        ProjectName = var.codebuild_project_name
        EnvironmentVariables = var.codebuild_environment_variables
      }
      run_order = 1
    }
  }
}

resource aws_iam_role pipeline {
  name = "codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource aws_iam_policy pipeline {
  name = "codepipeline-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "codepipeline:*"
        Resource = "*"
      }
    ]
  })
}

resource aws_iam_role_policy_attachment codebuild_policy_attachment {
  policy_arn = aws_iam_policy.pipeline.arn
  role       = aws_iam_role.pipeline.name
}

resource aws_cloudwatch_event_target target {
  rule      = aws_cloudwatch_event_rule.pipeline.name
  target_id = "${var.codecommit_repository_name}-${var.codecommit_branch_name}-${var.codepipeline_name}"
  arn       = aws_codepipeline.pipeline.arn
  role_arn  = aws_iam_role.pipeline.arn
}
