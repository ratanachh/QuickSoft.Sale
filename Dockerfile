# source: https://github.com/kiasaki/docker-alpine-postgres
FROM alpine

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk update && \
    apk add curl "libpq@edge<9.7" "postgresql-client@edge<9.7" "postgresql@edge<9.7" "postgresql-contrib@edge<9.7" && \
    curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu && \
    apk del curl && \
    rm -rf /var/cache/apk/*

ENV LANG en_US.utf8
ENV PGDATA /var/lib/postgresql/data/

ENV POSTGRES_DB datastore
ENV POSTGRES_USER docker
ENV POSTGRES_PASSWORD letmein

RUN mkdir -p /opt/setup/data-scripts.d/
RUN mkdir -p /zdata/
COPY ./data-scripts.d/* /opt/setup/data-scripts.d/

WORKDIR /opt/setup/
COPY db-setup.sh /opt/setup/
COPY db-pack.sh /opt/setup/
COPY db-run.sh /opt/setup/

RUN ./db-setup.sh
RUN ./db-pack.sh

VOLUME $PGDATA

EXPOSE 5432

ENTRYPOINT [ "/opt/setup/db-run.sh" ]

CMD [ "postgres" ]