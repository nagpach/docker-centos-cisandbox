#!/bin/bash

docker stop jenkins 
docker rm jenkins 
docker run -itd --name jenkins --link ldap:ldap -p 8080:8080 cnbc/jenkins2 
