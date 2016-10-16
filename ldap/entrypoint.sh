#!/bin/bash

set -e

[ ! -f /var/lock/initialized ] || exec "$@"

# LDAP administrator
admin_user="admin"

ldap_domain_name=$(echo "$domain" | cut -f1 -d.)
ldap_domain_dn=$(echo ".$domain" | sed 's/\./,dc=/g;s/^,//')
eval ldap_admin_dn="cn=${admin_user},$ldap_domain_dn"

echo "${ldap_domain_name}"
echo "${ldap_domain_dn}"
echo "${ldap_admin_dn}"

slapd -u ldap -h "ldapi:///" -F /etc/openldap/slapd.d

eval SLAP_ADMIN_PWD=$(slappasswd -s "$ldap_admin_password")

echo "${SLAP_ADMIN_PWD}"

sed -i "s+%LDAP_ADMIN_DN%+${ldap_admin_dn//+/\\+}+" /root/admin.ldif
sed -i "s+%LDAP_ROOT_PASSWORD%+${SLAP_ADMIN_PWD//+/\\+}+" /root/admin.ldif

for i in $(cat /root/admin.ldif); do
echo $i
done

ldapmodify -Q -Y EXTERNAL -H "ldapi:///" -f /root/admin.ldif

MANAGER_PWD=$(slappasswd -s "$ldap_admin_password")
sed -i "s+%LDAP_MANAGER_PASSWORD%+${MANAGER_PWD//+/\\+}+" /root/domain.ldif
sed -i "s+%LDAP_ADMIN_DN%+${ldap_admin_dn//+/\\+}+" /root/domain.ldif
sed -i "s+%LDAP_ROOT_PASSWORD%+${SLAP_ADMIN_PWD//+/\\+}+" /root/domain.ldif
ldapmodify -Q -Y EXTERNAL -H "ldapi:///" -f /root/domain.ldif

ADMIN_PWD=$(slappasswd -s "${system_admin_password}")
USER_PWD=$(slappasswd -s "${jenkins_bot_password}")

echo "${MANAGER_PWD}"
echo "${ADMIN_PWD}"
echo "${USER_PWD}"


sed -i "s+%ORGANIZATION%+${organization//+/\\+}+" /root/users.ldif
sed -i "s+%LDAP_DOMAIN_NAME%+${ldap_domain_name//+/\\+}+" /root/users.ldif
sed -i "s+%LDAP_DOMAIN_DN%+${ldap_domain_dn//+/\\+}+" /root/users.ldif
sed -i "s+%ADMIN_PASSWORD%+${ADMIN_PWD//+/\\+}+" /root/users.ldif
sed -i "s+%USER_PASSWORD%+${USER_PWD//+/\\+}+" /root/users.ldif


for i in $(cat /root/users.ldif); do
echo $i
done

ldapadd -H "ldapi:///" -x -D "${ldap_admin_dn}" -w "${ldap_admin_password}" -f /root/users.ldif -d 2048
# Terminate temporary LDAP daemon, wait a bit to let it exit gracefully
killall -w slapd


# Proceed with CMD
touch /var/lock/initialized
exec "$@"

