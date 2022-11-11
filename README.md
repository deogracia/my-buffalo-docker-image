# my-buffalo-docker-image

## Usage

```shell
docker volume create buffalo_go_volume
docker run -it --rm --env "USER_ID=$(id -g)" --env "GROUP_ID=$(id -g)" --volume "$(pwd):/src" --volume "buffalo_go_volume:/go" --publish 3000:3000 deogracia/my-buffalo:TAG COMMAND

# TAG     is one of the docker image tag available
# COMMAND is either a buffalo command (buffalo new, generate etc.) or another command (bash, ls etc.).
```

## Known issues

* When using `buffalo new`, it fails on the `{bzr,git} init` step, since there's no global {bzr,git} config.
  You can use `--vcs none` option.
