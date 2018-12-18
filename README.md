[![Build Status](https://travis-ci.org/edineipiovesan/docker-image-web-gis-imageprocessing.svg?branch=master)](https://travis-ci.org/edineipiovesan/docker-image-web-gis-imageprocessing) ![](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg) [![](https://images.microbadger.com/badges/image/edineipiovesan/web-gis-imageprocessing.svg)](https://microbadger.com/images/edineipiovesan/web-gis-imageprocessing "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/commit/edineipiovesan/docker-image-web-gis-imageprocessing.svg)](https://microbadger.com/images/edineipiovesan/docker-image-web-gis-imageprocessing "Get your own commit badge on microbadger.com")
# Docker image for SGS Web application with GIS and image processing
Automated build for docker image used by SGS for Web applicatons that requires GIS and image processing.

This image is based on tomcat:8.5 and contains:
 - GDAL
 - GRASS7
 - R (with some GIS related packages)
 - PostgreSQL
 - PostGIS
 - Git, maven , curl, cmake, python and some other tools required to build applications above

Dockerfile by @autimio

# DockerHub

`docker pull edineipiovesan/web-gis-imageprocessing`

https://hub.docker.com/r/edineipiovesan/web-gis-imageprocessing

Tags are defined by commit hash and latest is always up-to-date with master branch. Check DockerHub repository to all tags available.


Feel free to use, extend and submit a pull request.