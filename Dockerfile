FROM python:3.11-buster AS builder
WORKDIR /app

RUN pip install --upgrade pip && pip install poetry

COPY pyproject.toml /app/pyproject.toml
COPY poetry.lock /app/poetry.lock

RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-interaction --no-ansi --with dev

FROM python:3.11-buster AS app
WORKDIR /app

COPY --from=builder /app /app
EXPOSE 8000
COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]


RUN pip install uvicorn
RUN pip install fastapi
RUN pip install psycopg2-binary
RUN pip install httpx
RUN pip install pydantic

CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]

