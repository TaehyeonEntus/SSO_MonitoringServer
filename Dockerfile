# 베이스 이미지: Ubuntu 22.04
FROM ubuntu:22.04

# 컨테이너 빌드 중 사용자 입력 비활성화
ENV DEBIAN_FRONTEND=noninteractive

# 필수 패키지 설치
# wget, tar, bash, curl: 다운로드 및 압축 해제에 필요
# jq: JSON 데이터를 파싱하기 위해 필요
# openjdk-17-jdk: Java 기반 서비스가 필요한 경우
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    bash \
    curl \
    jq \
    openjdk-17-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# -----------------------------
# Prometheus 설치 (안정적인 최신 버전 직접 명시)
# -----------------------------
# GitHub API 사용 시 빌드 일관성 문제를 해결하기 위해,
# 가장 안정적인 최신 버전(v2.50.1)을 직접 명시합니다.
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.50.1/prometheus-2.50.1.linux-amd64.tar.gz \
    && tar xvf prometheus-2.50.1.linux-amd64.tar.gz \
    && mv prometheus-2.50.1.linux-amd64 /prometheus \
    && rm prometheus-2.50.1.linux-amd64.tar.gz

# Prometheus 설정 파일 복사
COPY prometheus.yml /prometheus/prometheus.yml

# -----------------------------
# Grafana 설치 (안정적인 최신 버전 직접 명시)
# -----------------------------
# Prometheus와 마찬가지로, 안정성을 위해 최신 버전(10.4.2)을 직접 명시합니다.
ENV GF_SECURITY_ADMIN_PASSWORD=admin
ENV GF_PATHS_DATA=/grafana/data
ENV GF_PATHS_HOME=/grafana

RUN wget https://dl.grafana.com/oss/release/grafana-10.4.2.linux-amd64.tar.gz \
    && tar -zxvf grafana-10.4.2.linux-amd64.tar.gz \
    && mv grafana-10.4.2 /grafana \
    && rm grafana-10.4.2.linux-amd64.tar.gz

# -----------------------------
# 실행 스크립트 및 포트 설정
# -----------------------------
# start.sh 스크립트를 컨테이너에 복사
COPY start.sh /start.sh
# 스크립트 실행 권한 부여
RUN chmod +x /start.sh

# Render는 EXPOSE를 무시하고 $PORT를 사용하지만, 내부 통신을 위해 9090을 명시
EXPOSE 10000 9090

# 컨테이너가 시작될 때 실행될 명령어
CMD ["/start.sh"]