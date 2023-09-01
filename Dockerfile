FROM rocker/rstudio:4.3.1

LABEL "org.opencontainers.image.source"="https://github.com/vallejosgroup/CompRisksVignettes" \
    "org.opencontainers.image.authors"="Nathan Constantine-Cooke <nathan.constantine-cooke@ed.ac.uk>" \
    "org.opencontainers.image.base.name"="rocker/rstudio:4.3.1" \
    "org.opencontainers.image.description"="Docker image for the CompRisksVignettes repository" \
    "org.opencontainers.image.vendor"="University of Edinburgh"

RUN apt clean

# Install system dependencies
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  # Install XML2
  libxml2-dev  \
  # Install the Cairo graphics library
  libcairo2-dev \
  # Install SQL libraries
  libsqlite-dev \
  libmariadb-dev \
  libpq-dev \
  # Install SSH libraries
  libssh2-1-dev \
  # Install ODBC libraries
  unixodbc-dev \
  # Install Cyrus SASL libraries
  libsasl2-dev \
  libgsl0-dev \
  # Needed for curl
  libcurl4-openssl-dev \
  # Install open SSL
  libssl-dev \
  # Install image magick
  libmagick++-dev \
  # Install rust
  cargo \
  # Needed for gifski
  libharfbuzz-dev \
  libfribidi-dev \
  # Needed for Rmarkdown
  pandoc \
  pandoc-citeproc \
  libgit2-dev \
  cmake \
  # Install java
  default-jdk \
  # Remove unneeded files to decrease image size
  && rm -rf /var/lib/apt/lists/*

# Install dependencies for installing bioconductor packages
RUN install2.r --error \
    --ncpus -1 \
    --repos https://ropensci.r-universe.dev --repos getOption \
    --skipinstalled \
    BiocManager littler

# Install packages from Bioconductor (will compile from source)
RUN /usr/local/lib/R/site-library/littler/examples/installBioc.r S4Vectors \
    biomaRt \
    KEGGgraph \
    BiocVersion

# Install igraph first or amd64 build will fail
RUN install2.r --error \
    --deps TRUE \
    --ncpus -1 \
    --repos https://ropensci.r-universe.dev --repos getOption \
    --skipinstalled \
    igraph

# Install remotes to download packages from github
RUN install2.r --error \
    --deps TRUE \
    --ncpus -1 \
    --repos https://ropensci.r-universe.dev --repos getOption \
    --skipinstalled \
    remotes

# Install archived packges (will compile from source)
RUN Rscript -e "library(remotes); install_github('cran/ipw'); install_github('cran/HI'); install_github('cran/BSGW')" 

# Install R packages on CRAN (will download binaries)
RUN install2.r --error \
    --deps TRUE \
    --ncpus -1 \
    --repos https://ropensci.r-universe.dev --repos getOption \
    --skipinstalled \
    rmarkdown \
    knitr \
    readr \
    pander \
    survival \
    rms \
    prodlim \
    riskRegression \
    pec \
    glmnet \
    survival \
    cmprsk \
    pseudo \
    geepack \
    timereg \
    coda \
    BART \
    nnet \
    randomForestSRC \
    splitstackshape \
    RcppProgress \
    tidyverse \
    patchwork \
    GGally \
    table1 \
    casebase

RUN install2.r --error \
    --deps FALSE \
    --ncpus -1 \
    --skipinstalled \
    stabs \
    inum \
    partykit \
    mboost \
    CFC

RUN Rscript -e "remotes::install_github('cran/binaryLogic'); remotes::install_github('cran/DPWeibull')"

RUN rm -rf /tmp/downloaded_packages \
    && strip /usr/local/lib/R/site-library/*/libs/*.so

RUN mkdir docs
RUN mkdir Source
RUN mkdir Outputs

WORKDIR /
COPY Docker /
RUN chmod u+x render
RUN mkdir Data


RUN chmod u+x render

#CMD Rscript render.R
