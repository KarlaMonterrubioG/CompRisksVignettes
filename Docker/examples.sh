#! /bin/bash
# Build image for local testing
# Replace linux/arm64 with linux/amd64 if on a x86_64 system (Not Apple Silicon)
# Replace 0-9 based on number of cpus on your system. e.g 0-7 for 8 cores.  
docker buildx build . -t ghcr.io/vallejosgroup/comprisksvignettes:latest --platform linux/arm64 --cpuset-cpus 0-9 --load

# Build ARM and x86 images and push to GitHub Container Registry
docker buildx build . -t ghcr.io/vallejosgroup/comprisksvignettes:latest --platform linux/arm64,linux/amd64 --cpuset-cpus 0-9 --push

# Use image to render out html files
# Should pull image from Github Container Registry if not available locally
docker container run \
  --mount type=bind,source="$(pwd)"/docs,target=/docs \
  --mount type=bind,source="$(pwd)"/Source,target=/Source \
  --mount type=bind,source="$(pwd)"/Data,target=/Data \
  --mount type=bind,source="$(pwd)"/Predictions,target=/Predictions \
  ghcr.io/vallejosgroup/comprisksvignettes ./render

open docs/CS_specification.html

# Run image with Rstudio Server
docker container run \
  --mount type=bind,source="$(pwd)"/docs,target=/docs \
  --mount type=bind,source="$(pwd)"/Source,target=/Source \
  --mount type=bind,source="$(pwd)"/Data,target=/Data \
  -e PASSWORD=password \
  -p 8787:8787 \
  ghcr.io/vallejosgroup/comprisksvignettes
