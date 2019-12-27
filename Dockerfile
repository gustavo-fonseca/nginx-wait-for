FROM nginx:1.17

LABEL maintainer="Gustavo Fonseca <contato@gustavofonseca.com.br>"

ENV WAIT_FOR 0
ENV WAIT_FOR_TIMEOUT 15

COPY ./wait-for.sh /
COPY ./entrypoint.sh /

RUN apt-get -q update && \
    apt-get -qy install netcat && \
    rm -rf /var/lib/apt/lists/*

RUN chmod +x /wait-for.sh /entrypoint.sh && \
    sed -i 's/WAIT_FOR/${WAIT_FOR}/g' /entrypoint.sh && \
    sed -i 's/TIMEOUT/${WAIT_FOR_TIMEOUT}/g' /entrypoint.sh

ENTRYPOINT /entrypoint.sh
