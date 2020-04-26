FROM python:3-buster

RUN pip install pipenv

RUN mkdir /app
WORKDIR /app

COPY docker-alembic_project /app/docker-alembic_project
WORKDIR /app/docker-alembic_project
RUN pipenv install
# RUN pipenv run alembic init alembic

ENTRYPOINT [ "pipenv", "run" ,"alembic" ]