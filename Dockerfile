FROM arm64v8/alpine

#Update CA Certificates
RUN apk update \
	&& apk add ca-certificates wget zip curl \
	&& update-ca-certificates

# Install OpenJDK v8
RUN apk add --no-cache openjdk8

# specify env variables
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PAYARA_PATH /usr/local/payara5
ENV PATH $PATH:$JAVA_HOME/bin:$PAYARA_PATH/bin

# specify Payara version to download
ENV PAYARA_PKG https://repo1.maven.org/maven2/fish/payara/distributions/payara/5.2020.7/payara-5.2020.7.zip
ENV PAYARA_VERSION 5.2020.7
ENV PKG_FILE_NAME payara-full-${PAYARA_VERSION}.zip

# create user for payara
RUN \
 mkdir -p ${PAYARA_PATH}/deployments && \
 adduser -D -s /bin/bash -h ${PAYARA_PATH} payara && echo payara:payara | chpasswd

# Download Payara Server and install
RUN         curl -L -o /tmp/${PKG_FILE_NAME} ${PAYARA_PKG} && \
            unzip /tmp/${PKG_FILE_NAME} -d /usr/local && \
            rm -f /tmp/${PKG_FILE_NAME}

RUN         ls -al

EXPOSE      8080 4848 8181 8686 9009

#If you have an sh entrypoint file then add here
##ENTRYPOINT  ["/entrypoint.sh"]
