#! /bin/bash

set -e

# Copy files from /usr/share/jenkins/ref into /var/lib/jenkins
# So the initial JENKINS-HOME is set with expected content. 
# Don't override, as this is just a reference setup, and use from UI 
# can then change this, upgrade plugins, etc.
copy_reference_file() {
	f=${1%/} 
	echo "$f" >> $COPY_REFERENCE_FILE_LOG
    rel=${f:23}
    dir=$(dirname ${f})
    echo " $f -> $rel" >> $COPY_REFERENCE_FILE_LOG
	if [[ ! -e /var/lib/jenkins/${rel} ]] 
	then
		echo "copy $rel to JENKINS_HOME" >> $COPY_REFERENCE_FILE_LOG
		mkdir -p /var/lib/jenkins/${dir:23}
		cp -r /usr/share/jenkins/ref/${rel} /var/lib/jenkins/${rel};
		# pin plugins on initial copy
		[[ ${rel} == plugins/*.jpi ]] && touch /var/lib/jenkins/${rel}.pinned
	fi; 
}
export -f copy_reference_file
echo "--- Copying files at $(date)" >> $COPY_REFERENCE_FILE_LOG
find /usr/share/jenkins/ref/ -type f -exec bash -c "copy_reference_file '{}'" \;


if [ -f "/var/lib/jenkins/config.xml" ]; then 
	ldap_admin_password=admin
	password64=$(echo -n "$ldap_admin_password" | base64)
	sed -i "s|<\(managerPassword\)>[^<]*</\1>|<\1>${password64}</\1>|" /var/lib/jenkins/config.xml
fi

#sudo chown -R jenkins:jenkins /var/lib/jenkins

# if `docker run` first argument start with `--` the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
   exec /usr/java/latest/bin/java $JAVA_OPTS -Djenkins.install.runSetupWizard=false -jar /usr/share/jenkins/jenkins.war $JENKINS_OPTS "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"
