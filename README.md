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
├── Aux                                               # Data preparation
│   ├── data_prep.R
├── docs
│   └── .nojekill
├── LICENSE
├── session.log                                       # R session info
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
  --mount type=bind,source="$(pwd)"/Aux,target=/Aux \
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
  --mount type=bind,source="$(pwd)"/Aux,target=/Aux \
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

_version:_  R version 4.3.1 (2023-06-16)  
_os:_       Ubuntu 22.04.3 LTS   
_system:_   aarch64, linux-gnu  
_ui:_       X11  
_language:_ (EN)  
_collate:_  en_US.UTF-8  
_ctype:_    en_US.UTF-8  
_tz:_       Etc/UTC  
_date:_     2023-12-19    
_pandoc:_   3.1.1 @ /usr/local/bin/ (via rmarkdown)


 **Packages**
|package     |   * version |   date (UTC) | lib source  |
| ---------- |-------------|--------------|------------ | 
|backports   |      1.4.1  |    2021-12-13 |[1] RSPM (R 4.3.1)|
|BART        |    * 2.9.4  |    2023-03-25 |[1] RSPM (R 4.3.1)|
|base64enc   |      0.1-3  |    2015-07-28 |[1] RSPM (R 4.3.1)|
|binaryLogic |      0.3.9  |    2017-12-13 |[1] Github (cran/binaryLogic@5408915)|
|broom       |      1.0.5  |    2023-06-09 |[1] RSPM (R 4.3.1)|
|bslib       |      0.5.1  |    2023-08-11 |[1] RSPM (R 4.3.1)|
|cachem      |      1.0.8  |    2023-05-01 |[1] RSPM (R 4.3.1)|
|checkmate   |      2.2.0  |    2023-04-27 |[1] RSPM (R 4.3.1)|
|cli         |      3.6.1  |   2023-03-23 |[1] RSPM (R 4.3.1)|
|cluster     |      2.1.4  |    2022-08-22 |[2] CRAN (R 4.3.1)|
|cmprsk      |    * 2.2-11 |    2022-01-06| [1] RSPM (R 4.3.1)|
|coda        |    * 0.19-4 |    2020-09-30 |[1] RSPM (R 4.3.1)|
|codetools   |      0.2-19 |    2023-02-01 |[2] CRAN (R 4.3.1)|
|colorspace  |      2.1-0  |    2023-01-23 |[1] RSPM (R 4.3.1)|
|data.table  |      1.14.8 |    2023-02-17 |[1] RSPM (R 4.3.1)|
|data.tree   |      1.0.0  |    2020-08-03 |[1] RSPM (R 4.3.1)|
|DiagrammeR  |      1.0.10 |    2023-05-18 |[1] RSPM (R 4.3.1)|
|digest      |      0.6.33 |    2023-07-07 |[1] RSPM (R 4.3.1)|
|dplyr       |    * 1.1.2  |    2023-04-20 |[1] RSPM (R 4.3.1)|
|DPWeibull   |    * 1.8    |    2021-12-12 |[1] Github (cran/DPWeibull@fd09b45)|
|evaluate    |      0.21   |    2023-05-05 |[1] RSPM (R 4.3.1)|
|evd         |      2.3-6.1|    2022-07-04 |[1] RSPM (R 4.3.1)|
|fansi       |      1.0.4  |   2023-01-22 |[1] RSPM (R 4.3.1)|
|fastmap     |      1.1.1  |    2023-02-24 |[1] RSPM (R 4.3.1)|
|forcats     |    * 1.0.0  |    2023-01-29 |[1] RSPM (R 4.3.1)|
|foreach     |      1.5.2  |    2022-02-02 |[1] RSPM (R 4.3.1)|
|foreign     |      0.8-84 |    2022-12-06 |[2] CRAN (R 4.3.1)|
|Formula     |      1.2-5  |    2023-02-24 |[1] RSPM (R 4.3.1)|
|future      |      1.33.0 |    2023-07-01 |[1] RSPM (R 4.3.1)|
|future.apply |     1.11.0 |    2023-05-21 |[1] RSPM (R 4.3.1)|
|geepack       |  * 1.3.9  |    2022-08-16 |[1] RSPM (R 4.3.1)|
|generics      |    0.1.3  |    2022-07-05 |[1] RSPM (R 4.3.1)|
|GGally        |  * 2.1.2  |    2021-06-21 |[1] RSPM (R 4.3.1)|
|ggplot2       |  * 3.4.3  |    2023-08-14 |[1] RSPM (R 4.3.1)|
|glmnet        |  * 4.1-8  |    2023-08-22 |[1] RSPM (R 4.3.1)|
|globals       |    0.16.2 |    2022-11-21 |[1] RSPM (R 4.3.1)|
|glue          |    1.6.2  |    2022-02-24 |[1] RSPM (R 4.3.1)|
|gridExtra     |    2.3    |    2017-09-09 |[1] RSPM (R 4.3.1)|
|gtable        |    0.3.4  |    2023-08-21 |[1] RSPM (R 4.3.1)|
|Hmisc         |  * 5.1-0  |    2023-05-08 |[1] RSPM (R 4.3.1)|
|hms           |    1.1.3  |    2023-03-21 |[1] RSPM (R 4.3.1)|
|htmlTable     |    2.4.1  |    2022-07-07 |[1] RSPM (R 4.3.1)|
|htmltools     |    0.5.6  |    2023-08-10 |[1] RSPM (R 4.3.1)|
|htmlwidgets   |    1.6.2  |    2023-03-17 |[1] RSPM (R 4.3.1)|
|inum         |     1.0-5    |  2023-03-09 |[1] RSPM (R 4.3.1)|
|iterators    |     1.0.14   |  2022-02-05 |[1] RSPM (R 4.3.1)|
|jquerylib    |     0.1.4    |  2021-04-26 |[1] RSPM (R 4.3.1)|
|jsonlite     |     1.8.7    |  2023-06-29 |[1] RSPM (R 4.3.1)|
|KMsurv       |   * 0.1-5    |  2012-12-03 |[1] RSPM (R 4.3.1)|
|knitr        |     1.43     |  2023-05-25 |[1] RSPM (R 4.3.1)|
|lattice     |      0.21-8   |  2023-04-05 |[2] CRAN (R 4.3.1)|
|lava        |      1.7.2.1  |  2023-02-27 |[1] RSPM (R 4.3.1)|
|libcoin     |      1.0-9    |  2021-09-27 |[1] RSPM (R 4.3.1)|
|lifecycle   |      1.0.3    |  2022-10-07 |[1] RSPM (R 4.3.1)|
|listenv      |     0.9.0    |  2022-12-16 |[1] RSPM (R 4.3.1)|
|lubridate    |   * 1.9.2.9000 |2023-09-01 |[1] https://ropensci.r-universe.dev (R 4.3.1)|
|magrittr     |     2.0.3    |  2022-03-30 |[1] RSPM (R 4.3.1)|
|MASS         |     7.3-60   |  2023-05-04 |[2] CRAN (R 4.3.1)|
|Matrix       |   * 1.6-1    |  2023-08-14 |[1] RSPM (R 4.3.1)|
|MatrixModels |     0.5-2    |  2023-07-10 |[1] RSPM (R 4.3.1)|
|mboost       |   * 2.9-7    |  2022-04-26 |[1] RSPM (R 4.3.1)|
|mets         |     1.3.2    |  2023-01-17 |[1] RSPM (R 4.3.1)|
|multcomp     |     1.4-25   |  2023-06-20 |[1] RSPM (R 4.3.1)|
|munsell      |     0.5.0    |  2018-06-12 |[1] RSPM (R 4.3.1)|
|mvtnorm      |     1.2-3    |  2023-08-25 |[1] RSPM (R 4.3.1)|
|nlme         |   * 3.1-162  |  2023-01-31 |[2] CRAN (R 4.3.1)|
|nnet         |   * 7.3-19   |  2023-05-03 |[2] CRAN (R 4.3.1)|
|nnls         |     1.4      |  2012-03-19 |[1] RSPM (R 4.3.1)|
|numDeriv     |     2016.8-1.1 |2019-06-06 |[1] RSPM (R 4.3.1)|
|pander       |   * 0.6.5    |  2022-03-18 |[1] RSPM (R 4.3.1)|
|parallelly   |     1.36.0   |  2023-05-26 |[1] RSPM (R 4.3.1)|
|partykit     |     1.2-20   |  2023-04-14 |[1] RSPM (R 4.3.1)|
|patchwork    |   * 1.1.3    |  2023-08-14 |[1] RSPM (R 4.3.1)|
|pec          |   * 2023.04.12| 2023-04-11 |[1] RSPM (R 4.3.1)|
|pillar       |     1.9.0    |  2023-03-22 |[1] RSPM (R 4.3.1)|
|pkgconfig    |     2.0.3    |  2019-09-22 |[1] RSPM (R 4.3.1)|
|plyr         |     1.8.8    |  2022-11-11 |[1] RSPM (R 4.3.1)|
|polspline    |     1.1.23   |  2023-06-29 |[1] RSPM (R 4.3.1)|
|prodlim      |   * 2023.08.28| 2023-08-28 |[1] RSPM (R 4.3.1)|
|pseudo       |   * 1.4.3    |  2017-07-30 |[1] RSPM (R 4.3.1)|
|purrr        |   * 1.0.2    |  2023-08-10 |[1] RSPM (R 4.3.1)|
|quadprog     |     1.5-8    |  2019-11-20 |[1] RSPM (R 4.3.1)|
|quantreg     |     5.97     |  2023-08-19 |[1] RSPM (R 4.3.1)|
|R6          |      2.5.1     | 2021-08-19 |[1] RSPM (R 4.3.1)|
|randomForestSRC| * 3.2.2    |  2023-05-23| [1] RSPM (R 4.3.1)|
|RColorBrewer    |  1.1-3    |  2022-04-03| [1] RSPM (R 4.3.1)|
|Rcpp            |  1.0.11   |  2023-07-06| [1] RSPM (R 4.3.1)|
|readr          | * 2.1.4    |  2023-02-10| [1] RSPM (R 4.3.1)|
|reshape         |  0.8.9    |  2022-04-12| [1] RSPM (R 4.3.1)|
|riskRegression  |* 2023.03.22| 2023-03-20| [1] RSPM (R 4.3.1)|
|rlang           |  1.1.1    |  2023-04-28| [1] RSPM (R 4.3.1)|
|rmarkdown       |  2.24     |  2023-08-14| [1] RSPM (R 4.3.1)|
|rms            | * 6.7-0    |  2023-05-08| [1] RSPM (R 4.3.1)|
|rpart          |   4.1.19   |  2022-10-21| [2] CRAN (R 4.3.1)|
|rstudioapi     |   0.15.0   |  2023-07-07| [1] RSPM (R 4.3.1)|
|sandwich       |  3.0-2    |  2022-06-15 |[1] RSPM (R 4.3.1)|
|sass           |   0.4.7   |   2023-07-15 |[1] RSPM (R 4.3.1)|
|scales         |   1.2.1   |   2022-08-20 |[1] RSPM (R 4.3.1)|
|sessioninfo    | * 1.2.2   |   2021-12-06 |[1] RSPM (R 4.3.1)|
|shape           |  1.4.6   |   2021-05-19 |[1] RSPM (R 4.3.1)|
|SparseM         |  1.81    |   2021-02-18 |[1] RSPM (R 4.3.1)|
|splitstackshape |* 1.4.8   |   2019-04-21 |[1] RSPM (R 4.3.1)|
|stabs           |* 0.6-4   |   2021-01-29 |[1] RSPM (R 4.3.1)|
|stringi         |  1.7.12  |   2023-01-11 |[1] RSPM (R 4.3.1)|
|stringr        | * 1.5.0   |   2022-12-02 |[1] RSPM (R 4.3.1)|
|survival       | * 3.5-5   |   2023-03-12 |[2] CRAN (R 4.3.1)|
|table1         | * 1.4.3   |   2023-01-06 |[1] RSPM (R 4.3.1)|
|TH.data        |   1.1-2   |   2023-04-17 |[1] RSPM (R 4.3.1)|
|tibble         | * 3.2.1   |   2023-03-20 |[1] RSPM (R 4.3.1)|
|tidyr          | * 1.3.0   |   2023-01-24 |[1] RSPM (R 4.3.1)|
|tidyselect      |  1.2.0   |   2022-10-10 |[1] RSPM (R 4.3.1)|
|tidyverse       |* 2.0.0   |   2023-02-22 |[1] RSPM (R 4.3.1)|
|timechange     |   0.2.0   |   2023-01-11 |[1] RSPM (R 4.3.1)|
|timereg        | * 2.0.5   |   2023-01-17 |[1] RSPM (R 4.3.1)|
|truncdist      |   1.0-2   |   2016-08-30 |[1] RSPM (R 4.3.1)|
|tzdb           |   0.4.0   |   2023-05-12 |[1] RSPM (R 4.3.1)|
|utf8           |   1.2.3   |   2023-01-31 |[1] RSPM (R 4.3.1)|
|vctrs          |   0.6.3   |   2023-06-14 |[1] RSPM (R 4.3.1)|
|visNetwork     |   2.1.2   |   2022-09-29 |[1] RSPM (R 4.3.1)|
|withr          |   2.5.0   |   2022-03-03 |[1] RSPM (R 4.3.1)|
|xfun           |   0.40    |   2023-08-09 |[1] RSPM (R 4.3.1)|
|yaml           |   2.3.7   |   2023-01-23 |[1] RSPM (R 4.3.1)|
|zoo            |   1.8-12  |   2023-04-13 |[1] RSPM (R 4.3.1)|

 [1] /usr/local/lib/R/site-library  
 [2] /usr/local/lib/R/library
|
