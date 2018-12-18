FROM tomcat:8.5

ENV ROOTDIR /usr/local/
ENV GDAL_VERSION 1.11.5
ENV LANG pt_BR.UTF-8 
ENV LANGUAGE pt_BR 
ENV LC_ALL pt_BR.UTF-8 
ENV LANG pt_BR.UTF-8

# Load assets
WORKDIR $ROOTDIR/
ADD http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz $ROOTDIR/src/

# Install basic dependencies
RUN apt-get update -y && apt-get install -y \
    python3-software-properties \
    build-essential \
    python-dev \
    python3-dev \
    python-numpy \
    python3-numpy \
    sqlite3 \
    libpq-dev \
    libcurl4-gnutls-dev \
    libproj-dev \
    libxml2-dev \
    libgeos-dev \
    libnetcdf-dev \
    libpoppler-dev \
    libspatialite-dev \
    libhdf4-alt-dev \
    libhdf5-serial-dev \
    wget \
    bash-completion \
    cmake \
    software-properties-common \
    net-tools \
    --reinstall procps \
    curl \
    default-jdk \
    git \
    maven

# Compile and install GDAL
RUN cd src && tar -xvf gdal-${GDAL_VERSION}.tar.gz && cd gdal-${GDAL_VERSION} \
    && ./configure --with-python --with-spatialite --with-pg --with-curl \
    && make && make install && ldconfig \
    && apt-get update -y \
    && apt-get remove -y --purge build-essential wget \
    && cd $ROOTDIR && cd src/gdal-${GDAL_VERSION}/swig/python \
    && python3 setup.py build \
    && python3 setup.py install \
    && cd $ROOTDIR && rm -Rf src/gdal* \
    && apt-get -y install gdal-bin

# Configure timezone and locale
RUN apt-get update \
    && apt-get install --reinstall -y locales \
    && sed -i 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen pt_BR.UTF-8  \
    && dpkg-reconfigure --frontend noninteractive locales

# GrassGis installation
RUN apt-get -y install grass grass-dev \ 
    && apt-get update

# R installation
RUN apt-get -y install r-base r-base-dev

#install libs R
#instalando bibliotecas R
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile \
    && Rscript -e "install.packages('sp', dependencies=TRUE)" \
    && Rscript -e "install.packages('png', dependencies=TRUE)" \
    && Rscript -e "install.packages('jpeg', dependencies=TRUE)" \
    && Rscript -e "install.packages('rgeos', dependencies=TRUE)" \
    && Rscript -e "install.packages('rgdal', dependencies=TRUE)" \
    && Rscript -e "install.packages('spdep', dependencies=TRUE)" \
    && Rscript -e "install.packages('rjson', dependencies=TRUE)" \
    && Rscript -e "install.packages('raster', dependencies=TRUE)" \
    && Rscript -e "install.packages('inline', dependencies=TRUE)" \
    && Rscript -e "install.packages('rgrass7', dependencies=TRUE)" \
    && Rscript -e "install.packages('plotrix', dependencies=TRUE)" \
    && Rscript -e "install.packages('stringi', dependencies=TRUE)" \
    && Rscript -e "install.packages('plotKML', dependencies=TRUE)" \
    && Rscript -e "install.packages('kriging', dependencies=TRUE)" \
    && Rscript -e "install.packages('maptools', dependencies=TRUE)" \
    && Rscript -e "install.packages('jsonlite', dependencies=TRUE)" \
    && Rscript -e "install.packages('gdalUtils', dependencies=TRUE)" \
    && Rscript -e "install.packages('geosphere', dependencies=TRUE)"

#Install PostgreSQL 9.6
RUN apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update && apt-get install -y apt-utils apt-transport-https ca-certificates \
    && apt-get -y -q install postgresql-9.6 postgresql-client-9.6 postgresql-contrib-9.6

# Postgis instalation
RUN apt-get install wget -y \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add \
    && apt-get update \
    && apt-get install postgis postgresql-9.6-postgis-2.3 postgresql-9.6-postgis-2.3-scripts -y 

ARG BUILD_DATE=unknown
ARG TRAVIS_COMMIT=unknown

LABEL org.label-schema.build-date=$BUILD_DATE \
          org.label-schema.name="Web, GIS and image processing Docker Image" \
          org.label-schema.description="SGS Docker image for Web, GIS and image processing" \
          org.label-schema.url="https://hub.docker.com/r/edineipiovesan/web-gis-imageprocessing" \
          org.label-schema.vcs-ref=$TRAVIS_COMMIT \
          org.label-schema.vcs-url="https://github.com/edineipiovesan/web-gis-imageprocessing" \
          org.label-schema.vendor="Edinei" \
          org.label-schema.version=$TRAVIS_COMMIT \
          org.label-schema.schema-version="1.0"

EXPOSE 8080