#!/bin/bash

docker stop jenkins
docker rm jenkins
docker build  -t cnbc/jenkins2 .
