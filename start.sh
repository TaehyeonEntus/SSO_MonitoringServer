#!/bin/bash

# -----------------------------
# Prometheus 실행 (내부 포트 9090)
# -----------------------------
nohup /prometheus/prometheus --config.file=/prometheus/prometheus.yml --web.listen-address=0.0.0.0:9090 > /dev/null 2>&1 &

trap 'kill $(jobs -p)' EXIT

# -----------------------------
# Grafana 실행 (Render의 $PORT 사용)
# -----------------------------
export GF_SERVER_HTTP_PORT=${PORT}

# --homepath 인자를 추가하여 Grafana 설치 경로를 명시
/grafana/bin/grafana-server --homepath="/grafana" web