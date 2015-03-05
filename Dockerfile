FROM ubuntu:14.04

MAINTAINER Tobias Olsson <tobias@olsson.be>
# This is mostly copy paste from the doroka/tomcat docker
#MAINTAINER Carlos Moro <cmoro@deusto.es>

ENV TOMCAT_VERSION 8.0.20

# Set locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8

# Install dependencies

# Install JDK 8
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
apt-get update && apt-get install -y curl software-properties-common libapr1 && \
add-apt-repository -y ppa:webupd8team/java && \
apt-get update && \
apt-get install -y oracle-java8-installer && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/cache/oracle-jdk8-installer

ADD pol.tbz2 /

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle


RUN mkdir -p /opt/tomcat

# Get Tomcat
RUN curl -s http://apache.mirrors.spacedump.net/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz | tar zx --strip-components=1 -C /opt/tomcat

# Remove garbage
RUN rm -rf /opt/tomcat/webapps/examples
RUN rm -rf /opt/tomcat/webapps/docs
RUN rm -rf /opt/tomcat/webapps/ROOT
RUN rm -rf /opt/tomcat/webapps/webapps/*

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
WORKDIR /opt/tomcat

# Launch Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]

COPY *.war  /opt/tomcat/webapps/
