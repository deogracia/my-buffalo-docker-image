packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

variable "buffalo_version" {
  type    = string
  default = "0.18.14"
}

variable "docker_image_version" { # mon numéro de tag d'image docker
  type    = string
  default = "default_value"
}

source "docker" "buffalo" {
  image  = "gobuffalo/buffalo:v${var.buffalo_version}"
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
      "cd /tmp; wget https://github.com/gobuffalo/cli/releases/download/v${var.buffalo_version}/buffalo_${var.buffalo_version}_Linux_x86_64.tar.gz",
      "cd /tmp; tar xzf buffalo_${var.buffalo_version}_Linux_x86_64.tar.gz && chmod +x buffalo && mv -f buffalo /go/bin && rm -fr buffalo_${var.buffalo_version}_Linux_x86_64.tar.gz",
    ]
  }

  post-processor "docker-tag" {
    repository = "deogracia/my-buffalo"
    tags       = ["${var.docker_image_version}"]
  }
}
