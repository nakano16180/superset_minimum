FROM apache/superset:latest

USER root

# Install packages using uv into the virtual environment
RUN . /app/.venv/bin/activate && \
    uv pip install \
    # install psycopg2 for using PostgreSQL metadata store - could be a MySQL package if using that backend:
    psycopg2-binary \
    # install ClickHouse connector:
    clickhouse-connect \
    # package needed for using single-sign on authentication:
    Authlib 

COPY --chown=superset superset_config.py /app/docker/superset_config.py
# 起動時に毎回 db upgrade / init / admin 作成をやるスクリプト
COPY --chown=superset superset-init.sh /app/superset-init.sh
RUN chmod +x /app/superset-init.sh

USER superset

# 公式の ENTRYPOINT の代わりに自前スクリプトを起動
ENTRYPOINT ["/app/superset-init.sh"]