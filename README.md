# docker-centos-cisandbox

docker rmi `docker images -q -f "dangling=true"`
docker rmi $(docker ps -a -q)
docker rm $(docker ps -a -q) 
docker rmi $(docker images | grep "^<none>" | awk "{print $3}") 
docker cp jenkins:/var/lib/jenkins/config.xml ../jenkins-master/files/var/lib/jenkins/config.xml
docker stop jenkins & docker rm jenkins
docker stop ldap & docker rm ldap
docker build  -t cnbc/jenkins2 .
docker run -itd --name ldap  cnbc/ldap
docker run -itd --name jenkins --link ldap:ldap -p 8080:8080 cnbc/jenkins2 
docker stop ldap & docker rm ldap
docker stop jenkins & docker rm jenkins
docker exec -it jenkins /bin/bash


docker run -itd --name ldapadmin --link ldap:ldap -p 98:80 cnbc/ldapadmin
docker-compose -f docker-compose-jenkins.yml rm
docker-compose -f docker-compose-jenkins.yml up
docker-compose exec jenkins /bin/bash


