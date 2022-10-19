
# Source
source "docker" "alpine" {
  image  = "alpine:latest"
  commit = true
  changes = [
    "USER thefed",
    "ENV HOSTNAME FedHost",
    "LABEL author=\"Dan Fedick\""
  ]
}

build {
  sources = [ "source.docker.alpine"]

  provisioner "shell" {
    inline = [
      "apk add nginx"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "danfedick/nginx"
      tags       = ["1.0"]
    }
    post-processor "docker-push" {
      login = true
    }
  }
}
