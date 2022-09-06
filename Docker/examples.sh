#! /bin/bash
# Build image for local testing
# Replace linux/arm64 with linux/amd64 if on a x86_64 system (Not Apple Silicon)
# Replace 0-9 based on number of cpus on your system. e.g 0-7 for 8 cores.  
docker buildx build . -t ghcr.io/karlamonterrubiog/competing_risks:latest --platform linux/arm64 --cpuset-cpus 0-9 --load

# Build ARM and x86 images and push to GitHub Container Registry
docker buildx build . -t ghcr.io/karlamonterrubiog/competing_risks:latest --platform linux/arm64,linux/amd64 --cpuset-cpus 0-9 --push

# Use image to render out html files
# Should pull image from Github Container Registry if not available locally
docker container run \
  --mount type=bind,source="$(pwd)"/Output,target=/Output \
  --mount type=bind,source="$(pwd)"/Source,target=/Source \
  --mount type=bind,source="$(pwd)"/Data,target=/Data \
  ghcr.io/karlamonterrubiog/competing_risks