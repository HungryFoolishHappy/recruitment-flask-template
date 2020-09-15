FROM python:3.8.5-slim AS python-base

ENV PYTHONUNBUFFERED=1 \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  POETRY_HOME="/opt/poetry" \
  POETRY_NO_INTERACTION=1 \
  VENV_PATH="/opt/venv"

ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"
RUN python -m venv /opt/venv

FROM python-base AS builder-base
RUN apt-get update && \
  apt-get install --no-install-recommends -y curl build-essential
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

WORKDIR /opt/pysetup
COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false
RUN poetry install


FROM python-base
WORKDIR /app
USER daemon
COPY --from=builder-base --chown=daemon $VENV_PATH $VENV_PATH

ENV FLASK_APP=main.py FLASK_ENV=development

COPY ${FLASK_APP} .

CMD [ "flask", "run", "--host=0.0.0.0" ]
