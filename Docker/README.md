# README

This directory contains files useful for building or using Docker images.

## Manifest

```
Docker
├── README.md
├── examples.sh
├── render
└── render.R
```

[`examples.sh`](examples.sh) provides Bash one liners for building docker images,
deploying these images to the
[GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry),
and running the Docker image in a container. This code is primarily for
the maintainers of this repository to assist with building new images or for
those who wish to use this pipeline for their own analyses. Users should instead
follow the instructions in the Repository's [README](../README.md) for
instructions on how to use the Docker image.   

[`render`](render) and [`render.R`](render.R) are used by the Docker image to
render all of the Rmarkdown files found in `/Source` to the `/docs`
directory. `render` is a simple bash script which calls `render.R`. `render.R` 
contains the basic logic for rendering all R markdown files in `/Source`.  
