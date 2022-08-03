packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

variable "buffalo_version" {
  type    = string
  default = "v0.18.7"
}

variable "docker_image_version" {
  type    = string
  default = "default_value"
}

source "docker" "buffalo" {
  image  = "gobuffalo/buffalo:${var.buffalo_version}"
  commit = true
  run_command = [
    "-d", "-i", "-t", "--entrypoint=/bin/bash", "--", "{{.Image}}"
  ]
}

build {
  name = "deogracia/my-buffalo"
  sources = [
    "source.docker.buffalo"
  ]

  provisioner "shell" {
    inline = [
      "chmod -R 777 \"$GOPATH\""
    ]
  }

  post-processor "docker-tag" {
    repository = "deogracia/my-buffalo"
    tags       = ["${var.docker_image_version}"]
  }
}
