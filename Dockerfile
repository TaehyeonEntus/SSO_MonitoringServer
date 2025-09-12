# 베이스 이미지: Ubuntu
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    bash \
    curl \
    openjdk-17-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# -----------------------------
# Prometheus 설치
# -----------------------------
RUN wget https://github.com/prometheus/prometheus/releases/download/v3.5.0/prometheus-3.5.0.linux-amd64.tar.gz \
    && tar xvf prometheus-3.5.0.linux-amd64.tar.gz \
    && mv prometheus-3.5.0.linux-amd64 /prometheus \
    && rm prometheus-3.5.0.linux-amd64.tar.gz


COPY prometheus.yml /prometheus/prometheus.yml

# -----------------------------
# Grafana 설치
# -----------------------------
ENV GF_SECURITY_ADMIN_PASSWORD=admin
ENV GF_PATHS_DATA=/grafana/data
ENV GF_PATHS_HOME=/grafana

RUN wget https://dl.grafana.com/oss/release/grafana-12.1.0.linux-amd64.tar.gz \
    && tar -zxvf grafana-12.1.0.linux-amd64.tar.gz \
    && mv grafana-12.1.0.linux-amd64 /grafana \
    && rm grafana-12.1.0.linux-amd64.tar.gz



# -----------------------------
# 실행 스크립트
# -----------------------------
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Grafana 외부 포트 + Prometheus 내부 포트
EXPOSE 10000 9090

CMD ["/start.sh"]
