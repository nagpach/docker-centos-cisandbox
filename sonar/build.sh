#!/bin/bash

docker stop sonar
docker rm sonar
docker build  -t cnbc/sonar .
