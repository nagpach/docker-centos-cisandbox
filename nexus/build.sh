#!/bin/bash

docker stop cnbc/nexus
docker rm nexus
docker build  -t cnbc/nexus .
