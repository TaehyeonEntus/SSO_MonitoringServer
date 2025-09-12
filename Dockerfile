# 베이스 이미지: Ubuntu
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    bash \
    curl \
    jq \
    openjdk-17-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/apt/lists/*

WORKDIR /app

# -----------------------------
# Prometheus 설치 (최신 버전 자동 다운로드)
# -----------------------------
RUN LATEST_PROMETHEUS_VERSION=$(curl -sL https://api.github.com/repos/prometheus/prometheus/releases/latest | jq -r ".tag_name") \
    && PROMETHEUS_URL="https://github.com/prometheus/prometheus/releases/download/${LATEST_PROMETHEUS_VERSION}/prometheus-${LATEST_PROMETHEUS_VERSION:1}.linux-amd64.tar.gz" \
    && echo "Downloading Prometheus from: $PROMETHEUS_URL" \
    && wget -O prometheus.tar.gz "$PROMETHEUS_URL" \
    && tar xvf prometheus.tar.gz \
    && mv prometheus-*/ /prometheus \
    && rm prometheus.tar.gz

COPY prometheus.yml /prometheus/prometheus.yml

# -----------------------------
# Grafana 설치 (최신 버전 자동 다운로드)
# -----------------------------
ENV GF_SECURITY_ADMIN_PASSWORD=admin
ENV GF_PATHS_DATA=/grafana/data
ENV GF_PATHS_HOME=/grafana

RUN LATEST_GRAFANA_VERSION=$(curl -sL https://api.github.com/repos/grafana/grafana/releases/latest | jq -r ".tag_name") \
    && GRAFANA_URL="https://dl.grafana.com/oss/release/grafana-${LATEST_GRAFANA_VERSION:1}.linux-amd64.tar.gz" \
    && echo "Downloading Grafana from: $GRAFANA_URL" \
    && wget -O grafana.tar.gz "$GRAFANA_URL" \
    && tar -zxvf grafana.tar.gz \
    && mv grafana-* /grafana \
    && rm grafana.tar.gz

# -----------------------------
# 실행 스크립트
# -----------------------------
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Render는 EXPOSE 포트를 무시하고 $PORT 환경 변수를 사용합니다.
EXPOSE 10000 9090

# CMD로 스크립트 실행
CMD ["/start.sh"]