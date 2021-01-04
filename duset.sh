#!/bin/bash

# Clone DUSET repository to a temporary location
rm -rf /tmp/duset 
git clone https://github.com/psugrg/duset.git /tmp/duset 
pushd /tmp/duset 

# Compile the image and run the installation script
# Note that the base image will be removed from the system after installation
docker image build --build-arg IMAGE="$@" \
  --build-arg USER_ID=$(id -u ${USER}) \
  --build-arg GROUP_ID=$(id -g ${USER}) --build-arg USER_NAME=${USER} \
  --build-arg GROUP_NAME=${USER} -t $@-local . \
&& docker run -e IMAGE_NAME="$@-local" --rm -v "$HOME/.local/bin:/home/user/.local/bin" \
"$@-local" install.sh \
&& docker rmi "$@"
&& echo "$@" installed as "$@-local" in ~/.local/bin 
|| (echo "Installation failed!" && docker rmi "$@-local")

popd
