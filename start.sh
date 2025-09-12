#!/bin/bash

# -----------------------------
# Prometheus 실행 (내부 포트 9090)
# -----------------------------
# nohup을 사용하여 백그라운드로 실행하고, 출력을 리디렉션하여 터미널에 종속되지 않게 합니다.
nohup /prometheus/prometheus --config.file=/prometheus/prometheus.yml --web.listen-address=0.0.0.0:9090 > /dev/null 2>&1 &

# Grafana가 종료되면 Prometheus도 함께 종료되도록 trap 설정
# 이 코드는 Render가 컨테이너를 종료할 때 모든 프로세스를 정리하는 데 도움이 됩니다.
trap 'kill $(jobs -p)' EXIT

# -----------------------------
# Grafana 실행 (Render의 $PORT 사용)
# -----------------------------
# Render 환경에서 자동으로 제공하는 $PORT 환경 변수를 사용하도록 Grafana 포트를 설정합니다.
export GF_SERVER_HTTP_PORT=${PORT}

# Grafana를 포그라운드(Foreground)에서 실행하여 Docker 컨테이너의 메인 프로세스로 만듭니다.
/grafana/bin/grafana-server web