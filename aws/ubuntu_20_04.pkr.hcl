packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

data "amazon-ami" "ubuntu-focal-east" {
  region = "us-east-2"
  filters = {
    name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
}

source "amazon-ebs" "ubuntu-focal-east" {
  region         = "us-east-2"
  source_ami     = data.amazon-ami.ubuntu-focal-east.id
  instance_type  = "t2.small"
  ssh_username   = "ubuntu"
  ssh_agent_auth = false
  ami_name       = "packer_AWS_UBUNTU_20.04_{{timestamp}}"
}

data "amazon-ami" "ubuntu-focal-west" {
  region = "us-west-2"
  filters = {
    name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
}

source "amazon-ebs" "ubuntu-focal-west" {
  region         = "us-west-2"
  source_ami     = data.amazon-ami.ubuntu-focal-west.id
  instance_type  = "t2.small"
  ssh_username   = "ubuntu"
  ssh_agent_auth = false
  ami_name       = "packer_AWS_UBUNTU_20.04_{{timestamp}}"
}

build {
  hcp_packer_registry {
    bucket_name = "demoland"
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
    "source.amazon-ebs.ubuntu-focal-east",
    "source.amazon-ebs.ubuntu-focal-west"
  ]

  provisioner "shell" {
    script = "./scripts/packer_install.sh"
  }
}
