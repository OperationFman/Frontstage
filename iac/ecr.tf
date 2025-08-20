resource "aws_ecr_repository" "backstage_ecr_repo" {
  name                 = var.ecr_repo
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.backstage_ecr_repo.repository_url
}
