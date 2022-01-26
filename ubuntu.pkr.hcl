packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

data "amazon-ami" "ubuntu-xenial-east" {
  region = "us-east-2"
  filters = {
    name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
}

source "amazon-ebs" "basic-example-east" {
  region = "us-east-2"
  source_ami     = data.amazon-ami.ubuntu-xenial-east.id
  instance_type  = "t2.small"
  ssh_username   = "ubuntu"
  ssh_agent_auth = false
  ami_name       = "packer_AWS_{{timestamp}}"
}

data "amazon-ami" "ubuntu-xenial-west" {
  region = "us-west-2"
  filters = {
    name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
}

source "amazon-ebs" "basic-example-west" {
  region = "us-west-2"
  source_ami     = data.amazon-ami.ubuntu-xenial-west.id
  instance_type  = "t2.small"
  ssh_username   = "ubuntu"
  ssh_agent_auth = false
  ami_name       = "packer_AWS_{{timestamp}}"
}




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


