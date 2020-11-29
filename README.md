# Running Docker Container as Current Host User

A `Dockerfile` snippet that shows how to add a user to the docker. The main intention 
of this project is to prevent creating files as the ROOT user.

This is a very simplified combination of approaches presented in the following articles:
- https://jtreminio.com/blog/running-docker-containers-as-current-host-user/
- https://medium.com/redbubble/running-a-docker-container-as-a-non-root-user-7d2e00f8ee15
- https://vsupalov.com/docker-shared-permissions/
- https://medium.com/faun/set-current-host-user-for-docker-container-4e521cef9ffc

## Usage

Build image:
```
docker image build \
--build-arg USER_ID=$(id -u ${USER}) \
--build-arg GROUP_ID=$(id -g ${USER}) \
--build-arg USER_NAME=${USER} \
--build-arg GROUP_NAME=${USER} \
-t duset \
.
```

Run container:
```
docker run -it --rm setusr /bin/bash
```
