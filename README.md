# Ollama (single container)

Ollama server with `phi3:mini` pre-pulled on first start. Runs as a single Docker container (no docker-compose).

## Build

```bash
docker build -t ollama .
```

## Run

```bash
docker run -d -p 11434:11434 -v ollama_data:/root/.ollama --name slim-ollama ollama
```

- **Port:** Ollama API is available on `11434`.
- **Volume:** `ollama_data` is a named volume for model data. To use a host path instead: `-v /path/on/host:/root/.ollama`.
