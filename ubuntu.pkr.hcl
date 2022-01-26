build {
  hcp_packer_registry {
    bucket_name = "ngc"
    description = <<EOT
This is the Ubuntu 20.04 image being published to NGC-JCO Packer Registry.
    EOT
    bucket_labels = {
      "organization" = "ngc",
      "team"         = "jco",
      "os"           = "Ubuntu 20.04"
    }
    build_labels = {
      "organization" = "ngc",
      "team"         = "jco",
      "os"           = "Ubuntu 20.04"
    }
  }
  sources = [
    "source.amazon-ebs.basic-example-east",
    "source.amazon-ebs.basic-example-west"
  ]

  provisioner "shell" {
    script       = "./scripts/install_system_packages.sh"
    pause_before = "10s"
    timeout      = "10s"
  }

  provisioner "shell" {
    script       = "./scripts/install_docker_compose.sh"
    pause_before = "10s"
    timeout      = "10s"
  }

  provisioner "shell" {
    script       = "./scripts/install_vault.sh"
    pause_before = "10s"
    timeout      = "10s"
  }
}


