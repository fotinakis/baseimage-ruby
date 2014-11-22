# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.15
MAINTAINER Mike Fotinakis <mike@fotinakis.com>

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update
RUN apt-get install -y --no-install-recommends git-core build-essential curl wget

# Install ruby-install to manage ruby versions.
WORKDIR /tmp
RUN wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz
RUN tar -xzvf ruby-install-0.5.0.tar.gz
RUN cd ruby-install-0.5.0/ && sudo make install

# Install ruby.
RUN ruby-install --md5 02b7da3bb06037c777ca52e1194efccb ruby 2.1.3

# Inject the installed ruby bin dir into $PATH so that non-login shells can find ruby.
ENV PATH $PATH:/opt/rubies/ruby-2.1.3/bin

# Clean up APT and /tmp when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
