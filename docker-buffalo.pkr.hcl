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
  default = "v0.18.8"
}

variable "docker_image_version" {
  type    = string
  default = "default_value"
}

source "docker" "buffalo" {
  image  = "gobuffalo/buffalo:${var.buffalo_version}"
  commit = true
  changes = [
    "ENTRYPOINT [\"/usr/local/bin/docker-entrypoint.bash\"]",
    "CMD [\"buffalo\"]"
  ]
}

build {
  name = "deogracia/my-buffalo"
  sources = [
    "source.docker.buffalo"
  ]

  provisioner "file" {
    source      = "scripts/docker-entrypoint.bash"
    destination = "/usr/local/bin/docker-entrypoint.bash"
  }

  provisioner "shell" {
    inline = ["chmod +x /usr/local/bin/docker-entrypoint.bash"]
  }

  provisioner "shell" {
    scripts = ["scripts/install_dependancies.bash"]
  }

  provisioner "shell" {
    scripts = ["scripts/install_gosu.bash"]
  }

  provisioner "shell" {
    inline = [
      "cd /tmp; wget https://github.com/gobuffalo/cli/releases/download/v0.18.8/buffalo_0.18.8_Linux_x86_64.tar.gz",
      "cd /tmp; tar xzf buffalo_0.18.8_Linux_x86_64.tar.gz && chmod +x buffalo && mv -f buffalo /go/bin",
    ]
  }

  post-processor "docker-tag" {
    repository = "deogracia/my-buffalo"
    tags       = ["${var.docker_image_version}"]
  }
}
