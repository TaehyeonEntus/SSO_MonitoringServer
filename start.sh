#!/bin/bash

# -----------------------------
# Prometheus 실행 (내부 포트 9090)
# -----------------------------
prometheus --config.file=/prometheus/prometheus.yml --web.listen-address=0.0.0.0:9090 &

# -----------------------------
# Grafana 실행 (외부 포트 $PORT)
# -----------------------------
# Render에서 자동으로 제공되는 환경변수 $PORT 사용
export GF_SERVER_HTTP_PORT=${PORT:-10000}

/grafana/bin/grafana-server web
