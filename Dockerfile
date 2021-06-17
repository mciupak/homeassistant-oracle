ARG VERSION
FROM --platform=$TARGETPLATFORM homeassistant/home-assistant:$VERSION
ARG TARGETPLATFORM

ENV LD_LIBRARY_PATH=/lib

RUN if [ "$BUILD_ARCH" = "aarch64" ] || [ "$BUILD_ARCH" = "amd64" ] || [ "$BUILD_ARCH" = "i386" ]; then \
        if [ "$BUILD_ARCH" = "aarch64" ]; then \
            instantclient_arch="-arm64"; \
        elif [ "$BUILD_ARCH" = "amd64" ]; then \
            instantclient_arch="x64"; \
        elif [ "$BUILD_ARCH" = "i386" ]; then \
            instantclient_arch=""; \
        fi && \
        apk add --no-cache --virtual=.build-dependencies build-base linux-headers libarchive-tools && \
        #Permanent link to the latest package
        wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linux${instantclient_arch}.zip && \
        bsdtar --strip-components=1 -xvf instantclient-basiclite-linux${instantclient_arch}.zip -C /lib && \
        rm -rf instantclient-basiclite-linux${instantclient_arch}.zip &&  \
        apk add libaio libnsl libc6-compat && \
        cd /lib && \
        ln -s /lib64/* /lib && \
        ln -s libnsl.so.2 /usr/lib/libnsl.so.1 && \
        ln -s libc.so.6 /lib/libresolv.so.2 && \
        pip3 install --no-cache-dir cx_Oracle && \
        apk del .build-dependencies; \
    fi
