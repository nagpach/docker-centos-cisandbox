#!/bin/bash

docker stop ldapadmin
docker rm ldapadmin
docker build  -t cnbc/ldapadmin .
