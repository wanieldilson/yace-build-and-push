data "aws_ecr_authorization_token" "token" {
  
}

locals {
  yace_version = "0.55.0"
}

resource "terraform_data" "yace_version" {
  input = local.yace_version
}


resource "aws_ecr_repository" "yace" {

  name                 = "ukss-${terraform.workspace}-yace"
  image_tag_mutability = "MUTABLE"

}

resource "null_resource" "build_and_push" {
  provisioner "local-exec" {
    command = <<EOF
      cd ${path.module}/images
      ./build_and_push.sh ${aws_ecr_repository.yace.repository_url} ${local.yace_version} ${data.aws_ecr_authorization_token.token.proxy_endpoint} ${nonsensitive(data.aws_ecr_authorization_token.token.password)}
      EOF
  }

  lifecycle {
    replace_triggered_by = [ terraform_data.yace_version ]
  }
  
}
