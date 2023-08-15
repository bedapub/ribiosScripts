# Version-stable base R & src build tools
FROM rocker/tidyverse:latest

LABEL author="Roland Schmucki, Jitao David Zhang" \
      description="Base package for ribios scripts" \
      maintainer="roland.schmucki@roche.com"

# Github Personal Access Token (read public repo)
ARG GITHUB_PAT

## Required by devtools
## libnlopt-dev is only used for ribiosGSEA
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    libssl-dev libcurl4-openssl-dev \
    libfontconfig1-dev libxml2-dev libgit2-dev \
    libharfbuzz-dev libfribidi-dev libfreetype6-dev \
    libpng-dev libtiff5-dev libjpeg-dev \
    libx11-dev libcairo2-dev libmagick++-dev libmagick++-dev \
    alien curl libnlopt-dev && \
    rm -rf /var/lib/apt/lists/


# Install dependencies
RUN R -e "options(Ncpus = parallel::detectCores()); \
    chooseCRANmirror(ind = 1); \
    BiocManager::install(c(\
      'ComplexHeatmap', 'reshape', 'openxlsx', 'corrplot', 'plotrix',\
      'ggrepel', 'fgsea', 'randomForest', 'KEGGgraph',\
      'mgcv', 'caret', 'graph', 'RBGL' \
      ), dependencies = NA, update = FALSE, \
      ask = FALSE, upgrade_dependencies = FALSE)"

RUN R -e "install.packages('Vennerable', repos='http://R-Forge.R-project.org', \
      dependencies=TRUE, upgrade_dependencies = TRUE)"


# Install ribios packages
RUN R -e "options(Ncpus = parallel::detectCores()); \
      chooseCRANmirror(ind = 1); \
      BiocManager::install(c(\
      'bedapub/ribiosArg', \
      'bedapub/ribiosUtils', \
      'bedapub/ribiosIO', \
      'bedapub/ribiosAnnotation', \
      'bedapub/ribiosExpression', \
      'bedapub/ribiosNGS', \
      'bedapub/ribiosMath', \
      'bedapub/ribiosPlot', \
      'bedapub/ribiosGSEA'), \
      dependencies=TRUE, upgrade_dependencies = TRUE)" && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds 

## copy the scripts into the bin directory
WORKDIR /ribiosScripts/bin/
COPY ./scripts/*.Rscript /ribiosScripts/bin/
RUN chmod +x /ribiosScripts/bin/*.Rscript
ENV PATH "$PATH:/ribiosScripts/bin"
