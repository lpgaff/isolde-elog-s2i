# isolde-elog-sso-test
FROM almalinux:latest

# TODO: Put the maintainer name in the image metadata
MAINTAINER Liam Gaffney <liam.gaffney@cern.ch>

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building PSI elog for ISOLDE" \
      io.k8s.display-name="isolde-elog-sso-test" \
      io.openshift.expose-services="8080:http,9090:https" \
      io.openshift.tags="builder,isolde-elog,elog"

# TODO: Install required packages here:
RUN dnf install -y epel-release
RUN dnf install -y sendmail sendmail-cf
RUN dnf install -y glibc
RUN dnf install -y rsyslog
RUN dnf install -y openssl-devel
RUN dnf install -y emacs-nox
RUN dnf install -y nano
RUN dnf install -y ghostscript
RUN dnf install -y ImageMagick
#RUN dnf install -y ckeditor4
#RUN dnf install -y elog
#RUN dnf install -y elog-client
RUN dnf clean all -y

# Get the elog from Git
RUN git clone https://bitbucket.org/ritt/elog --recursive
RUN cd ./elog/; sed 's/USE_KRB5   = 0/USE_KRB5   = 1/g' Makefile > Makefile2; sed 's/CFLAGS +=/CFLAGS += -std=c++11/g' Makefile2 > Makefile3; mv Makefile3 Makefile; make install
#RUN systemctl start elogd

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root
#RUN chown -R 1001:1001 /var/lib/elog
RUN mkdir /etc/logbooks
RUN chown -R 1001:1001 /etc/logbooks
RUN chmod -R +r /var/log

# Set timezone
RUN mv /etc/localtime /etc/localtime.old
RUN ln -s /usr/share/zoneinfo/Europe/Zurich /etc/localtime

# Do sendmail configuration
COPY ./sendmail.mc /etc/mail/sendmail.mc
RUN cd /etc/mail/; make

# This default user is created in the image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# Copy the entry point startup command script
COPY ./entrypoint.sh /opt/app-root/entrypoint.sh

# TODO: Set the default ENTRYPOINT and CMD for the image
ENTRYPOINT ["/opt/app-root/entrypoint.sh"]
