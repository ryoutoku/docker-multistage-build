# syntax=docker/dockerfile:1

################################################
# copy files
################################################
FROM python:3.10.5-slim-buster AS builder_core

WORKDIR /tmp

COPY Pipfile ./
COPY Pipfile.lock ./


################################################
# install modules for production
################################################
FROM builder_core as builder_production

RUN pip install --upgrade --no-cache-dir pip==22.1.2 && \
    pip install --no-cache-dir pipenv==2022.6.7 && \
    python -m pipenv sync --system && \
    pip uninstall -y pipenv


################################################
# install modules for development
################################################
FROM builder_core as builder_development

RUN pip install --upgrade --no-cache-dir pip==22.1.2 && \
    pip install --no-cache-dir pipenv==2022.6.7 && \
    python -m pipenv sync --system --dev && \
    pip uninstall -y pipenv


################################################
# base image for execution
################################################
FROM python:3.10.5-slim-buster as execution_base

ENV PYTHONUNBUFFERED=1 \
    ROOT_PATH=/app \
    USER_NAME=django

RUN useradd -m -u 1000 ${USER_NAME} && \
    mkdir ${ROOT_PATH} && \
    chown ${USER_NAME} ${ROOT_PATH}

USER ${USER_NAME}

WORKDIR ${ROOT_PATH}
COPY --from=builder_core /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages


################################################
# production environment
################################################
FROM execution_base as production
COPY --from=builder_production /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages


################################################
# development environment
################################################
FROM execution_base as development
COPY --from=builder_development /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
