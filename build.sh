
docker stop ldap
docker rm ldap
cd ldap
docker build  -t cnbc/ldap .
cd ..

docker stop jenkins
docker rm jenkins
cd jenkins2
docker build  -t cnbc/jenkins2 .
cd ..
