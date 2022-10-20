# Variables
variable "dockerhub_password" { type = string }
variable "dockerhub_username" { type = string }
variable "push_repo" { type = string }

# Source
source "docker" "alpine" {
  image  = "alpine:latest"
  commit = true
  changes = [
    "USER www",
    "ENV HOSTNAME alpine-nginx",
  ]
}

# Build

build {
  sources = ["source.docker.alpine"]

  provisioner "shell" {
    inline = [
      "apk add nginx"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      # repository = "danfedick/nginx"
      repository = "${var.push_repo}"
      tags       = ["1.0"]
    }
    post-processor "docker-push" {
      login          = true
      login_username = "${var.dockerhub_username}"
      login_password = "${var.dockerhub_password}"
    }
  }
}
