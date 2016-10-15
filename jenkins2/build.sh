#!/bin/bash

docker stop jenkins
docker rm jenkins
cd jenkins2
docker build  -t cnbc/jenkins2 .
