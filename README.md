# my-buffalo-docker-image

## Usage

```shell

docker run -it --rm -v "${PWD}:/src" -v "${HOME}:/tmp/home" -e "HOME=/tmp/home" --user "$(id -u):$(id -g)" my-buffalo:v0.18.7
```
