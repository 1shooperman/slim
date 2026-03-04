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

## Commit message hook (prepare-commit-msg)

The hook uses the Ollama container to suggest a commit message from your staged diff. When you run `git commit` (without `-m`), the hook sends the diff and prompt to Ollama and pre-fills the commit message file so your editor opens with the suggestion.

### Prerequisites

1. **Ollama container running** (build and run as above).
2. **SLM_ROOT** or **git config --global slm.root**: path to this slm repo so the hook can read `prompts/COMMIT_MSG.md`. With `make install-global`, `slm.root` is set for you; otherwise set the env or config yourself.

### Global install (all new repos)

One-time setup so every **new** repo gets the hook; no per-repo steps. Run from the slm repo:

```bash
make install-global
```

This:

- Creates `~/.git_templates/hooks` and installs a `prepare-commit-msg` wrapper there.
- Sets `git config --global init.templatedir` to `~/.git_templates` so new repos (e.g. `git init` or `git clone`) get the hook automatically.
- Sets `git config --global slm.root` to the path of this slm repo so the hook knows where to find prompts; no per-repo env needed.

**Note:** Repos that already exist do not get the hook unless you run `git init` again (not recommended) or install the hook in that repo once (e.g. `make install-hook` from the slm repo after `cd` to that repo, or copy the hook as below).

### Per-repo install

Use the hook from any git repo. The diff is taken from the repo where you run `git commit`; the prompt text comes from this slm repo.

- **From the slm repo:** `make install-hook` installs into the **current** repo's `.git/hooks` (run it from the repo you want to add the hook to). The wrapper sets `SLM_ROOT` to the slm repo.
- **Manual:** Set `git config --global slm.root /path/to/slm` once; the hook script reads it when `SLM_ROOT` is unset. Then copy the wrapper from `~/.git_templates/hooks/prepare-commit-msg` into `<repo>/.git/hooks/prepare-commit-msg` and `chmod +x` it.

### Optional: OLLAMA_HOST

If Ollama is not on `localhost:11434`, set `OLLAMA_HOST` (e.g. `http://host:11434`) in the same way you set `SLM_ROOT` (wrapper or env that the hook runs under).
