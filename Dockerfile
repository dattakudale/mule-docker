FROM openjdk:8

LABEL name="sample mule esb" \
### Required labels above - recommended below
      url="https://github.com/dkudale/mule-docker.git" \
      run='docker run -tdi --name ${NAME} \
      -u 10001 \
      ${IMAGE}' \
      io.k8s.description="Mule ESB App 4.1.1" \
      io.k8s.display-name="Mule ESB App 4.1.1" \
      io.openshift.expose-services="" \
      io.openshift.tags="mule 4.1.1"

ENV MULE_HOME=/opt/mule-standalone-4.1.1

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y ntp wget procps && \
    apt-get autoclean && apt-get --purge -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN cd ~/ && wget https://repository.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/4.1.1/mule-standalone-4.1.1.tar.gz
RUN cd /opt && tar xvzf ~/mule-standalone-4.1.1.tar.gz
#RUN echo "6b5c3ae9c87f95b00f0c1aff300ca70c550f1952 ~/mule-standalone-4.1.1.tar.gz" | md5sum -c

RUN rm ~/mule-standalone-4.1.1.tar.gz

RUN mkdir -p /opt/mule-standalone-4.1.1/scripts
COPY ./startMule.sh /opt/mule-standalone-4.1.1/scripts/
COPY ./conf/wrapper.conf /opt/mule-standalone-4.1.1/conf/
COPY ./conf/log4j2.xml /opt/mule-standalone-4.1.1/conf/

ADD ./sample_app/*.jar ${MULE_HOME}/apps/

RUN ls -ltr ${MULE_HOME}/apps/

RUN chmod -R u+x ${MULE_HOME}/scripts && \
    chgrp -R 0 ${MULE_HOME} && \
    chmod -R g=u ${MULE_HOME} /etc/passwd

USER 10001
WORKDIR ${MULE_HOME}

# Define mount points.
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf", "${MULE_HOME}/apps", "${MULE_HOME}/domains"]
CMD [ "/opt/mule-standalone-4.1.1/scripts/startMule.sh" ]
EXPOSE 8081
