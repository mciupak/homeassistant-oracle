FROM --platform=$TARGETPLATFORM homeassistant/homeassistant

ENV LD_LIBRARY_PATH=/lib


ENV BUILD_PACKAGES="\
  build-base \
  linux-headers \
  libarchive-tools \
"

RUN apk add --no-cache --virtual=.build-deps build-base linux-headers libarchive-tools

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linux-arm64.zip && \
    bsdtar --strip-components=1 -xvf instantclient-basiclite-linux-arm64.zip -C /lib && \
    rm -rf instantclient-basiclite-linux-arm64.zip \
    else \
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip && \
    bsdtar --strip-components=1 -xvf instantclient-basiclite-linuxx64.zip -C /lib && \
    rm -rf instantclient-basiclite-linuxx64.zip \
    fi

RUN apk add libaio libnsl libc6-compat && \
    cd /lib && \
    ln -s /lib64/* /lib && \
    ln -s libnsl.so.2 /usr/lib/libnsl.so.1 && \
    ln -s libc.so.6 /lib/libresolv.so.2 \
    pip3 install --no-cache-dir cx_Oracle && \
    apk del .build-deps
    
