# Use the latest version of R with support for binaries
FROM rocker/r-ver:4.2.1

RUN mkdir Output

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  # Install XML2
  libxml2-dev  \ 
  # Install the Cairo graphics library
  libcairo2-dev \
  libsqlite-dev \
  libmariadb-dev \ 
  libpq-dev \
  libssh2-1-dev \
  unixodbc-dev \
  libsasl2-dev \
  libgsl0-dev \
  # Needed for curl
  libcurl4-openssl-dev \ 
  # Open SSL
  libssl-dev \
  # Image Magick
  libmagick++-dev \
  # Rust
  cargo \
  # Needed for gifski
  libharfbuzz-dev \
  libfribidi-dev

# Install dependencies for installing bioconductor packages
RUN install2.r --error \
    --ncpus -1 \
    --repos https://ropensci.r-universe.dev --repos getOption \
    --skipinstalled \
    BiocManager littler

# Packages from Bioconductor (will compile from source)
RUN /usr/local/lib/R/site-library/littler/examples/installBioc.r S4Vectors 
RUN /usr/local/lib/R/site-library/littler/examples/installBioc.r biomaRt
RUN /usr/local/lib/R/site-library/littler/examples/installBioc.r  KEGGgraph 
RUN /usr/local/lib/R/site-library/littler/examples/installBioc.r BiocVersion

# Install R packages from CRAN (will download binaries)
# Packages from CRAN
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
    rms
RUN install2.r --error \
    --deps TRUE \
    --ncpus -1 \
    --repos https://ropensci.r-universe.dev --repos getOption \
    --skipinstalled \
    prodlim \
    riskRegression \ 
    pec \
    glmnet \ 
    survival 

RUN install2.r --error \
    --deps FALSE \
    --ncpus -1 \
    --skipinstalled \
    stabs
  
RUN install2.r --error \
    --deps FALSE \
    --ncpus -1 \
    --skipinstalled \
    inum

RUN install2.r --error \
    --deps FALSE \
    --ncpus -1 \
    --skipinstalled \
    partykit

RUN install2.r --error \
    --deps FALSE \
    --ncpus -1 \
    --skipinstalled \
    mboost

RUN rm -rf /tmp/downloaded_packages \
    && strip /usr/local/lib/R/site-library/*/libs/*.so   

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  pandoc
         
WORKDIR /
COPY . /
CMD Rscript -e 'rmarkdown::render("Source/CS_specification.Rmd", output_format = "html_document", output_dir = "Output")'