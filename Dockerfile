FROM python:3.9-alpine3.13
LABEL maintainer="jrodg"

ENV PYTHONUNBUFFERED 1

COPY ./required_into.txt /tmp/required_into.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/required_into.txt && \
    rm -rf /tmp && \
    adduser \
    --disabled-password \
    --no-create-home \
    server-user

ENV PATH="/py/bin:$PATH"

USER server-user