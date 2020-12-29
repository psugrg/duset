# Run Docker Container as Current Host User

Creates derived container that runs with local rights. It's a part of the
[DDEN](https://github.com/psugrg/dden) infrastructure and is a last step of
creating the development environment.

It'll build a dedicated image that derives from a base development environment
image and add a user that has the same user ID and group ID as the local user
that starts the compilation process.

In addition, when run standalone, it acts as a snippet to show how to add user
to the docker to avoid creating files as a ROOT user.

## Inspiration

This is a very simplified combination of approaches presented in the following
articles:
[1](https://jtreminio.com/blog/running-docker-containers-as-current-host-user/),
[2](https://medium.com/redbubble/running-a-docker-container-as-a-non-root-user-7d2e00f8ee15),
[3](https://vsupalov.com/docker-shared-permissions/),
[4](https://medium.com/faun/set-current-host-user-for-docker-container-4e521cef9ffc).

## Usage

### Install using curl

Use the following bash command to automatically install desired DDEN type
image.

```bash
curl -Lks https://raw.githubusercontent.com/psugrg/duset/main/duset.sh \
| /bin/bash -s <image-name>
```

Where:

- `<image-name>` - the name of the DDEN type of image to be installed.

The installed image will have the following name: `<image-name>-local` and
will be installed in `./local/bin` folder.

### Create an instance of the environment

Run the following command to create an instance of the environment.
The instance (container) will be created for the current folder. This means
that the current folder will be bind with the container that will be created.

```bash
~/.local/bin/<image-name>-local-create.sh <instance-name>
```

Where:

- `<instance-name>` - the name of the development environment instance (container).

### Alternative installation

Alternatively the image can be build and installed manually.

#### Build image

Use the following bash command to build a local image.

```bash
docker image build \
--build-arg IMAGE=<image-name>
--build-arg USER_ID=$(id -u ${USER}) \
--build-arg GROUP_ID=$(id -g ${USER}) \
--build-arg USER_NAME=${USER} \
--build-arg GROUP_NAME=${USER} \
-t <user-image-name> \
.
```

Where:

- `<image-name>` - the name of the base image you want to derive from.
- `<user-image-name>` - the name of the new image that will be created.

#### Install the environment

Run the following bash command to install DDEN type environment to the
`~/.local/user/bin` location.

```bash
docker run --rm -v "$HOME/.local/bin:/home/user/.local/bin" \ 
-e IMAGE_NAME=<user-image-name> \
<user-image-name> \
install.sh
```

## Standalone usage

For the standalone usage the `IMAGE` variable can be omitted and after the
image is build, user can start an example command (bash with the interactive
terminal).

### Build standalone image

```bash
docker image build \
--build-arg USER_ID=$(id -u ${USER}) \
--build-arg GROUP_ID=$(id -g ${USER}) \
--build-arg USER_NAME=${USER} \
--build-arg GROUP_NAME=${USER} \
-t duset \
.
```

### Run example command

```bash
docker run -it --rm duset /bin/bash
```
