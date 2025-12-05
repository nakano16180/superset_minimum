FROM apache/superset:latest

USER root

RUN pip install duckdb-engine
RUN pip install clickhouse-connect

# 起動時に毎回 db upgrade / init / admin 作成をやるスクリプト
COPY --chown=superset superset-init.sh /app/superset-init.sh
RUN chmod +x /app/superset-init.sh

USER superset

# 公式の ENTRYPOINT の代わりに自前スクリプトを起動
ENTRYPOINT ["/app/superset-init.sh"]