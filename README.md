# Old Chromium in Docker Container

This Dockerfile will allow you to run an old version of Chromium in Ubuntu `14:04` (trusty).

## Motivation

When you have a M-series MacBook you have an ARM-based CPU. This makes it difficult to compile and run old software that was made in the era when x86/amd was the norm. Using docker running under QEMU, to build and run makes it _possible_ to run x86 software. However, please note that this is highly unstable and experimental.

## Chromium Snapshot Revision to Version
- `v43` = `320008`
- `v36` = `260368` [link](https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html?prefix=Linux_x64/260368/)

## Build Docker Image
```
make build
```

## Run Docker Container
```
make run
```


## Start Chrome in the container using VNC
- `cd /opt/google/chrome`
- run: `USER=apps ./chrome --no-sandbox --user-data-dir=/home/apps --disable-gpu`

## Problems

### Can't play DRM protected videos
Since Chrome does not have any proper DRM keys

### Install Errors during `apt-get install`
Sometimes the install process just errors out when `apt-get install`. When you run it again it will work. It seems like the environment during `docker build` is highly unstable. When too many packages are being installed it seems to "confuse" the QEMU process. A simple fix is to add `--no-install-recommends` to the install command to limit the amount of packages being installed at the same time. And brute force seems to work to, juts try to build again. The reason I have made 1 line for each package to install is to let the docker process easily cache the previous steps in order to quickly resume where the last package failed. The tradeoff however is that this will bloat your local docker related storage. Rememebr to run `docker system prune`! Finally, it seems way more stable to run `apt-get install` inside the container when it's running. However, the tradeoff is that you will need to run the install everytime you start the container.

## Inspiration/Credits
Most of this code is copy pasted from this [article](https://medium.com/dot-debug/running-chrome-in-a-docker-container-a55e7f4da4a8) which sets up the VNC Server inside the container.
