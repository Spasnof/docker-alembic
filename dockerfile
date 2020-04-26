FROM python:3-buster

RUN pip install pipenv
RUN apt update && apt install -y sqlite3 && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

COPY docker-alembic_project /app/docker-alembic_project
WORKDIR /app/docker-alembic_project
RUN pipenv install
# NOTE run this if we need to reinitialize how to create a db.
# RUN pipenv run alembic init alembic

ENTRYPOINT [ "pipenv", "run" ,"alembic" ]