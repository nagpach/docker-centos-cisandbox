#!/bin/bash

docker stop ldap
docker rm ldap
docker build  -t cnbc/ldap .
