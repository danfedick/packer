packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "version" {
  type    = string
  default = "1.0.1"
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
  ami_name       = "packer_AWS_UBUNTU_20.04_{{timestamp}}_v${var.version}"
}

build {
#   hcp_packer_registry {
#     bucket_name = "demoland-ubuntu"
#     description = <<EOT
# This is the Ubuntu 20.04 image being published to NGC-JCO Packer Registry.
#     EOT
#     bucket_labels = {
#       "organization" = "demoland",
#       "team"         = "the special team",
#       "os"           = "Ubuntu 20.04"
#     }
#     build_labels = {
#       "organization" = "demoland",
#       "team"         = "the special team",
#       "os"           = "Ubuntu 20.04"
#       "iteration"    = "0.3"
#     }
  # }
  sources = [
    "source.amazon-ebs.ubuntu-focal-east",
  ]

  provisioner "shell" {
    script = "./scripts/node_configure.sh"
  }

}
