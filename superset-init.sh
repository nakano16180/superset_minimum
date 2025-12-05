#!/usr/bin/env bash
set -e

# 必要なら docker-compose 側から上書きできるようにデフォルト値を用意
: "${SUPERSET_ADMIN_USERNAME:=admin}"
: "${SUPERSET_ADMIN_FIRSTNAME:=Admin}"
: "${SUPERSET_ADMIN_LASTNAME:=User}"
: "${SUPERSET_ADMIN_EMAIL:=admin@example.com}"
: "${SUPERSET_ADMIN_PASSWORD:=admin}"

echo ">>> Running superset db upgrade..."
superset db upgrade

echo ">>> Creating admin user (if not exists)..."
superset fab create-admin \
  --username "${SUPERSET_ADMIN_USERNAME}" \
  --firstname "${SUPERSET_ADMIN_FIRSTNAME}" \
  --lastname "${SUPERSET_ADMIN_LASTNAME}" \
  --email "${SUPERSET_ADMIN_EMAIL}" \
  --password "${SUPERSET_ADMIN_PASSWORD}" \
  || true
# すでに admin がいる場合はエラーになるので、失敗しても無視

echo ">>> Running superset init..."
superset init

if [ "$SUPERSET_LOAD_EXAMPLES" = "yes" ]; then
  echo ">>> Loading examples..."
  superset load_examples
fi

echo ">>> Starting Superset web server..."
# 公式イメージに入っているサーバ起動スクリプト
exec /usr/bin/run-server.sh
