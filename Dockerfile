FROM openjdk:8

LABEL name="sample mule esb" \
### Required labels above - recommended below
      url="https://github.com/dkudale/mule-docker.git" \
      run='docker run -tdi --name ${NAME} \
      -u 10001 \
      ${IMAGE}' \
      io.k8s.description="Starter app will do ....." \
      io.k8s.display-name="Starter app" \
      io.openshift.expose-services="" \
      io.openshift.tags="mule,starter-arbitrary-uid,starter,arbitrary,uid"

#Run as mule user
#ENV RUN_AS_USER=mule

ENV MULE_HOME=/opt/mule-standalone-3.9.0

RUN apt-get update && \
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

#RUN chown -R 1001:1001 /opt/mule-standalone-3.9.0
#RUN chmod +x /opt/mule-standalone-3.9.0/scripts/startMule.sh

RUN chmod -R u+x ${MULE_HOME}/scripts && \
    chgrp -R 0 ${MULE_HOME} && \
    chmod -R g=u ${MULE_HOME} /etc/passwd

USER 10001
WORKDIR ${MULE_HOME}

# Define mount points.
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf", "${MULE_HOME}/apps", "${MULE_HOME}/domains"]
CMD [ "/opt/mule-standalone-3.9.0/scripts/startMule.sh" ]
