FROM python:3.9-alpine3.13
LABEL maintainer="jrod201d"

ENV PYTHONUNBUFFERED 1

COPY ./required_into.txt /tmp/required_into.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /srv
WORKDIR /srv
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
    build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/required_into.txt && \
    if [ $DEV = "true" ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
    --disabled-password \
    --no-create-home \
    server-user

ENV PATH="/py/bin:$PATH"

USER server-user