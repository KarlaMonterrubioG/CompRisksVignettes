# Competing risks

This repository contains supplementary material for the paper: A review on competing risks methods for survival analysis.
It includes R vignettes to illustrate the usage of the following methods:

* Cause-specific formulation
  - Cause-specific Cox PH
  - Lasso CPH
  - Cox boosting
* CIF formulation
  - Fine-Gray
  - Pseudo-values
  - Direct binomial
  - Dependent Dirichlet processes
* Discrete time formulation
  - BART

## Usage

### Docker

A Docker image is provided to support our aim of creating reproducible research
by packaging together the operating system, the system packages, the R binary,
and the R packages used in our reports.  We provide images for both AMD64
(Intel and AMD processors) and ARM64 (Apple silicon) architectures. The correct
image should automatically be downloaded for your platform.   

**Instructions**

If you have not done so already, [install Docker](https://www.docker.com).

To use the Docker image, clone this repository and change into the
directory.

``` bash
$ git clone https://github.com/KarlaMonterrubioG/Competing_risks.git
$ cd Competing_risks
```

You can then run 

``` bash
$ docker container run \
  --mount type=bind,source="$(pwd)"/Output,target=/Output \
  --mount type=bind,source="$(pwd)"/Source,target=/Source \
  --mount type=bind,source="$(pwd)"/Data,target=/Data \
  ghcr.io/karlamonterrubiog/competing_risks
```

which will pull the docker image from the GitHub Container Registry and  use the
R markdown files in the [`Source`](Source) directory to render HTML files to the
[`Output`](Output) directory.

The image is quite large (2.46GB), so you may wish to delete the image once you
are finished:

``` bash
docker image rm ghcr.io/karlamonterrubiog/competing_risks
```

 <!-- To do! Add windows Docker installation instructions -->

### From RStudio

If you wish to avoid using Docker, you can instead run the below R code from the
top-level directory of this repository which should install all required
packages and render out the R markdown files. However, please note this approach
will only work for as long as all dependencies are available on CRAN.

``` R
if (!require("renv")) install.packages("renv")
install.packages(unique(renv::dependencies()[["Package"]]))
source("Docker/render.R")
```