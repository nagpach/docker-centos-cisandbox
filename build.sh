#!/bin/bash

cd cibase
docker build  -t cnbc/cibase .
cd ..

docker stop ldap
docker rm ldap
cd ldap
docker build  -t cnbc/ldap .
cd ..

docker stop ldapadmin
docker rm ldapadmin
cd ldapadmin
docker build  -t cnbc/ldapadmin .
cd ..

docker stop sonar
docker rm sonar
cd sonar
docker build  -t cnbc/sonar .
cd ..  

docker stop nexus
docker rm nexus
cd nexus
docker build  -t cnbc/nexus .
cd ..

docker stop jenkins
docker rm jenkins
cd jenkins2
docker build  -t cnbc/jenkins2 .
cd ..
