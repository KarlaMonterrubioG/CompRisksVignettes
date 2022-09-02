# README

This directory contains files useful for building or using Docker images.

## Manifest

```
Docker
├── README.md
├── compile.R
└── examples.sh
```

[`examples.sh`](examples.sh) provides Bash one liners for building docker images,
deploying these images to the
[GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry),
and running the Docker image in a container. This code is primarily for
the maintainers of this repository to assist with building new images. Users
should instead follow the instructions in the Repository's
[README](../README.md) for instructions on how to use the Docker image.   

[`render.R`](render.R) is used by the Docker image to render all of the
Rmarkdown files found in `/Source` to the `/Output` directory. 
