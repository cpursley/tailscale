FROM debian:buster
WORKDIR /render

ARG TAILSCALE_VERSION
ENV TAILSCALE_VERSION=$TAILSCALE_VERSION

RUN apt-get -qq update \
  && apt-get -qq install --upgrade -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    netcat-traditional \
    wget \
    dnsutils \
  > /dev/null \
  && apt-get -qq clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
  && true

RUN echo "+search +short" > /root/.digrc

COPY run-tailscale.sh /render/
RUN chmod +x /render/run-tailscale.sh

COPY install-tailscale.sh /render/
RUN chmod +x /render/install-tailscale.sh
RUN /render/install-tailscale.sh && rm /render/install-tailscale.sh

CMD ["./run-tailscale.sh"]
