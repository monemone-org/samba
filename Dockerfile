# ENV WSDD2_DIR="wsdd2-master"
# ARG WSDD2_TAR_URL="https://github.com/Netgear/wsdd2/archive/refs/heads/master.tar.gz"
ARG WSDD2_DIR="wsdd2-1.8.7"
ARG WSDD2_TAR_URL="https://github.com/Netgear/wsdd2/archive/refs/tags/1.8.7.tar.gz"
ARG ALPINE_VER=latest

FROM alpine:${ALPINE_VER} AS wsdd2-builder
ARG WSDD2_DIR
ARG WSDD2_TAR_URL

RUN apk add --no-cache make gcc libc-dev linux-headers
# RUN wget -O - ${WSDD2_TAR_URL} | tar zxvf -
COPY ./${WSDD2_DIR} /${WSDD2_DIR}
RUN cd ${WSDD2_DIR} && make


FROM alpine:${ALPINE_VER}
# alpine:3.14
ARG WSDD2_DIR

COPY --from=wsdd2-builder /${WSDD2_DIR}/wsdd2 /usr/sbin

ENV PATH="/container/scripts:${PATH}"

RUN apk add --no-cache runit \
                       tzdata \
                       avahi \
                       samba \
 \
 && sed -i 's/#enable-dbus=.*/enable-dbus=no/g' /etc/avahi/avahi-daemon.conf \
 && rm -vf /etc/avahi/services/* \
 \
 && mkdir -p /external/avahi \
 && touch /external/avahi/not-mounted \
 && echo done

VOLUME ["/shares"]

EXPOSE 137/udp 139 445

COPY . /container/

HEALTHCHECK CMD ["/container/scripts/docker-healthcheck.sh"]
ENTRYPOINT ["/container/scripts/entrypoint.sh"]

CMD [ "runsvdir","-P", "/container/config/runit" ]
