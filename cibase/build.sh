#!/bin/bash

docker build -f Dockerfile.centos6 -t cnbc/cibase:centos6 .
docker build -f Dockerfile.centos7 -t cnbc/cibase:centos7 .
