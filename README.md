# Competing risks

This repository contains supplementary material for the paper: A review on
competing risks methods for survival analysis.

It includes R vignettes to illustrate the usage of the following methods:

* [Cause-specific formulation](https://github.com/KarlaMonterrubioG/vallejosgroup/blob/main/Source/CS_specification.Rmd)
  + Cause-specific Cox PH
  + Sparse regression:
     - Lasso CPH
     - Cox boosting
* [CIF formulation](https://github.com/vallejosgroup/CompRisksVignettes/blob/main/Source/CIF_specification.Rmd)
  + Fine-Gray
  + Pseudo-values
  + Direct binomial
  + Dependent Dirichlet processes
* [Discrete time formulation](https://github.com/vallejosgroup/CompRisksVignettes/blob/main/Source/Discrete_specification.Rmd)
  + BART
* [Other methods](https://github.com/vallejosgroup/CompRisksVignettes/blob/main/Source/Others.Rmd)
  + Random survival forests

### Structure

```
.
├── README.md                       
├── Data                               # Example dataset
│   └── HD                   
│       └── hd.csv        
├── Docker                             # Files for building/using Docker image
│   ├── README.md
│   ├── examples.sh
│   ├── render
│   └── render.R
├── Predictions                        # Resulting predictions in test set
│   ├── pred_CIF.csv
│   ├── pred_CS.csv
│   └── pred_Others.csv
├── Source                             # Vignettes, includes Rmd and html files
│   ├── CIF_specification.Rmd
│   ├── CIF_specification.html
│   ├── CS_specification.Rmd
│   ├── CS_specification.html
│   ├── Discrete_specification.Rmd
│   ├── Discrete_specification.html
│   ├── Others.Rmd
│   ├── Others.html
│   ├── Predictions.Rmd
│   ├── head.html
│   ├── index.Rmd
│   ├── navbar.html
│   ├── references.bib
│   └── style.css
├── docs
│   └── .nojekill
├── LICENSE
├── Dockerfile
└── Competing_risks.Rproj
   

```

## Usage

### Docker

A Docker image is provided to support our aim of creating reproducible research
by packaging together the operating system, the system packages, the R binary,
and the R packages used in our reports. Docker containers can be thought of as
being similar to virtual machines and an image contains what is inside the
virtual machine (such as installed software). We provide images for both AMD64
(Intel and AMD processors) and ARM64 (Apple silicon) architectures. The correct
image should automatically be downloaded for your platform.   

**Instructions**

If you have not done so already, [install Docker](https://www.docker.com). If
you are using a Windows computer, you will most likely need support for Windows
Subsystem for Linux 2 (WSL2) which requires BIOS-level hardware virtualisation
support to be enabled in the BIOS settings. 

To use the Docker image, clone this repository and go into the directory.

``` bash
$ git clone https://github.com/vallejosgroup/CompRisksVignettes.git
$ cd CompRisksVignettes
```

> **Note**: You may need to allocate more RAM to Docker if 8GB of RAM or less 
is allocated. If you are using Docker Desktop, you can allocate more RAM in the
settings panel (Settings > Resources > Advanced)

To pull (download) the image, run

``` bash
docker image pull ghcr.io/vallejosgroup/comprisksvignettes:latest
```

To render the html reports, run

``` bash
$ docker container run \
  --mount type=bind,source="$(pwd)"/docs,target=/docs \
  --mount type=bind,source="$(pwd)"/Source,target=/Source \
  --mount type=bind,source="$(pwd)"/Data,target=/Data \
  ghcr.io/vallejosgroup/comprisksvignettes ./render
```

which will then use the R markdown files in the [`Source`](Source) directory to
render HTML files to the [`docs`](docs) directory using the Docker image.

If you would prefer to instead open an Rstudio session inside the docker
container with all packages required available, you can run

``` bash
$ docker container run \
  --mount type=bind,source="$(pwd)"/docs,target=/docs \
  --mount type=bind,source="$(pwd)"/Source,target=/Source \
  --mount type=bind,source="$(pwd)"/Data,target=/Data \
  -e PASSWORD=password \
  -p 8787:8787 \
  ghcr.io/vallejosgroup/comprisksvignettes
```

Replacing the lowercase "`password`" with an alternative if desired. You can
then browse to `localhost:8787` in a web browser to get an Rstudio session. The
login username should be "rstudio" and the password will be "password" (unless
you have changed it)

**Cleanup**

The Docker image is large (3.88GB), so you may wish to delete the image once you
are finished:

``` bash
docker image rm ghcr.io/vallejosgroup/comprisksvignettes
```

### Using a local R install

If you wish/have to avoid using Docker, you can instead run the below R code
from the top-level directory of this repository which should install all
required packages and render out the R markdown files. However, please note this
approach will only work for as long as all dependencies (except `binaryLogic`
and `DPWeibull`) are available on CRAN.

``` R
if (!require("renv")) install.packages("renv")
if (!require("remotes")) install.packages("remotes")
install.packages(unique(renv::dependencies()[["Package"]]))
remotes::install_github('cran/binaryLogic')
remotes::install_github('cran/DPWeibull')
source("Docker/render.R")
```

## Contributions

| Author                    | Affiliation                                       | Contribution                                       |
| ------------------------- |---------------------------------------------------|--------------------------                          |
| [Karla Monterrubio-Gómez](https://github.com/KarlaMonterrubioG)| University of Edinburgh   | Author of .Rmd files                  |
| [Nathan Constantine-Cooke](https://github.com/nathansam)| University of Edinburgh | Review .Rmd files, author Docker image         |
| [Catalina A. Vallejos](https://github.com/catavallejos)| University of Edinburgh, The Alan Turing Institute| Author/Reviewer .Rmd files |

**We welcome contributions!**

If you are interested in adding a method to the list, please create a PR adding the method to the corresponding vignette using the same example dataset.
