FROM openjdk:8

#Run as mule user
ENV RUN_AS_USER=mule

ENV MULE_HOME=/opt/mule-standalone-3.9.0

RUN groupadd -f ${RUN_AS_USER} && \
    useradd --system --home /home/${RUN_AS_USER} -g ${RUN_AS_USER} ${RUN_AS_USER} && \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y ntp wget procps && \
    apt-get autoclean && apt-get --purge -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN cd ~/ && wget https://repository.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/3.9.0/mule-standalone-3.9.0.tar.gz
RUN cd /opt && tar xvzf ~/mule-standalone-3.9.0.tar.gz
#RUN echo "39b773bf20702f614faf30b2ffca4716 ~/mule-standalone-3.9.0.tar.gz" | md5sum -c

RUN rm ~/mule-standalone-3.9.0.tar.gz

RUN mkdir -p /opt/mule-standalone-3.9.0/scripts
COPY ./startMule.sh /opt/mule-standalone-3.9.0/scripts/
COPY ./conf/wrapper.conf /opt/mule-standalone-3.9.0/conf/

RUN chown -R ${RUN_AS_USER}:${RUN_AS_USER} /opt/mule-standalone-3.9.0
RUN chmod +x /opt/mule-standalone-3.9.0/scripts/startMule.sh

WORKDIR ${MULE_HOME}

# Define mount points.
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf", "${MULE_HOME}/apps", "${MULE_HOME}/domains"]
CMD [ "/opt/mule-standalone-3.9.0/scripts/startMule.sh" ]
