FROM alpine:latest

LABEL maintainer="26378591+blacksheepaul@users.noreply.github.com" \
      version="1.0" \
      description="Minimal Prometheus on Alpine Linux"

ENV PROMETHEUS_VERSION=3.7.3

RUN adduser -s /bin/false -D -H prometheus \
    && apk update \
    && apk --no-cache add curl ca-certificates \
    && curl -LO https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz \
    && tar -xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz \
    && mkdir -p /etc/prometheus /prometheus \
    && cp prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /bin/ \
    && cp prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool /bin/ \
    && cp prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml.default \
    && rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64* \
    && chown -R prometheus:prometheus /etc/prometheus /prometheus \
    && chmod -R g+w /prometheus \
    && apk del curl

COPY conf/prometheus.yml /etc/prometheus/prometheus.yml
COPY conf/alert.rules /etc/prometheus/alert.rules

# 设置工作目录和用户
WORKDIR /prometheus
USER prometheus

EXPOSE 9090

VOLUME ["/prometheus"]

ENTRYPOINT ["/bin/prometheus"]
CMD ["--config.file=/etc/prometheus/prometheus.yml", \
     "--storage.tsdb.path=/prometheus", \
     "--web.console.libraries=/etc/prometheus/console_libraries", \
     "--web.console.templates=/etc/prometheus/consoles"]
