# Variables
variable "dockerhub_password" { type = string }
variable "dockerhub_username" { type = string }
variable "push_repo" { type = string }
variable "container_tag" { type = string }
variable "author_name" { type = string }

# Source
source "docker" "alpine" {
  image  = "alpine:latest"
  commit = true
  changes = [
    "USER www",
    "ENV HOSTNAME alpine-nginx",
    "LABEL author \"${var.author_name}\"",
    "LABEL description \"Alpine Nginx Test Image\""
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
      repository = "${var.push_repo}"
      tags       = ["${var.container_tag}"]
    }
    post-processor "docker-push" {
      login          = true
      login_username = "${var.dockerhub_username}"
      login_password = "${var.dockerhub_password}"
    }
  }
}
