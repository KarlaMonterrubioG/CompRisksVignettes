# Competing risks

This repository contains supplementary material for the paper: A review on statistical and machine learning competing risks survival methods.

It includes R vignettes to illustrate the usage of the following methods:

* [Cause-specific formulation](https://github.com/VallejosGroup/blob/main/Source/CS_specification.Rmd)
  + Cause-specific Cox PH
  + Sparse regression:
     - Lasso CPH
     - Cox model-based boosting
* [CIF formulation](https://github.com/VallejosGroup/CompRisksVignettes/blob/main/Source/CIF_specification.Rmd)
  + Fine-Gray
  + Pseudo-values
  + Direct binomial
  + Dependent Dirichlet processes
* [Discrete time formulation](https://github.com/VallejosGroup/CompRisksVignettes/blob/main/Source/Discrete_specification.Rmd)
  + BART
* [Other methods](https://github.com/VallejosGroup/CompRisksVignettes/blob/main/Source/Others.Rmd)
  + Random survival forests

## Structure

```
.
├── README.md                       
├── Data                                             # Example dataset
│   └── HD                   
│       └── hd.csv        
├── Docker                                           # Files for building/using Docker image
│   ├── README.md
│   ├── examples.sh
│   ├── render
│   └── render.R
├── Source                                           # Vignettes, includes Rmd and html files
│   ├── CIF_specification.Rmd
│   ├── CIF_specification.html
│   ├── CS_specification.Rmd
│   ├── CS_specification.html
│   ├── Discrete_specification.Rmd
│   ├── Discrete_specification.html
│   ├── Others.Rmd
│   ├── Others.html
│   ├── DataPreparation.Rmd
│   ├── DataPreparation.html
│   ├── Predictions.Rmd
│   ├── Predictions.html
│   ├── head.html
│   ├── index.Rmd
│   ├── navbar.html
│   ├── references.bib
│   └── style.css
├── Outputs                                           # Resulting images and csv files
│   ├── Comparision_estimation_CIF.pdf
│   ├── Comparision_estimation_CIF_BW.pdf
│   ├── Comparision_estimation_CSH.pdf
│   ├── Comparision_estimation_CSH_BW.pdf
│   ├── Comparision_predictions_t5.pdf
│   ├── Comparision_predictions_t5_covariates.pdf
│   ├── pred_CIF.csv
│   ├── pred_BART.csv
│   ├── pred_CS.csv
│   └── pred_Others.csv
├── Data_prep                                          # Data preparation
│   ├── data_prep.R
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

If you have not done so already, [install Docker](https://www.docker.com):

- **If you are using a Windows computer**, you will most likely need support for Windows
Subsystem for Linux 2 (WSL2) which requires BIOS-level hardware virtualisation
support to be enabled in the BIOS settings.

- **If you are using a Mac computer**, appropriate versions for the Intel or Apple
Silicon chips are available [here](https://docs.docker.com/desktop/install/mac-install/). 

To use the Docker image, clone this repository and go into the directory.

``` bash
git clone https://github.com/VallejosGroup/CompRisksVignettes.git
cd CompRisksVignettes
```

> **Note**: You may need to allocate more RAM to Docker if 8GB of RAM or less 
is allocated. If you are using Docker Desktop, you can allocate more RAM in the
settings panel (Settings > Resources > Advanced)

To pull (download) the image, run

``` bash
docker image pull ghcr.io/vallejosgroup/comprisksvignettes:latest
```

There are two ways to use the docker image:

1. **Interactive**:

This will run an Rstudio session inside the docker container with all packages 
required available. This can be used to run our vignettes interactively and may
be used when performing your own analysis. For example, this may be helpful when
applying the same methods to different data or when running a systematic benchmark
across methods (which may also include new methods). 

To do this, you can run:

``` bash
docker container run \
  --mount type=bind,source="$(pwd)"/docs,target=/docs \
  --mount type=bind,source="$(pwd)"/Data_prep,target=/Data_prep \
  --mount type=bind,source="$(pwd)"/Source,target=/Source \
  --mount type=bind,source="$(pwd)"/Data,target=/Data \
  --mount type=bind,source="$(pwd)"/Outputs,target=/Outputs \
  -e PASSWORD=password \
  -ti \
  -p 8787:8787 \
  ghcr.io/vallejosgroup/comprisksvignettes
```

Replacing the lowercase "`password`" with an alternative if desired. You can
then browse to `localhost:8787` in a web browser to get an Rstudio session. The
login username should be "rstudio" and the password will be "password" (unless
you have changed it).

You may wish to set the root directory as your working directory in Rstudio as
this is the working directory in the  non-interactive approach. This
can be achieved by running the below code in the Rstudio console:

``` R
setwd("/")
```
2. **Non-interactive**:

This can be used to reproduce our results by rendering the html reports. 
To render the html reports, run

``` bash
docker container run \
  --mount type=bind,source="$(pwd)"/docs,target=/docs \
  --mount type=bind,source="$(pwd)"/Data_prep,target=/Data_prep \
  --mount type=bind,source="$(pwd)"/Source,target=/Source \
  --mount type=bind,source="$(pwd)"/Data,target=/Data \
  --mount type=bind,source="$(pwd)"/Outputs,target=/Outputs \
  ghcr.io/vallejosgroup/comprisksvignettes ./render
```

which will then use the R markdown files in the [`Source`](Source) directory to
render HTML files to the [`docs`](docs) directory using the Docker image.



**Cleanup**

The Docker image is large (3.98GB), so you may wish to delete the image once you
are finished:

``` bash
docker image rm ghcr.io/vallejosgroup/comprisksvignettes
```

## Using a local R install

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




## Session info

**R version 4.3.1 (2023-06-16)**

**Platform:** aarch64-unknown-linux-gnu (64-bit) 

**locale:**
_LC_CTYPE=en_US.UTF-8_, _LC_NUMERIC=C_, _LC_TIME=en_US.UTF-8_, _LC_COLLATE=en_US.UTF-8_, _LC_MONETARY=en_US.UTF-8_, _LC_MESSAGES=en_US.UTF-8_, _LC_PAPER=en_US.UTF-8_, _LC_NAME=C_, _LC_ADDRESS=C_, _LC_TELEPHONE=C_, _LC_MEASUREMENT=en_US.UTF-8_ and _LC_IDENTIFICATION=C_

**attached base packages:** 
_parallel_, _stats_, _graphics_, _grDevices_, _utils_, _datasets_, _methods_ and _base_

**other attached packages:** 
_GGally(v.2.1.2)_, _randomForestSRC(v.3.2.2)_, _BART(v.2.9.4)_, _nlme(v.3.1-162)_, _nnet(v.7.3-19)_, _table1(v.1.4.3)_, _splitstackshape(v.1.4.8)_, _pander(v.0.6.5)_, _patchwork(v.1.1.3)_, _lubridate(v.1.9.2.9000)_, _forcats(v.1.0.0)_, _stringr(v.1.5.0)_, _dplyr(v.1.1.2)_, _purrr(v.1.0.2)_, _readr(v.2.1.4)_, _tidyr(v.1.3.0)_, _tibble(v.3.2.1)_, _ggplot2(v.3.4.3)_, _tidyverse(v.2.0.0)_, _coda(v.0.19-4)_, _DPWeibull(v.1.8)_, _timereg(v.2.0.5)_, _pseudo(v.1.4.3)_, _geepack(v.1.3.9)_, _KMsurv(v.0.1-5)_, _cmprsk(v.2.2-11)_, _mboost(v.2.9-7)_, _stabs(v.0.6-4)_, _glmnet(v.4.1-8)_, _Matrix(v.1.6-1)_, _pec(v.2023.04.12)_, _prodlim(v.2023.08.28)_, _riskRegression(v.2023.03.22)_, _rms(v.6.7-0)_, _Hmisc(v.5.1-0)_ and _survival(v.3.5-5)_

**loaded via a namespace (and not attached):** 
_gridExtra(v.2.3)_, _sandwich(v.3.0-2)_, _rlang(v.1.1.1)_, _magrittr(v.2.0.3)_, _multcomp(v.1.4-25)_, _polspline(v.1.1.23)_, _compiler(v.4.3.1)_, _vctrs(v.0.6.3)_, _quantreg(v.5.97)_, _quadprog(v.1.5-8)_, _pkgconfig(v.2.0.3)_, _shape(v.1.4.6)_, _fastmap(v.1.1.1)_, _backports(v.1.4.1)_, _inum(v.1.0-5)_, _utf8(v.1.2.3)_, _rmarkdown(v.2.24)_, _tzdb(v.0.4.0)_, _MatrixModels(v.0.5-2)_, _xfun(v.0.40)_, _jsonlite(v.1.8.7)_, _reshape(v.0.8.9)_, _data.tree(v.1.0.0)_, _broom(v.1.0.5)_, _cluster(v.2.1.4)_, _R6(v.2.5.1)_, _RColorBrewer(v.1.1-3)_, _stringi(v.1.7.12)_, _parallelly(v.1.36.0)_, _rpart(v.4.1.19)_, _numDeriv(v.2016.8-1.1)_, _Rcpp(v.1.0.11)_, _iterators(v.1.0.14)_, _knitr(v.1.43)_, _future.apply(v.1.11.0)_, _zoo(v.1.8-12)_, _base64enc(v.0.1-3)_, _timechange(v.0.2.0)_, _nnls(v.1.4)_, _splines(v.4.3.1)_, _tidyselect(v.1.2.0)_, _rstudioapi(v.0.15.0)_, _partykit(v.1.2-20)_, _codetools(v.0.2-19)_, _listenv(v.0.9.0)_, _plyr(v.1.8.8)_, _lattice(v.0.21-8)_, _withr(v.2.5.0)_, _evaluate(v.0.21)_, _foreign(v.0.8-84)_, _future(v.1.33.0)_, _pillar(v.1.9.0)_, _DiagrammeR(v.1.0.10)_, _checkmate(v.2.2.0)_, _foreach(v.1.5.2)_, _stats4(v.4.3.1)_, _generics(v.0.1.3)_, _hms(v.1.1.3)_, _munsell(v.0.5.0)_, _scales(v.1.2.1)_, _globals(v.0.16.2)_, _glue(v.1.6.2)_, _binaryLogic(v.0.3.9)_, _tools(v.4.3.1)_, _data.table(v.1.14.8)_, _SparseM(v.1.81)_, _visNetwork(v.2.1.2)_, _mvtnorm(v.1.2-3)_, _grid(v.4.3.1)_, _libcoin(v.1.0-9)_, _truncdist(v.1.0-2)_, _colorspace(v.2.1-0)_, _htmlTable(v.2.4.1)_, _Formula(v.1.2-5)_, _cli(v.3.6.1)_, _evd(v.2.3-6.1)_, _fansi(v.1.0.4)_, _lava(v.1.7.2.1)_, _mets(v.1.3.2)_, _gtable(v.0.3.4)_, _digest(v.0.6.33)_, _TH.data(v.1.1-2)_, _htmlwidgets(v.1.6.2)_, _htmltools(v.0.5.6)_, _lifecycle(v.1.0.3)_ and _MASS(v.7.3-60)_

