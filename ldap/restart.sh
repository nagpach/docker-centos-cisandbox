#!/bin/bash

docker stop ldap
docker rm ldap
docker run -itd --name ldap cnbc/ldap
docker logs -f ldap
