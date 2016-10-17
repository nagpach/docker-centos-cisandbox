FROM cnbc/cibase:centos6

EXPOSE 389

RUN yum -y install openldap-clients openldap-servers \
    && yum -y clean all && rm -rf /var/cache/*

COPY entrypoint.sh /entrypoint
RUN chmod 700 /entrypoint

# LDAP configuration parameters
ENV organization EA
ENV domain ea.cnbc.com
ENV ldap_admin_password admin
ENV system_admin_password admin
ENV jenkins_bot_password jenkins

ENTRYPOINT ["/entrypoint"]
CMD ["slapd", "-u", "ldap", "-h", "ldap:/// ldapi:///", "-F", "/etc/openldap/slapd.d", "-d", "Stats"]

