FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

RUN adduser --disabled-password --gecos '' appuser
USER appuser

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]