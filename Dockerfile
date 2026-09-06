FROM python:3.12-slim

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY app.py .

ENV PORT=8080
EXPOSE 8080

CMD ["python", "app.py"]
