FROM mciupak/hass-core

ENV LD_LIBRARY_PATH=/lib


ENV BUILD_PACKAGES="\
  build-base \
  linux-headers \
"

RUN wget https://download.oracle.com/otn_software/linux/instantclient/191000/instantclient-basic-linux.x64-19.10.0.0.0dbru.zip && \
    unzip instantclient-basic-linux.x64-19.10.0.0.0dbru.zip && \
    cp -r instantclient_19_10/* /lib && \
    rm -rf instantclient-basic-linux.x64-19.10.0.0.0dbru.zip && \
    apk add libaio && \
    apk add libaio libnsl libc6-compat && \
    cd /lib && \
    ln -s /lib64/* /lib && \
    ln -s libnsl.so.2 /usr/lib/libnsl.so.1 && \
    ln -s libc.so.6 /lib/libresolv.so.2


RUN apk add --no-cache --virtual=.build-deps build-base linux-headers && \
    pip3 install --no-cache-dir cx_Oracle && \
    apk del .build-deps
    
