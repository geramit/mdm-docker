FROM ubuntu:18.04

MAINTAINER Amit Gera <amit.gera@gmail.com>

RUN apt-get update \
    && apt-get install -y --no-install-recommends libaio1 unzip openssl wget iputils-ping \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/awk /bin/awk

ARG WEB_SERVER=10.0.0.9
ARG USER=wasadmin
ARG GROUP=was
ARG IM_INSTALL_DIR=/app/IM
ARG IM_DATA_DIR=/var/IM/data
ARG WAS_HOME=/app/WebSphere

ENV WEBSPHERE_HOME="$WAS_HOME" \
    IM_INSTALL_DIR="$IM_INSTALL_DIR" \
    IM_DATA_DIR="$IM_DATA_DIR" \
    WORK_DIR="/home/$USER"

RUN mkdir -p $IM_INSTALL_DIR $IM_DATA_DIR $WEBSPHERE_HOME 

RUN groupadd $GROUP \
    && useradd -d /home/$USER -g $GROUP -G $GROUP -m -s /bin/bash $USER \
    && chown -R $USER:$GROUP $IM_INSTALL_DIR $IM_DATA_DIR $WEBSPHERE_HOME

USER $USER

# Install IBM Installation Manager
RUN wget -q http://$WEB_SERVER/agent.installer.linux.gtk.x86_64_1.8.6000.20161118_1611.zip -O /tmp/IM.zip \
    && mkdir /tmp/im && unzip -qd /tmp/im /tmp/IM.zip \
   && /tmp/im/installc -acceptLicense -accessRights nonAdmin \
      -installationDirectory $IM_INSTALL_DIR  \
      -dataLocation $IM_DATA_DIR -showProgress \
    && rm -rf /tmp/IM.zip /tmp/im

# IBM WebSphere Application Server v855
RUN wget -q http://$WEB_SERVER/WAS_V8.5.5_1_OF_3.zip -O /tmp/was1.zip \
    && wget -q http://$WEB_SERVER/WAS_V8.5.5_2_OF_3.zip -O /tmp/was2.zip \
    && wget -q http://$WEB_SERVER/WAS_V8.5.5_3_OF_3.zip -O /tmp/was3.zip \
    && mkdir /tmp/was && unzip -qd /tmp/was /tmp/was1.zip \
    && unzip -qd /tmp/was /tmp/was2.zip \
    && unzip -qd /tmp/was /tmp/was3.zip \
    && $IM_INSTALL_DIR/eclipse/tools/imcl -showProgress \
      -acceptLicense install com.ibm.websphere.BASE.v85 \
      -repositories /tmp/was/repository.config  \
      -installationDirectory $WEBSPHERE_HOME \
      -preferences com.ibm.cic.common.core.preferences.preserveDownloadedArtifacts=false \
    && rm -fr /tmp/was /tmp/was1.zip /tmp/was2.zip /tmp/was3.zip


# Install IBM WebSphere Application Server Fixpack v85513
RUN wget -q http://$WEB_SERVER/8.5.5-WS-WAS-FP013-part1.zip -O /tmp/wasfp1.zip \
    && wget -q http://$WEB_SERVER/8.5.5-WS-WAS-FP013-part2.zip -O /tmp/wasfp2.zip \
    && wget -q http://$WEB_SERVER/8.5.5-WS-WAS-FP013-part3.zip -O /tmp/wasfp3.zip \
    && mkdir /tmp/wasfp \
    && unzip -qd /tmp/wasfp /tmp/wasfp1.zip  \
    && unzip -qd /tmp/wasfp /tmp/wasfp2.zip \
    && unzip -qd /tmp/wasfp /tmp/wasfp3.zip \
    && $IM_INSTALL_DIR/eclipse/tools/imcl -showProgress \
      -acceptLicense install com.ibm.websphere.BASE.v85 \
      -repositories /tmp/wasfp/repository.config  \
      -installationDirectory $WEBSPHERE_HOME \
      -preferences com.ibm.cic.common.core.preferences.preserveDownloadedArtifacts=false \
    && rm -fr /tmp/wasfp /tmp/wasfp1.zip /tmp/wasfp2.zip /tmp/wasfp3.zip


# Install Java SDK 8.0
RUN wget -q http://$WEB_SERVER/8.0.5.6-WS-IBMWASJAVA-part1.zip -O /tmp/java1.zip \
    && wget -q http://$WEB_SERVER/8.0.5.6-WS-IBMWASJAVA-part2.zip -O /tmp/java2.zip \
    && mkdir /tmp/java \
    && unzip -qd /tmp/java /tmp/java1.zip  \
    && unzip -qd /tmp/java /tmp/java2.zip \
    && $IM_INSTALL_DIR/eclipse/tools/imcl -showProgress \
      -acceptLicense install com.ibm.websphere.IBMJAVA.v80 \
      -repositories /tmp/java/repository.config \
      -installationDirectory $WEBSPHERE_HOME \
      -preferences com.ibm.cic.common.core.preferences.preserveDownloadedArtifacts=false \
    && rm -fr /tmp/java /tmp/java1.zip /tmp/java2.zip

# Set the path so scripts are available
ENV PATH $WEBSPHERE_HOME/bin:$PATH

RUN managesdk.sh -setCommandDefault -sdkname 1.8_64 \
    && managesdk.sh -setNewProfileDefault -sdkname 1.8_64

CMD bash
